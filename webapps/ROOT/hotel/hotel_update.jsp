<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 사용자가 제공한 비밀번호를 해시화
    String user_pw = request.getParameter("user_pw");
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
        // 해시 생성 중에 발생하는 예외 처리
        e.printStackTrace();
    }

    // 데이터베이스에서 사용자 인증을 위한 쿼리 실행
    String sqlQuery = "UPDATE hotel_member_list set user_name = ?, user_tel = ? WHERE user_email = ? and user_pw = ?";
    PreparedStatement ps = conn.prepareStatement(sqlQuery);
    ps.setString(1, request.getParameter("user_name")); // 해시된 비밀번호 사용
    ps.setString(2, request.getParameter("user_tel"));
    ps.setString(3, request.getParameter("user_email"));
    ps.setString(4, hashedPassword);
    int rowsAffected = ps.executeUpdate();

    // JSON 응답을 위한 PrintWriter 설정
    PrintWriter outWriter = response.getWriter();

    try {
        if (rowsAffected > 0) {
            // 인증 성공 시 JSON 응답 데이터 생성
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", true);

            // JSON 응답 전송
            outWriter.print(jsonResponse.toString());
        } else {
            // 인증 실패 시 JSON 응답 데이터 생성
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", false);

            // JSON 응답 전송
            outWriter.print(jsonResponse.toString());
        }
    } catch (Exception e) {
        // SQL 관련 예외 처리
        e.printStackTrace();
    } finally {
        // PreparedStatement 닫기
        if (ps != null) {
            ps.close();
        }
    }
    conn.close();
%>
