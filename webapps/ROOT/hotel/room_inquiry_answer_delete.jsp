<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");

    String border_id_param = request.getParameter("border_id");
    PreparedStatement ps = null;
    ResultSet rs = null;
    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();

    try {
        // 예약 정보 변경
        if (border_id_param != null && !border_id_param.isEmpty()) {
            int border_id = Integer.parseInt(border_id_param);
            String sqlQuery = "UPDATE room_inquiry_list SET inquiry_answer = null WHERE border_id = ?";
            ps = conn.prepareStatement(sqlQuery);
            ps.setInt(1, border_id);

            int updateCount = ps.executeUpdate();

            if (updateCount > 0) {
                jsonResponse.put("success", true);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("error", "No border_id found with the provided ID.");
            }
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("error", "border_id is required.");
        }
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

