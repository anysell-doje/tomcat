<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 데이터베이스에서 사용자 인증을 위한 쿼리 실행
    String sqlQuery = "SELECT tml.travel_email, tml.travel_name, tml.travel_tel, tml.travel_approve_status, til.agency_name " +
                      "FROM travel_member_list tml " +
                      "JOIN travel_info_list til ON tml.agency_id = til.agency_id " +
                      "WHERE tml.travel_approve_status = 0";

    JSONObject responseJson = new JSONObject();
    JSONArray statusArray = new JSONArray();

    try (PreparedStatement ps = conn.prepareStatement(sqlQuery); 
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            JSONObject status = new JSONObject();
            status.put("travel_email", rs.getString("travel_email"));
            status.put("travel_name", rs.getString("travel_name"));
            status.put("travel_tel", rs.getString("travel_tel"));
            status.put("travel_status", rs.getString("travel_approve_status"));
            status.put("agency_name", rs.getString("agency_name")); // 에이전시 이름 추가
            statusArray.put(status);
        }

        responseJson.put("travel_list", statusArray);
        responseJson.put("success", true);
    } catch (SQLException e) {
        responseJson.put("success", false);
        responseJson.put("error_message", e.getMessage());
    }

    // JSON 응답을 위한 PrintWriter 설정
    try (PrintWriter outWriter = response.getWriter()) {
        outWriter.println(responseJson.toString());
    }

    // 연결 닫기
    conn.close();
%>
