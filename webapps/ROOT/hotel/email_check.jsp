<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    String sqlQuery = "SELECT user_email FROM hotel_member_list WHERE user_email = ?";
    PreparedStatement ps = conn.prepareStatement(sqlQuery);
    ps.setString(1, request.getParameter("user_email"));
    ResultSet rs = ps.executeQuery();

    // JSON 응답을 위한 PrintWriter 설정
    PrintWriter outWriter = response.getWriter();

    try {
        if (rs.next()) {
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

