<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 클라이언트로부터 필요한 파라미터 수신
    String hotel_id_param = request.getParameter("hotel_id");

    JSONObject responseJson = new JSONObject();
    PrintWriter outWriter = response.getWriter();
    JSONArray resvArray = new JSONArray();

    try {
        // 필수 파라미터 검사
        if (hotel_id_param == null) {
            responseJson.put("success", false);
            responseJson.put("error_message", "필수 파라미터가 누락되었습니다.");
            outWriter.println(responseJson.toString());
            return; // 파라미터 누락 시 처리 중단
        }

        int hotel_id = Integer.parseInt(hotel_id_param);
        // 데이터베이스에서 호텔 인증을 위한 쿼리 실행
        String sqlQuery = "SELECT i.reservation_id, i.hotel_id, i.night_count, i.check_in_date, i.check_out_date, i.hotel_price, i.guest_count, i.inquirer_name, i.travel_reservation_status, i.hotel_reservation_status, i.inquirer_tel, i.room_count, h.hotel_name, ti.agency_name, i.agency_id FROM inquiry_info_list i JOIN travel_info_list ti ON i.agency_id = ti.agency_id JOIN hotel_info_list h ON i.hotel_id = h.hotel_id WHERE (i.travel_reservation_status = 3 or i.hotel_reservation_status = 3) AND i.hotel_id = ?";
        PreparedStatement ps = conn.prepareStatement(sqlQuery);
        ps.setInt(1, hotel_id);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            JSONObject resv = new JSONObject();
            resv.put("reservation_id", rs.getInt("reservation_id"));
            resv.put("hotel_id", rs.getInt("hotel_id"));
            resv.put("night_count", rs.getString("night_count"));
            resv.put("check_in_date", rs.getString("check_in_date"));
            resv.put("check_out_date", rs.getString("check_out_date"));
            resv.put("hotel_price", rs.getInt("hotel_price"));
            resv.put("guest_count", rs.getInt("guest_count"));
            resv.put("inquirer_name", rs.getString("inquirer_name"));
            resv.put("travel_reservation_status", rs.getString("travel_reservation_status"));
            resv.put("hotel_reservation_status", rs.getString("hotel_reservation_status"));
            resv.put("inquirer_tel", rs.getString("inquirer_tel"));
            resv.put("room_count", rs.getInt("room_count"));
            resv.put("hotel_name", rs.getString("hotel_name"));
            resv.put("agency_id", rs.getString("agency_id"));
            resv.put("agency_name", rs.getString("agency_name"));
            resvArray.put(resv);
        }

        responseJson.put("resv_list", resvArray);
        responseJson.put("success", true);

        rs.close();
        ps.close();

        // 성공 응답 전송
        outWriter.println(responseJson.toString());
    } catch (NumberFormatException e) {
        responseJson.put("success", false);
        responseJson.put("error_message", "agency_id 파라미터 형식이 잘못되었습니다.");
        outWriter.println(responseJson.toString());
    } catch (Exception e) {
        responseJson.put("success", false);
        responseJson.put("error_message", e.getMessage());
        outWriter.println(responseJson.toString());
    } finally {
        if (conn != null) {
            conn.close();
        }
    }
%>

