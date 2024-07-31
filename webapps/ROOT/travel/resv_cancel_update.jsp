<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");

    int reservation_id = Integer.parseInt(request.getParameter("reservation_id"));
    int room_count = 0;
    int hotel_id = 0;
    String cancel_date = request.getParameter("cancel_date");    

    PreparedStatement ps = null;
    ResultSet rs = null;
    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();

    try {
        // 예약 ID에 대한 room_count를 조회
        String sqlQuery = "select room_count, hotel_id from inquiry_info_list where reservation_id = ?";
        ps = conn.prepareStatement(sqlQuery);
        ps.setInt(1, reservation_id);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            room_count = rs.getInt(1);
            hotel_id = rs.getInt(2);
        } else {
            throw new Exception("Reservation ID not found");
        }

        rs.close();
        ps.close();

        // 예약 상태 업데이트 및 have_room 증가
        sqlQuery = "UPDATE inquiry_info_list SET travel_reservation_status = '3' WHERE reservation_id = ?";
        ps = conn.prepareStatement(sqlQuery);
        ps.setInt(1, reservation_id);
        int rowsAffected = ps.executeUpdate();

        if (rowsAffected > 0) {
            sqlQuery = "UPDATE hotel_info_list SET have_room = have_room + ? WHERE hotel_id = ?";
            ps = conn.prepareStatement(sqlQuery);
            ps.setInt(1, room_count);
            ps.setInt(2, hotel_id);
            rowsAffected = ps.executeUpdate();

            jsonResponse.put("success", rowsAffected > 0);
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("error", "Failed to update reservation status");
        }

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

