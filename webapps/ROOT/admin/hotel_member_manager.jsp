<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException"%>
<%@page import="org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter"%>
<%@ include file="../db_connect.jsp" %>
<%
    response.setContentType("application/json");
    request.setCharacterEncoding("UTF-8");

    JSONObject jsonResponse = new JSONObject();
    JSONArray hotelMemberArray = new JSONArray();
    PrintWriter outWriter = response.getWriter();
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        if (conn != null) {
            String sql = "SELECT hml.*, hil.hotel_name FROM hotel_member_list hml JOIN hotel_info_list hil ON hml.hotel_id = hil.hotel_id WHERE hml.hotel_approve_status = 1";
            ps = conn.prepareStatement(sql);    
            rs = ps.executeQuery();

            while(rs.next()) {
                JSONObject userData = new JSONObject();
                userData.put("user_email", rs.getString("user_email"));
                userData.put("user_pw", rs.getString("user_pw"));
                userData.put("user_name", rs.getString("user_name"));
                userData.put("user_tel", rs.getString("user_tel"));
                userData.put("hotel_approve_status", rs.getString("hotel_approve_status"));
                userData.put("hotel_id", rs.getString("hotel_id"));
                userData.put("hotel_name", rs.getString("hotel_name"));

                hotelMemberArray.put(userData);
            }

            if(hotelMemberArray.length() > 0) {
                jsonResponse.put("hotel_member_data", hotelMemberArray);
                jsonResponse.put("success", true);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "데이터가 없음");
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

