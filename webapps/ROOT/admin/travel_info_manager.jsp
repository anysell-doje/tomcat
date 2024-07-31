<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException"%>
<%@page import="org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter"%>
<%@ include file="../db_connect.jsp" %>
<%
    response.setContentType("application/json");
    request.setCharacterEncoding("UTF-8");

    JSONObject jsonResponse = new JSONObject();
    JSONArray travelInfoArray = new JSONArray();
    PrintWriter outWriter = response.getWriter();
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        if (conn != null) {
            String sql = "SELECT * FROM travel_info_list";
            ps = conn.prepareStatement(sql);    
            rs = ps.executeQuery();

            while(rs.next()) {
                JSONObject travelData = new JSONObject();
                travelData.put("agency_id", rs.getInt("agency_id"));
                travelData.put("agency_name", rs.getString("agency_name"));
                travelData.put("agency_address", rs.getString("agency_address"));
                travelData.put("agency_tel", rs.getString("agency_tel"));

                travelInfoArray.put(travelData);
            }

            if(travelInfoArray.length() > 0) {
                jsonResponse.put("travel_info_data", travelInfoArray);
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

