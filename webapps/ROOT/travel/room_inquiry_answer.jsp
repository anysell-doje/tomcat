<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, org.json.JSONArray, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 클라이언트로부터 필요한 파라미터 수신
    String border_id_param = request.getParameter("border_id");

    JSONObject responseJson = new JSONObject();
    PrintWriter outWriter = response.getWriter();
    JSONArray resvArray = new JSONArray();

    try {
        // 필수 파라미터 검사
        if (border_id_param == null) {
            responseJson.put("success", false);
            responseJson.put("error_message", "필수 파라미터가 누락되었습니다.");
            outWriter.println(responseJson.toString());
            return; // 파라미터 누락 시 처리 중단
        }

        int border_id = Integer.parseInt(border_id_param);
        // 데이터베이스에서 호텔 인증을 위한 쿼리 실행
        String sqlQuery = " select inquiry_answer from room_inquiry_list where border_id = ? ";
        PreparedStatement ps = conn.prepareStatement(sqlQuery);
        ps.setInt(1, border_id);
        ResultSet rs = ps.executeQuery();

        if(rs.next()) {
            JSONObject resv = new JSONObject();
            responseJson.put("inquiry_answer", rs.getString(1));
        	responseJson.put("success", true);
        }else {
        	responseJson.put("success", false);
        }

        

        rs.close();
        ps.close();

        // 성공 응답 전송
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
