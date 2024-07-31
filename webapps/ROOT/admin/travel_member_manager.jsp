<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException"%>
<%@page import="org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter"%>
<%@ include file="../db_connect.jsp" %>
<%
    response.setContentType("application/json");
    request.setCharacterEncoding("UTF-8");

    JSONObject jsonResponse = new JSONObject();
    JSONArray travelMemberArray = new JSONArray();
    PrintWriter outWriter = response.getWriter();
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        if (conn != null) {
            String sql = "SELECT tml.*, til.agency_name FROM travel_member_list tml JOIN travel_info_list til ON tml.agency_id = til.agency_id WHERE tml.travel_approve_status = 1";
            ps = conn.prepareStatement(sql);    
            rs = ps.executeQuery();

            while(rs.next()) {
                JSONObject userData = new JSONObject();
                userData.put("travel_email", rs.getString("travel_email"));
                userData.put("travel_pw", rs.getString("travel_pw"));
                userData.put("travel_name", rs.getString("travel_name"));
                userData.put("travel_tel", rs.getString("travel_tel"));
                userData.put("travel_approve_status", rs.getString("travel_approve_status"));
                userData.put("agency_id", rs.getString("agency_id"));
                userData.put("agency_name", rs.getString("agency_name"));

                travelMemberArray.put(userData);
            }

            if(travelMemberArray.length() > 0) {
                jsonResponse.put("travel_member_data", travelMemberArray);
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

