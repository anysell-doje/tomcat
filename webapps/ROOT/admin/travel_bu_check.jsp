<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 데이터베이스에서 여행사 정보를 위한 쿼리 실행
    String sqlQuery = "SELECT agency_id, agency_name, agency_address, agency_tel, ceo_name FROM travel_info_list_copy";

    JSONObject responseJson = new JSONObject();
    JSONArray agencyArray = new JSONArray();

    try (PreparedStatement ps = conn.prepareStatement(sqlQuery); 
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            JSONObject agency = new JSONObject();
            agency.put("agency_name", rs.getString("agency_name"));
            agency.put("agency_address", rs.getString("agency_address"));
            agency.put("agency_tel", rs.getString("agency_tel"));
            agency.put("ceo_name", rs.getString("ceo_name"));
            agencyArray.put(agency);
        }

        responseJson.put("agency_list", agencyArray);
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

