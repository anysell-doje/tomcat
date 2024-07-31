<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");

    String to_date = request.getParameter("to_date");
    String from_date = request.getParameter("from_date");
    String agency_id = request.getParameter("agency_id");

    PreparedStatement ps = null;
    ResultSet rs = null;
    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();
    JSONArray usedArray = new JSONArray();

    try {
        // hotel
        String sqlQuery = "SELECT " +
                          "SUM(a.room_count) AS room_count, " +
                          "FORMAT(SUM(a.hotel_price), 0) AS price, " +
                          "COUNT(a.reservation_id) AS reservation_count " +
                          "FROM inquiry_info_list a " +
                          "INNER JOIN travel_info_list b ON a.agency_id = b.agency_id " +
                          "WHERE a.travel_reservation_status = 2 " +
                          "AND a.hotel_reservation_status = 2 " +
                          "AND a.check_out_date BETWEEN ? AND ? AND a.agency_id = ? ";

        ps = conn.prepareStatement(sqlQuery);
        ps.setString(1, from_date);
        ps.setString(2, to_date);
        ps.setString(3, agency_id);
        rs = ps.executeQuery();

        while (rs.next()) {
            JSONObject used = new JSONObject();
            used.put("room_count", rs.getInt("room_count"));
            used.put("total_price", rs.getString("price"));
            used.put("reservation_count", rs.getInt("reservation_count"));
            usedArray.put(used);
        }

        jsonResponse.put("success", true);
        jsonResponse.put("used_list", usedArray);

    } catch (Exception e) {
        e.printStackTrace();
        jsonResponse.put("success", false);
        jsonResponse.put("error", e.getMessage());
    } finally {
        // 자원 해제
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    outWriter.print(jsonResponse.toString());
    outWriter.flush(); // 버퍼를 비우기
    outWriter.close();
%>
