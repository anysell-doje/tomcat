<%@ page import="java.sql.*, java.util.Base64, java.io.*" %>
<%@ include file="../db_connect.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String hotelIdStr = request.getParameter("hotel_id");
    String imageData = request.getParameter("image");

    PreparedStatement pstmt = null;

    try {
        if (hotelIdStr == null) {
            throw new Exception("Hotel ID is missing.");
        } else if (hotelIdStr.isEmpty()) {
            throw new Exception("Hotel ID is empty.");
        }

        if (imageData == null) {
            throw new Exception("Image data is missing.");
        } else if (imageData.isEmpty()) {
            throw new Exception("Image data is empty.");
        }

        int hotel_id = Integer.parseInt(hotelIdStr);

        // Decode the base64 image data to a byte array
        byte[] imageBytes = Base64.getDecoder().decode(imageData);

        if (conn == null) {
            throw new Exception("Unable to obtain database connection.");
        }

        String sql = "INSERT INTO hotel_br (hotel_id, image) VALUES (?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, hotel_id);
        pstmt.setBytes(2, imageBytes);

        // Execute the query
        int row = pstmt.executeUpdate();
        if (row > 0) {
            out.println("Image successfully uploaded and stored in the database.");
        } else {
            out.println("Image upload failed.");
        }
    } catch (Exception e) {
        out.println("ERROR: " + e.getMessage());
        e.printStackTrace();
    } finally {
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

