<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException"%>
<%@page import="org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter"%>
<%@ include file="../db_connect.jsp" %>
<%
    response.setContentType("application/json");
    request.setCharacterEncoding("UTF-8");

    JSONObject jsonResponse = new JSONObject();
    JSONArray hotelInfoArray = new JSONArray();
    PrintWriter outWriter = response.getWriter();
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        if (conn != null) {
            String sql = "SELECT * FROM hotel_info_list";
            ps = conn.prepareStatement(sql);    
            rs = ps.executeQuery();

            while(rs.next()) {
                JSONObject hotelData = new JSONObject();
                hotelData.put("hotel_id", rs.getInt("hotel_id"));
                hotelData.put("hotel_ceo_name", rs.getString("hotel_ceo_name"));
                hotelData.put("hotel_name", rs.getString("hotel_name"));
                hotelData.put("hotel_tel", rs.getString("hotel_tel"));
                hotelData.put("hotel_address", rs.getString("hotel_address"));
                hotelData.put("hotel_business_name", rs.getString("hotel_business_name"));
                hotelData.put("hotel_price", rs.getBigDecimal("hotel_price"));
                hotelData.put("hotel_rating", rs.getFloat("hotel_rating"));
                hotelData.put("have_room", rs.getInt("have_room"));

                hotelInfoArray.put(hotelData);
            }

            if(hotelInfoArray.length() > 0) {
                jsonResponse.put("hotel_info_data", hotelInfoArray);
                jsonResponse.put("success", true);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "No data found");
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
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (ps != null) {
            try {
                ps.close();
            } catch (Exception e) {
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

