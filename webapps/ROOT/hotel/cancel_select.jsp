<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");

    String to_date = request.getParameter("to_date");
    String from_date = request.getParameter("from_date");
    String agency_id = request.getParameter("agency_id");
    int total = 0;

    PreparedStatement ps = null;
    ResultSet rs = null;
    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();
    JSONArray cancelArray = new JSONArray();

    try {

        // hotel
        String sqlQuery = "SELECT COUNT(a.reservation_id) AS cancel_count " +
                          "FROM inquiry_info_list a " +
                          "INNER JOIN travel_info_list b ON a.agency_id = b.agency_id " +
                          "WHERE (a.hotel_reservation_status = 3 OR a.travel_reservation_status = 3) " +
                          "AND a.agency_id = ? AND (cancel_date BETWEEN ? AND ?)";
        ps = conn.prepareStatement(sqlQuery);
        ps.setString(1, agency_id);
        ps.setString(2, from_date);
        ps.setString(3, to_date);
        rs = ps.executeQuery();

        while(rs.next()){
            JSONObject cancel = new JSONObject();
            cancel.put("cancel_count", rs.getString("cancel_count"));
            cancelArray.put(cancel);
        }

        jsonResponse.put("success", true);
        jsonResponse.put("cancel_list", cancelArray);

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
    outWriter.close();
%>

