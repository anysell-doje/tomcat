<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");

    String to_date = request.getParameter("to_date");
    String from_date = request.getParameter("from_date");

    PreparedStatement ps = null;
    ResultSet rs = null;
    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();
    JSONArray usedArray = new JSONArray();

    try {
        // hotel
        String sqlQuery = "SELECT b.agency_name, COUNT(a.reservation_id) AS cancel_count " +
                          "FROM inquiry_info_list a " +
                          "INNER JOIN travel_info_list b ON a.agency_id = b.agency_id " +
                          "WHERE (a.hotel_reservation_status = 3 OR a.travel_reservation_status = 3) " +
                          "AND cancel_date BETWEEN ? AND ? " +
                          "GROUP BY b.agency_name";

        ps = conn.prepareStatement(sqlQuery);
        ps.setString(1, from_date);
        ps.setString(2, to_date);

        rs = ps.executeQuery();

        while (rs.next()) {
            JSONObject used = new JSONObject();
            used.put("agency_name", rs.getString("agency_name"));
            used.put("cancel_count", rs.getInt("cancel_count"));
            usedArray.put(used);
        }

        jsonResponse.put("success", true);
        jsonResponse.put("cancel_list", usedArray);

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

