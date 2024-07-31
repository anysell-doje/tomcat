<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    int room_count = Integer.parseInt(request.getParameter("room_count"));
    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();

    try{
    String sql = "insert into inquiry_info_list(hotel_id, night_count, hotel_price, check_in_date, check_out_date, guest_count, inquirer_name, inquirer_tel, room_count, agency_id) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setInt(1, Integer.parseInt(request.getParameter("hotel_id")));
    ps.setInt(2, Integer.parseInt(request.getParameter("night_count")));
    ps.setInt(3, Integer.parseInt(request.getParameter("hotel_price")));
    ps.setString(4, request.getParameter("check_in_date"));
    ps.setString(5, request.getParameter("check_out_date"));
    ps.setInt(6, Integer.parseInt(request.getParameter("guest_count")));
    ps.setString(7, request.getParameter("inquirer_name"));
    ps.setString(8, request.getParameter("inquirer_tel"));
    ps.setInt(9, room_count);
    ps.setInt(10, Integer.parseInt(request.getParameter("agency_id")));
    ps.executeUpdate();

    jsonResponse.put("success", true);
    outWriter.print(jsonResponse.toString());
    } catch(Exception e){
        jsonResponse.put("success", false);
    	jsonResponse.put("error_message", e.getMessage()); // 예외 메시지 추가
    	e.printStackTrace(); // 콘솔에 예외 스택 트레이스 출력
    	outWriter.print(jsonResponse.toString());
    }
    conn.close();
%>
