<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userEmail = request.getParameter("user_email");
    JSONObject jsonResponse = new JSONObject();

    try {
        String sqlQuery = "SELECT user_email FROM hotel_member_list WHERE user_email = ?";
        PreparedStatement ps = conn.prepareStatement(sqlQuery);
        ps.setString(1, userEmail);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            // 이메일이 이미 존재하는 경우
            jsonResponse.put("success", true);
        } else {
            // 이메일이 존재하지 않는 경우
            jsonResponse.put("success", false);
        }

        rs.close();
        ps.close();
    } catch (Exception e) {
        e.printStackTrace();
        jsonResponse.put("error", "Database error occurred.");
    } finally {
        out.println(jsonResponse.toString());
    }
    conn.close();
%>

