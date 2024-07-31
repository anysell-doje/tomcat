<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 데이터베이스에서 사용자 인증을 위한 쿼리 실행
    String sqlQuery = "SELECT user_email FROM hotel_member_list WHERE user_email = ?";
    PreparedStatement ps = conn.prepareStatement(sqlQuery);
    ps.setString(1, request.getParameter("user_email"));
    ResultSet rs = ps.executeQuery();

    
    

    // JSON 응답을 위한 PrintWriter 설정
    PrintWriter outWriter = response.getWriter();

    try {
        if(rs.next()){
            String sqlQuery1 = "UPDATE hotel_member_list set user_email = ? WHERE user_email = ?";
            PreparedStatement ps1 = conn.prepareStatement(sqlQuery1);
            ps1.setString(1, request.getParameter("new_email")); // 해시된 비밀번호 사용
            ps1.setString(2, request.getParameter("user_email"));
            
            ps1.executeUpdate();

            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", true);

            outWriter.print(jsonResponse.toString());
        } else {
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
