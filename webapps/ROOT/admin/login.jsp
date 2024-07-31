<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 사용자가 제공한 비밀번호를 해시화
    String admin_pw = request.getParameter("admin_pw");
    String hashedPassword = null;
    try {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(admin_pw.getBytes("UTF-8"));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        hashedPassword = hexString.toString();
    } catch (Exception e) {
        // 해시 생성 중에 발생하는 예외 처리
        e.printStackTrace();
    }

    // 데이터베이스에서 사용자 인증을 위한 쿼리 실행
    String sqlQuery = "SELECT * FROM admin_accounts WHERE admin_id = ? AND admin_pw = ?";
    PreparedStatement ps = conn.prepareStatement(sqlQuery);
    ps.setString(1, request.getParameter("admin_id"));
    ps.setString(2, hashedPassword); // 해시된 비밀번호 사용
    ResultSet rs = ps.executeQuery();

    // JSON 응답을 위한 PrintWriter 설정
    PrintWriter outWriter = response.getWriter();

    try {
        if (rs.next()) {
            // 인증 성공 시 JSON 응답 데이터 생성
            JSONObject jsonResponse = new JSONObject();
            JSONObject adminData = new JSONObject();

            adminData.put("admin_id", rs.getString("admin_id"));
            adminData.put("admin_email", rs.getString("admin_email"));
	    adminData.put("admin_access_level", rs.getString("admin_access_level"));
            adminData.put("admin_name", rs.getString("admin_name"));
            adminData.put("admin_tel", rs.getString("admin_tel"));
            adminData.put("admin_created_at", rs.getString("admin_created_at"));

            jsonResponse.put("success", true);
            jsonResponse.put("adminData", adminData);

            // JSON 응답 전송
            outWriter.print(jsonResponse.toString());
        } else {
            // 인증 실패 시 JSON 응답 데이터 생성
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", false);

            // JSON 응답 전송
            outWriter.print(jsonResponse.toString());
        }
    } catch (SQLException e) {
        // SQL 관련 예외 처리
        e.printStackTrace();
    } finally {
        // ResultSet, PreparedStatement 닫기
        if (rs != null) {
            rs.close();
        }
        if (ps != null) {
            ps.close();
        }
    }
    conn.close();
%>
