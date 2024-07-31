<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    String userEmail = request.getParameter("user_email");
    String userPassword = request.getParameter("user_pw");

    if (userEmail != null && userPassword != null) {
        String hashedPassword = null;
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(userPassword.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            hashedPassword = hexString.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (hashedPassword != null) {
            String sqlQuery = "SELECT hm.*, hi.hotel_name " +
                              "FROM hotel_member_list hm " +
                              "JOIN hotel_info_list hi ON hm.hotel_id = hi.hotel_id " +
                              "WHERE hm.user_email = ?";
            PreparedStatement ps = null;
            ResultSet rs = null;
            PrintWriter outWriter = response.getWriter();

            try {
                ps = conn.prepareStatement(sqlQuery);
                ps.setString(1, userEmail);
                rs = ps.executeQuery();

                JSONObject jsonResponse = new JSONObject();

                if (rs != null && rs.next()) {
                    String dbPassword = rs.getString("user_pw");
                    int approveStatus = rs.getInt("hotel_approve_status");

                    if (dbPassword.equals(hashedPassword)) {
                        if (approveStatus == 1) {
                            JSONObject userData = new JSONObject();
                            userData.put("user_email", rs.getString("user_email"));
                            userData.put("user_name", rs.getString("user_name"));
                            userData.put("user_tel", rs.getString("user_tel"));
                            userData.put("hotel_id", rs.getString("hotel_id"));
                            userData.put("hotel_name", rs.getString("hotel_name"));
                            jsonResponse.put("success", true);
                            jsonResponse.put("hotelData", userData);
                        } else {
                            jsonResponse.put("success", false);
                            jsonResponse.put("error", "Account not approved");
                        }
                    } else {
                        jsonResponse.put("success", false);
                        jsonResponse.put("error", "Incorrect password");
                    }
                } else {
                    jsonResponse.put("success", false);
                    jsonResponse.put("error", "Email not found");
                }

                outWriter.print(jsonResponse.toString());
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) {
                    try {
                        rs.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                if (ps != null) {
                    try {
                        ps.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        } else {
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", false);
            jsonResponse.put("error", "Password hashing failed");
            PrintWriter outWriter = response.getWriter();
            outWriter.print(jsonResponse.toString());
        }
    } else {
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("success", false);
        jsonResponse.put("error", "Email or password missing");
        PrintWriter outWriter = response.getWriter();
        outWriter.print(jsonResponse.toString());
    }
    conn.close();
%>

