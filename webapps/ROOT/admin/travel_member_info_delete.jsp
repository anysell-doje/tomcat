<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");

    String travel_email_param = request.getParameter("travel_email");
    PreparedStatement ps = null;
    ResultSet rs = null;
    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();

    try {
        // 예약 정보 변경
        if (travel_email_param != null && !travel_email_param.isEmpty()) {
            String travel_email = travel_email_param;
            String sqlQuery = "delete from travel_member_list where travel_email = ?";
            ps = conn.prepareStatement(sqlQuery);
            ps.setString(1, travel_email);
            

            int updateCount = ps.executeUpdate();

            if (updateCount > 0) {
                jsonResponse.put("success", true);
            } else {
                jsonResponse.put("success", false);
            }
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("error", "travel_email is required.");
        }
    } catch (NumberFormatException e) {
        jsonResponse.put("success", false);
        jsonResponse.put("error", "Invalid travel_email format.");
    } catch (SQLException e) {
        jsonResponse.put("success", false);
        jsonResponse.put("error", e.getMessage());
    } catch (Exception e) {
        jsonResponse.put("success", false);
        jsonResponse.put("error", e.getMessage());
    } finally {
        // 자원 해제
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    outWriter.print(jsonResponse.toString());
    if (outWriter != null) outWriter.close();
%>
