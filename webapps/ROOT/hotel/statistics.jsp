<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");
    PrintWriter outWriter = response.getWriter();

    String to_date = request.getParameter("to_date");
    String from_date = request.getParameter("from_date");
    int hotel_id = Integer.parseInt(request.getParameter("hotel_id"));

    JSONObject jsonResponse = new JSONObject();
    JSONArray listArray = new JSONArray();

    try {
        String sqlQuery = "SELECT " +
                "COUNT(reservation_id) AS total_reservations, " +
                "COUNT(CASE WHEN hotel_reservation_status != 3 AND travel_reservation_status != 3 AND NOT (hotel_reservation_status = 2 AND travel_reservation_status = 2) THEN 1 ELSE NULL END) AS active_reservations, " +
                "COUNT(CASE WHEN hotel_reservation_status = 2 AND travel_reservation_status = 2 THEN 1 ELSE NULL END) AS confirmed_reservations, " +
                "COUNT(CASE WHEN hotel_reservation_status = 3 OR travel_reservation_status = 3 THEN 1 ELSE NULL END) AS canceled_reservations, " +
                "FORMAT(ROUND(SUM(CASE WHEN hotel_reservation_status != 3 AND travel_reservation_status != 3 THEN hotel_price ELSE 0 END), 2), 'N2') AS total_price, " + // 누락된 쉼표 추가
                "SUM(CASE WHEN hotel_reservation_status != 3 AND travel_reservation_status != 3 THEN night_count ELSE 0 END) AS total_night_count " +
                "FROM inquiry_info_list " +
                "WHERE check_out_date BETWEEN ? AND ? " +
                "AND hotel_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sqlQuery)) {
            ps.setString(1, from_date);
            ps.setString(2, to_date);
            ps.setInt(3, hotel_id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    jsonResponse.put("total_reservations", rs.getInt("total_reservations"));
                    jsonResponse.put("active_reservations", rs.getInt("active_reservations"));
                    jsonResponse.put("confirmed_reservations", rs.getInt("confirmed_reservations"));
                    jsonResponse.put("canceled_reservations", rs.getInt("canceled_reservations"));
                    jsonResponse.put("total_price", rs.getString("total_price") != null ? rs.getString("total_price") : "0"); // getString으로 변경 및 null 체크 추가

                    jsonResponse.put("total_night_count", rs.getInt("total_night_count"));
                }
            }
        }

        sqlQuery = "SELECT " +
                "a.agency_id, " +
                "b.agency_name, " +
                "COUNT(CASE WHEN a.travel_reservation_status = 2 AND a.hotel_reservation_status = 2 THEN 1 ELSE NULL END) AS confirm, " +
                "COUNT(CASE WHEN hotel_reservation_status != 3 AND travel_reservation_status != 3 AND NOT (hotel_reservation_status = 2 AND travel_reservation_status = 2) THEN 1 ELSE NULL END) AS active_reservations, " +
                "COUNT(a.reservation_id) AS total_reservations, " +
                "COUNT(CASE WHEN a.travel_reservation_status = 3 OR a.hotel_reservation_status = 3 THEN 1 ELSE NULL END) AS cancel, " +
                "FORMAT(ROUND(SUM(CASE WHEN a.hotel_reservation_status != 3 AND a.travel_reservation_status != 3 THEN a.hotel_price ELSE 0 END), 2), 'N2') AS total_price, " + // 누락된 쉼표 추가
                "SUM(CASE WHEN a.hotel_reservation_status != 3 AND a.travel_reservation_status != 3 THEN a.night_count ELSE 0 END) AS total_room_nights " +
                "FROM inquiry_info_list a " +
                "INNER JOIN travel_info_list b ON a.agency_id = b.agency_id " +
                "WHERE a.check_out_date BETWEEN ? AND ? " +
                "AND a.hotel_id = ? " +
                "GROUP BY a.agency_id, b.agency_name";

        try (PreparedStatement ps = conn.prepareStatement(sqlQuery)) {
            ps.setString(1, from_date);
            ps.setString(2, to_date);
            ps.setInt(3, hotel_id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    JSONObject cancel = new JSONObject();
                    cancel.put("agency_id", rs.getString("agency_id"));
                    cancel.put("agency_name", rs.getString("agency_name"));
                    cancel.put("confirm", rs.getInt("confirm"));
                    cancel.put("active_reservations", rs.getInt("active_reservations"));
                    cancel.put("total_reservations", rs.getInt("total_reservations"));
                    cancel.put("cancel", rs.getInt("cancel"));
                    cancel.put("total_price", rs.getString("total_price") != null ? rs.getString("total_price") : "0"); // getString으로 변경 및 null 체크 추가

                    cancel.put("total_room_nights", rs.getInt("total_room_nights"));
                    listArray.put(cancel);
                }
            }
        }
        jsonResponse.put("listArray", listArray);
        jsonResponse.put("success", true);
    } catch (Exception e) {
        e.printStackTrace();
        jsonResponse.put("success", false);
        jsonResponse.put("error", e.getMessage());
    } finally {
        outWriter.print(jsonResponse.toString());
        outWriter.close();
    }
    conn.close();
%>

