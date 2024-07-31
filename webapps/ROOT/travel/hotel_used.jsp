<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");

    String to_date = request.getParameter("to_date");
    String from_date = request.getParameter("from_date");
    String hotel_id = request.getParameter("hotel_id");
    int total = 0;

    PreparedStatement ps = null;
    ResultSet rs = null;
    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();
    JSONArray usedArray = new JSONArray();

    try {
        // hotel
        String sqlQuery = "SELECT " +
                          "COUNT(a.reservation_id) AS used_count, " +
                          "SUM(a.hotel_price) AS price, " +
                          "SUM(a.room_count) AS total_room " +
                          "FROM inquiry_info_list a " +
                          "INNER JOIN hotel_info_list b ON a.hotel_id = b.hotel_id " +
                          "WHERE (a.travel_reservation_status = 2 AND a.hotel_reservation_status = 2) " +
                          "AND a.check_out_date BETWEEN ? AND ? and a.hotel_id = ? ";

        ps = conn.prepareStatement(sqlQuery);
        ps.setString(1, from_date);
        ps.setString(2, to_date);
        ps.setString(3, hotel_id);
        rs = ps.executeQuery();

        while (rs.next()) {
            JSONObject used = new JSONObject();
            used.put("used_count", rs.getInt("used_count"));
            used.put("total_price", rs.getDouble("price"));
            used.put("total_room", rs.getInt("total_room"));
            usedArray.put(used);
        }

        jsonResponse.put("success", true);
        jsonResponse.put("used_list", usedArray);

        // 자원 해제
        rs.close();
        ps.close();

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
    if (outWriter != null) outWriter.close();
%>

