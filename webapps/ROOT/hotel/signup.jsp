<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();

    String user_pw = request.getParameter("user_pw");
    String hotel_name = request.getParameter("hotel_name");

    // SHA-256 해시 생성
    String hashedPassword = null;
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
        jsonResponse.put("success", false);
        jsonResponse.put("error_message", "Password hashing failed.");
        outWriter.print(jsonResponse.toString());
        return;
    }

    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
    
        // hotel_name으로 hotel_id 조회
        String queryHotelId = "SELECT hotel_id FROM hotel_info_list WHERE hotel_name = ?";
        ps = conn.prepareStatement(queryHotelId);
        ps.setString(1, hotel_name);
        rs = ps.executeQuery();

        if (rs.next()) {
            String hotel_id = rs.getString("hotel_id");

            // hotel_member_list에 데이터 삽입
            String sql = "INSERT INTO hotel_member_list(user_email, user_pw, user_name, user_tel, hotel_id) VALUES(?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, request.getParameter("user_email"));
            ps.setString(2, hashedPassword);
            ps.setString(3, request.getParameter("user_name"));
            ps.setString(4, request.getParameter("user_tel"));
            ps.setString(5, hotel_id);

            ps.executeUpdate();

            jsonResponse.put("success", true);
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("error_message", "Invalid hotel name.");
        }
    } catch (Exception e) {
        jsonResponse.put("success", false);
        jsonResponse.put("error_message", e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        outWriter.print(jsonResponse.toString());
    }
%>

