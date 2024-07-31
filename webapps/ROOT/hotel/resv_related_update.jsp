<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // JSON 응답을 위한 PrintWriter 설정
    PrintWriter outWriter = response.getWriter();

    try {
            // 변경 가능할 경우, 업데이트 쿼리 실행
            String sqlQuery = "UPDATE inquiry_info_list SET hotel_reservation_status = ? WHERE reservation_id = ?";
            PreparedStatement ps = conn.prepareStatement(sqlQuery);
            ps.setString(1, request.getParameter("hotel_reservation_status"));
            ps.setString(2, request.getParameter("reservation_id"));
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                // 예약자 객실 수 최종 확인
                String sql1 = "select room_count, hotel_id from inquiry_info_list where reservation_id = ?";
                PreparedStatement ps1 = conn.prepareStatement(sql1);
                ps1.setInt(1, Integer.parseInt(request.getParameter("reservation_id")));
                ps1.executeUpdate();
                ResultSet rs = ps1.executeQuery();
                rs.next();

                // 객실 수 추가
                String sql2 = "UPDATE hotel_info_list a "
                    + " JOIN inquiry_info_list b ON a.hotel_id = b.hotel_id "
                    + " SET a.have_room = a.have_room - ? "
                    + " WHERE b.hotel_id = ? ";

                PreparedStatement ps2 = conn.prepareStatement(sql2);
                ps2.setInt(1, rs.getInt(1));
                ps2.setInt(2, rs.getInt(2));
                ps2.executeUpdate();

                // 인증 성공 시 JSON 응답 데이터 생성
                JSONObject jsonResponse = new JSONObject();
                jsonResponse.put("success", true);

                // JSON 응답 전송
                outWriter.print(jsonResponse.toString());
        } else {
            // 변경 불가능할 경우, JSON 응답 데이터 생성
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", false);

            // JSON 응답 전송
            outWriter.print(jsonResponse.toString());
        }
    } catch (Exception e) {
        // SQL 관련 예외 처리
        e.printStackTrace();
    }
    conn.close();
%>


