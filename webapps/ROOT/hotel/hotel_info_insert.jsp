<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    // 필요한 파라미터들을 요청에서 가져옵니다.
    String hotel_ceo_name = request.getParameter("hotel_ceo_name");
    String hotel_tel = request.getParameter("hotel_tel");
    String hotel_name = request.getParameter("hotel_name");
    String hotel_address = request.getParameter("hotel_address");

    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();

    PreparedStatement ps = null;

    try {
        // hotel_info_list 테이블에 데이터를 삽입하는 SQL 쿼리
        String sql = "INSERT INTO hotel_info_list_copy(hotel_ceo_name, hotel_tel, hotel_name, hotel_address) VALUES (?, ?, ?, ?)";
        ps = conn.prepareStatement(sql);
        ps.setString(1, hotel_ceo_name);
        ps.setString(2, hotel_tel);
        ps.setString(3, hotel_name);
        ps.setString(4, hotel_address);
        ps.executeUpdate();

        jsonResponse.put("success", true);
        outWriter.print(jsonResponse.toString());
    } catch(Exception e){
        jsonResponse.put("success", false);
        jsonResponse.put("error_message", e.getMessage()); // 예외 메시지 추가
        e.printStackTrace(); // 콘솔에 예외 스택 트레이스 출력
        outWriter.print(jsonResponse.toString());
    } finally {
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

