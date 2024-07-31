<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();

    String travel_pw = request.getParameter("travel_pw");
    String agency_name = request.getParameter("agency_name");

    // SHA-256 해시 생성
    String hashedPassword = null;
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
        jsonResponse.put("success", false);
        jsonResponse.put("error_message", "Password hashing failed.");
        outWriter.print(jsonResponse.toString());
        return;
    }
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        // agency_name으로 agency_id 조회
        String queryAgencyId = "SELECT agency_id FROM travel_info_list WHERE agency_name = ?";
        ps = conn.prepareStatement(queryAgencyId);
        ps.setString(1, agency_name);
        rs = ps.executeQuery();

        if (rs.next()) {
            String agency_id = rs.getString("agency_id");

            // travel_member_list에 데이터 삽입
            String sql = "INSERT INTO travel_member_list(travel_email, travel_pw, travel_name, travel_tel, agency_id) VALUES(?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, request.getParameter("travel_email"));
            ps.setString(2, hashedPassword);
            ps.setString(3, request.getParameter("travel_name"));
            ps.setString(4, request.getParameter("travel_tel"));
            ps.setString(5, agency_id);

            ps.executeUpdate();

            jsonResponse.put("success", true);
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("error_message", "Invalid agency name.");
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
