<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // JSON 응답을 위한 PrintWriter 설정
    PrintWriter outWriter = response.getWriter();

    try {
            // 변경 가능할 경우, 업데이트 쿼리 실행
            String sqlQuery = "UPDATE inquiry_info_list SET travel_reservation_status = ? WHERE reservation_id = ?";
            PreparedStatement ps = conn.prepareStatement(sqlQuery);
            ps.setString(1, request.getParameter("travel_reservation_status"));
            ps.setString(2, request.getParameter("reservation_id"));
            int rowsAffected = ps.executeUpdate();

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
    }
    conn.close();
%>


