<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 클라이언트로부터 필요한 파라미터 수신
    String hotel_id_param = request.getParameter("hotel_id");
    String agency_id_param = request.getParameter("agency_id");
    String from_date = request.getParameter("from_date");
    String to_date = request.getParameter("to_date");
    String sep = request.getParameter("sep"); // "check_in", "check_out", 또는 "all"

    JSONObject responseJson = new JSONObject();
    PrintWriter outWriter = response.getWriter();
    JSONArray resvArray = new JSONArray();

    try {

        int agency_id = Integer.parseInt(agency_id_param);

        // 기본 쿼리 설정
        String sqlQuery = "SELECT i.reservation_id, i.hotel_id, i.night_count, i.check_in_date, i.check_out_date, i.hotel_price, i.guest_count, i.inquirer_name, i.travel_reservation_status, i.hotel_reservation_status, i.inquirer_tel, i.room_count, h.hotel_name, ti.agency_name, i.agency_id FROM inquiry_info_list i JOIN travel_info_list ti ON i.agency_id = ti.agency_id JOIN hotel_info_list h ON i.hotel_id = h.hotel_id WHERE i.agency_id = ?";

        // 날짜 필터 조건 추가
        if ("check_in".equals(sep)) {
            sqlQuery += " AND i.check_in_date BETWEEN ? AND ?";
        } else if ("check_out".equals(sep)) {
            sqlQuery += " AND i.check_out_date BETWEEN ? AND ?";
        }

        // 추가 필터 조건 추가
        if (hotel_id_param != null) {
            sqlQuery += " AND i.hotel_id = ?";
        }

        PreparedStatement ps = conn.prepareStatement(sqlQuery);
        int paramIndex = 1;
        ps.setInt(paramIndex++, agency_id);

        if ("check_in".equals(sep) || "check_out".equals(sep)) {
            ps.setString(paramIndex++, from_date);
            ps.setString(paramIndex++, to_date);
        }

        if (hotel_id_param != null) {
            ps.setInt(paramIndex++, Integer.parseInt(hotel_id_param));
        }

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
        responseJson.put("error_message", "파라미터 형식이 잘못되었습니다.");
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

