<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");

    String user_email = request.getParameter("user_email");
    PreparedStatement ps = null;
    ResultSet rs = null;
    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();

    try {
        // 예약 정보 변경
            String sqlQuery = "delete from hotel_member_list where user_email = ?";
            ps = conn.prepareStatement(sqlQuery);
            ps.setString(1, user_email);
            

            int updateCount = ps.executeUpdate();

            if (updateCount > 0) {
                jsonResponse.put("success", true);
            } else {
                jsonResponse.put("success", false);
            }
    } catch (NumberFormatException e) {
        jsonResponse.put("success", false);
        jsonResponse.put("error", "Invalid user_email format.");
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
