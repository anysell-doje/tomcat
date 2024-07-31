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
        String travel_email = request.getParameter("travel_email");
        String travel_pw = request.getParameter("travel_pw");
        String travel_name = request.getParameter("travel_name");
        String travel_tel = request.getParameter("travel_tel");
        String sep = request.getParameter("sep");

        // 비밀번호 해시 처리
        String hashedPassword = null;
        if (travel_pw != null) {
            try {
                MessageDigest digest = MessageDigest.getInstance("SHA-256");
                byte[] hash = digest.digest(travel_pw.getBytes("UTF-8"));
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
                sqlQuery = "UPDATE travel_member_list SET travel_email = ? WHERE travel_email = ?";
                ps = conn.prepareStatement(sqlQuery);
                ps.setString(1, travel_email);
                ps.setString(2, travel_email);
                break;
            case "2":
                sqlQuery = "UPDATE travel_member_list SET travel_pw = ? WHERE travel_email = ?";
                ps = conn.prepareStatement(sqlQuery);
                ps.setString(1, hashedPassword);
                ps.setString(2, travel_email);
                break;
            case "3":
                sqlQuery = "UPDATE travel_member_list SET travel_name = ? WHERE travel_email = ?";
                ps = conn.prepareStatement(sqlQuery);
                ps.setString(1, travel_name);
                ps.setString(2, travel_email);
                break;
            case "4":
                sqlQuery = "UPDATE travel_member_list SET travel_tel = ? WHERE travel_email = ?";
                ps = conn.prepareStatement(sqlQuery);
                ps.setString(1, travel_tel);
                ps.setString(2, travel_email);
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

