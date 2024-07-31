<%@ page import="java.sql.*, java.util.Base64, java.io.*" %>
<%@ include file="../db_connect.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String hotelIdStr = request.getParameter("hotel_id");
    String imageData = request.getParameter("image");

    try {
        int hotel_id = Integer.parseInt(hotelIdStr);

        // base64 문자열에서 이미지 바이트 배열로 디코딩합니다.
        byte[] imageBytes = Base64.getDecoder().decode(imageData);

        PreparedStatement pstmt = null;

        try {
            String sql = "INSERT INTO hotel_br (hotel_id, image) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, hotel_id);
            pstmt.setBytes(2, imageBytes);

            // 데이터베이스 서버에 명령문을 전송합니다.
            int row = pstmt.executeUpdate();
            if (row > 0) {
                out.println("이미지가 업로드되어 데이터베이스에 저장되었습니다.");
            } else {
                out.println("이미지 업로드 실패");
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
    } catch (Exception e) {
        out.println("ERROR: " + e.getMessage());
        e.printStackTrace();
    }
%>

