<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");

    PreparedStatement ps = null;
    ResultSet rs = null;
    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();

    try {
        // 요청 파라미터 가져오기
        String user_email = request.getParameter("user_email");
        String user_pw = request.getParameter("user_pw");
        String user_name = request.getParameter("user_name");
        String user_tel = request.getParameter("user_tel");
        String sep = request.getParameter("sep");

        // 비밀번호 해시 처리
        String hashedPassword = null;
        if (user_pw != null) {
            try {
                MessageDigest digest = MessageDigest.getInstance("SHA-256");
                byte[] hash = digest.digest(user_pw.getBytes("UTF-8"));
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
        }

        String sqlQuery = "";
        switch (sep) {
            case "1":
                sqlQuery = "UPDATE hotel_member_list SET user_email = ? WHERE user_email = ?";
                ps = conn.prepareStatement(sqlQuery);
                ps.setString(1, user_email);
                ps.setString(2, user_email);
                break;
            case "2":
                sqlQuery = "UPDATE hotel_member_list SET user_pw = ? WHERE user_email = ?";
                ps = conn.prepareStatement(sqlQuery);
                ps.setString(1, hashedPassword);
                ps.setString(2, user_email);
                break;
            case "3":
                sqlQuery = "UPDATE hotel_member_list SET user_name = ? WHERE user_email = ?";
                ps = conn.prepareStatement(sqlQuery);
                ps.setString(1, user_name);
                ps.setString(2, user_email);
                break;
            case "4":
                sqlQuery = "UPDATE hotel_member_list SET user_tel = ? WHERE user_email = ?";
                ps = conn.prepareStatement(sqlQuery);
                ps.setString(1, user_tel);
                ps.setString(2, user_email);
                break;
            default:
                jsonResponse.put("success", false);
                jsonResponse.put("error", "Invalid sep value");
                outWriter.print(jsonResponse.toString());
                if (outWriter != null) outWriter.close();
                return;
        }

        int updateCount = ps.executeUpdate();
        if (updateCount > 0) {
            jsonResponse.put("success", true);
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("error", "No member found with the provided email.");
        }
    } catch (Exception e) {
        jsonResponse.put("success", false);
        jsonResponse.put("error", e.getMessage());
    } finally {
        // 자원 해제
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    outWriter.print(jsonResponse.toString());
    if (outWriter != null) outWriter.close();
%>

