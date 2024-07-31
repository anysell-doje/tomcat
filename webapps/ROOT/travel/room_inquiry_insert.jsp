<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.PreparedStatement, java.sql.SQLException"%>
<%@page import="org.json.JSONObject, java.io.PrintWriter"%>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 쿼리문 수정
    String sql = "INSERT INTO room_inquiry_list(hotel_id, inquiry_type, inquirer_name, agency_id, inquiry_title, inquiry_content, inquirer_tel) VALUES (?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement ps = conn.prepareStatement(sql);

    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();

    try{
        // 데이터 타입 및 불리언 값 처리
        ps.setInt(1, Integer.parseInt(request.getParameter("hotel_id")));
        ps.setString(2, request.getParameter("inquiry_type"));
        ps.setString(3, request.getParameter("inquirer_name"));
        ps.setInt(4, Integer.parseInt(request.getParameter("agency_id")));
        ps.setString(5, request.getParameter("inquiry_title"));
        ps.setString(6, request.getParameter("inquiry_content"));
        ps.setString(7, request.getParameter("inquirer_tel"));

        ps.executeUpdate();

        jsonResponse.put("success", true);
	outWriter.print(jsonResponse.toString());
    } catch(Exception e){
        jsonResponse.put("success", false);
     	outWriter.print(jsonResponse.toString());
    }
    conn.close();
%>

