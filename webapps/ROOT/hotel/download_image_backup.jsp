<%@ page import="java.sql.*, java.io.*" %>
<%@ include file="../db_connect.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String hotelIdStr = request.getParameter("hotel_id");

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        if (hotelIdStr == null) {
            throw new Exception("Hotel ID is missing.");
        } else if (hotelIdStr.isEmpty()) {
            throw new Exception("Hotel ID is empty.");
        }

        int hotel_id = Integer.parseInt(hotelIdStr);

        if (conn == null) {
            throw new Exception("Unable to obtain database connection.");
        }

        String sql = "SELECT image FROM hotel_br WHERE hotel_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, hotel_id);

        rs = pstmt.executeQuery();
        if (rs.next()) {
            byte[] imageBytes = rs.getBytes("image");
            if (imageBytes != null && imageBytes.length > 0) {
                response.setContentType("image/jpeg");
                response.setContentLength(imageBytes.length);
                OutputStream outStream = response.getOutputStream();
                outStream.write(imageBytes);
                outStream.flush();
                outStream.close();
            } else {
                out.println("No image found for the given hotel ID.");
            }
        } else {
            out.println("No image found for the given hotel ID.");
        }
    } catch (Exception e) {
        out.println("ERROR: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (rs != null) {
            try {
                rs.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (pstmt != null) {
            try {
                pstmt.close();
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
    }
%>

