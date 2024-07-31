<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    String userEmail = request.getParameter("travel_email");
    String userPassword = request.getParameter("travel_pw");

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
            String sqlQuery = "SELECT tm.*, ti.agency_name " +
                              "FROM travel_member_list tm " +
                              "JOIN travel_info_list ti ON tm.agency_id = ti.agency_id " +
                              "WHERE tm.travel_email = ?";
            PreparedStatement ps = null;
            ResultSet rs = null;
            PrintWriter outWriter = response.getWriter();

            try {
                ps = conn.prepareStatement(sqlQuery);
                ps.setString(1, userEmail);
                rs = ps.executeQuery();

                JSONObject jsonResponse = new JSONObject();

                if (rs != null && rs.next()) {
                    String dbPassword = rs.getString("travel_pw");
                    int approveStatus = rs.getInt("travel_approve_status");

                    if (dbPassword.equals(hashedPassword)) {
                        if (approveStatus == 1) {
                            JSONObject travelData = new JSONObject();
                            travelData.put("travel_email", rs.getString("travel_email"));
                            travelData.put("travel_name", rs.getString("travel_name"));
                            travelData.put("travel_tel", rs.getString("travel_tel"));
                            travelData.put("agency_id", rs.getString("agency_id"));
                            travelData.put("agency_name", rs.getString("agency_name"));
                            jsonResponse.put("success", true);
                            jsonResponse.put("travelData", travelData);
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

