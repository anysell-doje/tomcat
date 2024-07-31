<%@ page import="java.sql.*, java.io.*, java.util.Base64, org.json.JSONObject" %>
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
        response.setContentType("application/json");
        if (rs.next()) {
            byte[] imageBytes = rs.getBytes("image");
            JSONObject json = new JSONObject();
            if (imageBytes != null && imageBytes.length > 0) {
                String base64Image = Base64.getEncoder().encodeToString(imageBytes);
                json.put("image", base64Image);
            } else {
                json.put("image", JSONObject.NULL);
            }
            out.print(json.toString());
        } else {
            JSONObject json = new JSONObject();
            json.put("image", JSONObject.NULL);
            out.print(json.toString());
        }
        out.flush();
    } catch (Exception e) {
        response.setContentType("text/plain");
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

