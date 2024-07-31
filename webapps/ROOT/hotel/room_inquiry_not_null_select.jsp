<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException"%>
<%@page import="org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter"%>
<%@ include file="../db_connect.jsp" %>
<%
    response.setContentType("application/json");
    request.setCharacterEncoding("UTF-8");

    String hotel_id = request.getParameter("hotel_id");
    JSONObject jsonResponse = new JSONObject();
    JSONArray inquiriesArray = new JSONArray();
    PrintWriter outWriter = response.getWriter();
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        if (conn != null) {
            String sql = "SELECT ril.*, hil.hotel_name, hil.hotel_address, til.agency_name " +
                         "FROM room_inquiry_list ril " +
                         "JOIN hotel_info_list hil ON ril.hotel_id = hil.hotel_id " +
                         "JOIN travel_info_list til ON ril.agency_id = til.agency_id " +
                         "WHERE ril.hotel_id = ? and ril.inquiry_answer is not null";
            ps = conn.prepareStatement(sql);
            ps.setString(1, hotel_id);
            rs = ps.executeQuery();

            boolean hasData = false;
            while(rs.next()) {
                JSONObject room_inquiry_data = new JSONObject();

                // room_inquiry_list 테이블의 데이터
                room_inquiry_data.put("border_id", rs.getString("border_id"));
                room_inquiry_data.put("hotel_id", rs.getString("hotel_id"));
                room_inquiry_data.put("agency_id", rs.getString("agency_id"));
                room_inquiry_data.put("group_id", rs.getString("group_id"));
                room_inquiry_data.put("inquiry_type", rs.getString("inquiry_type"));
                room_inquiry_data.put("check_in_date", rs.getString("check_in_date"));
                room_inquiry_data.put("check_out_date", rs.getString("check_out_date"));
                room_inquiry_data.put("room_count", rs.getString("room_count"));
                room_inquiry_data.put("breakfast_included", rs.getString("breakfast_included"));
                room_inquiry_data.put("status", rs.getString("status"));
                room_inquiry_data.put("guest_count", rs.getString("guest_count"));
                room_inquiry_data.put("inquiry_date", rs.getString("inquiry_date"));
                room_inquiry_data.put("write_date", rs.getString("write_date"));
                room_inquiry_data.put("inquirer_name", rs.getString("inquirer_name"));
                room_inquiry_data.put("inquiry_content", rs.getString("inquiry_content"));
                room_inquiry_data.put("inquiry_title", rs.getString("inquiry_title"));
                room_inquiry_data.put("inquirer_tel", rs.getString("inquirer_tel"));
                room_inquiry_data.put("inquiry_answer", rs.getString("inquiry_answer"));

                // hotel_info_list 테이블의 데이터
                room_inquiry_data.put("hotel_name", rs.getString("hil.hotel_name"));
                room_inquiry_data.put("hotel_address", rs.getString("hotel_address"));

                // travel_info_list 테이블의 데이터
                room_inquiry_data.put("agency_name", rs.getString("agency_name"));

                inquiriesArray.put(room_inquiry_data);
                hasData = true;
            }

            if(hasData) {
                jsonResponse.put("room_inquiry_data", inquiriesArray);
                jsonResponse.put("success", true);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "No inquiries found for the given hotel_id.");
            }
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Database connection is null.");
        }
    } catch(Exception e) {
        jsonResponse.put("success", false);
        jsonResponse.put("message", "An error occurred: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        outWriter.print(jsonResponse.toString());
        outWriter.close();
    }
%>
