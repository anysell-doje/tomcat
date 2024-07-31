<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    String sep = request.getParameter("sep");
    String is_change = request.getParameter("change");
    String email = request.getParameter("email");

    PrintWriter outWriter = response.getWriter();
    JSONObject responseJson = new JSONObject();

    if("true".equals(is_change)){
        if("travel".equals(sep)){
            String sql = "UPDATE travel_member_list SET travel_approve_status = 1 WHERE travel_email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            int result = ps.executeUpdate();

            if(result > 0) {
                responseJson.put("success", true);
            } else {
                responseJson.put("success", false);
            }
        } else if("hotel".equals(sep)){
            String sql = "UPDATE hotel_member_list SET hotel_approve_status = 1 WHERE user_email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            int result = ps.executeUpdate();

            if(result > 0) {
                responseJson.put("success", true);
            } else {
                responseJson.put("success", false);
            }
        } else {
            responseJson.put("success", false); // 잘못된 sep 값
        }
    } else if("false".equals(is_change)){
        if("travel".equals(sep)){
            String sql = "DELETE FROM travel_member_list WHERE travel_email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            int result = ps.executeUpdate();

            if(result > 0) {
                responseJson.put("success", true);
            } else {
                responseJson.put("success", false);
            }
        } else if("hotel".equals(sep)){
            String sql = "DELETE FROM hotel_member_list WHERE user_email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            int result = ps.executeUpdate();

            if(result > 0) {
                responseJson.put("success", true);
            } else {
                responseJson.put("success", false);
            }
        } else {
            responseJson.put("success", false); // 잘못된 sep 값
        }
    } else {
        responseJson.put("success", false); // 잘못된 is_change 값
    }

    outWriter.println(responseJson.toString());
    conn.close();
%>

