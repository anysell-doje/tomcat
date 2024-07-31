<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    String sqlQuery = "SELECT hml.user_email, hml.user_name, hml.user_tel, hml.hotel_approve_status, hil.hotel_name " +
                      "FROM hotel_member_list hml " +
                      "JOIN hotel_info_list hil ON hml.hotel_id = hil.hotel_id " +
                      "WHERE hml.hotel_approve_status = 0";

    JSONObject responseJson = new JSONObject();
    JSONArray statusArray = new JSONArray();

    try (PreparedStatement ps = conn.prepareStatement(sqlQuery); 
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            JSONObject status = new JSONObject();
            status.put("user_email", rs.getString("user_email"));
            status.put("user_name", rs.getString("user_name"));
            status.put("user_tel", rs.getString("user_tel"));
            status.put("hotel_status", rs.getString("hotel_approve_status"));
            status.put("hotel_name", rs.getString("hotel_name")); // 호텔 이름 추가
            statusArray.put(status);
        }

        responseJson.put("hotel_list", statusArray);
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

