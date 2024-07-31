<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");

    String reservation_id_param = request.getParameter("reservation_id");
    PreparedStatement ps = null;
    ResultSet rs = null;
    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();

    try {
        // 예약 정보 변경
        if (reservation_id_param != null && !reservation_id_param.isEmpty()) {
            int reservation_id = Integer.parseInt(reservation_id_param);
            String sqlQuery = "UPDATE inquiry_info_list SET inquirer_name = ?, inquirer_tel = ?, check_in_date = ?, check_out_date = ?, night_count = ?, guest_count = ?, room_count = ?, hotel_price = ?  WHERE reservation_id = ?";
            ps = conn.prepareStatement(sqlQuery);
            ps.setString(1, request.getParameter("inquirer_name"));
            ps.setString(2, request.getParameter("inquirer_tel"));
            ps.setString(3, request.getParameter("check_in_date"));
            ps.setString(4, request.getParameter("check_out_date"));
            ps.setInt(5, Integer.parseInt(request.getParameter("night_count")));
            ps.setInt(6, Integer.parseInt(request.getParameter("guest_count")));
            ps.setInt(7, Integer.parseInt(request.getParameter("room_count")));
            ps.setInt(8, Integer.parseInt(request.getParameter("hotel_price")));
            ps.setInt(9, reservation_id);

            int updateCount = ps.executeUpdate();

            if (updateCount > 0) {
                jsonResponse.put("success", true);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("error", "No reservation found with the provided ID.");
            }
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("error", "Reservation ID is required.");
        }
    } catch (NumberFormatException e) {
        jsonResponse.put("success", false);
        jsonResponse.put("error", "Invalid reservation ID format.");
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

