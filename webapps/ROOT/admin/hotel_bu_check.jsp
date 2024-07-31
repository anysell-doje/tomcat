<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 데이터베이스에서 호텔 정보를 위한 쿼리 실행
    String sqlQuery = "SELECT hotel_id, hotel_name, hotel_ceo_name, hotel_tel, hotel_address " +
                      "FROM hotel_info_list_copy";

    JSONObject responseJson = new JSONObject();
    JSONArray hotelArray = new JSONArray();

    try (PreparedStatement ps = conn.prepareStatement(sqlQuery); 
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            JSONObject hotel = new JSONObject();
            hotel.put("hotel_name", rs.getString("hotel_name"));
            hotel.put("hotel_ceo_name", rs.getString("hotel_ceo_name"));
            hotel.put("hotel_tel", rs.getString("hotel_tel"));
            hotel.put("hotel_address", rs.getString("hotel_address"));
            hotelArray.put(hotel);
        }

        responseJson.put("hotel_list", hotelArray);
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

