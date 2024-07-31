<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    // 필요한 파라미터들을 요청에서 가져옵니다.
    String agency_name = request.getParameter("agency_name");
    String agency_address = request.getParameter("agency_address");
    String agency_tel = request.getParameter("agency_tel");
    String ceo_name = request.getParameter("ceo_name");

    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();

    PreparedStatement ps = null;

    try {
        // travel_info_list 테이블에 데이터를 삽입하는 SQL 쿼리
        String sql = "insert into travel_info_list_copy(agency_name, agency_address, agency_tel, ceo_name) values(?, ?, ?, ?)";
        ps = conn.prepareStatement(sql);
        ps.setString(1, agency_name);
        ps.setString(2, agency_address);
        ps.setString(3, agency_tel);
        ps.setString(4, ceo_name);
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

