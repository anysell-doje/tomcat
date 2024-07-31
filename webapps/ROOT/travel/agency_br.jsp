<%@ page import="java.sql.*, java.util.Base64, java.io.*" %>
<%@ include file="../db_connect.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String agencyIdStr = request.getParameter("agency_id");
    String imageData = request.getParameter("image");

    PreparedStatement pstmt = null;

    try {
        if (agencyIdStr == null) {
            throw new Exception("Agency ID is missing.");
        } else if (agencyIdStr.isEmpty()) {
            throw new Exception("Agency ID is empty.");
        }

        if (imageData == null) {
            throw new Exception("Image data is missing.");
        } else if (imageData.isEmpty()) {
            throw new Exception("Image data is empty.");
        }

        int agency_id = Integer.parseInt(agencyIdStr);

        // Decode the base64 image data to a byte array
        byte[] imageBytes = Base64.getDecoder().decode(imageData);

        if (conn == null) {
            throw new Exception("Unable to obtain database connection.");
        }

        String sql = "INSERT INTO agency_br (agency_id, image) VALUES (?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, agency_id);
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

