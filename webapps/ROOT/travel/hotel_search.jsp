<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ include file="../db_connect.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 클라이언트로부터 전달된 호텔명 파라미터
    String hotelName = request.getParameter("hotel_name");

    // JSON 객체 생성
    JSONObject responseJson = new JSONObject();

    try {
        // 호텔명을 기준으로 데이터베이스에서 검색
        String sqlQuery = "SELECT hotel_id, hotel_ceo_name, hotel_name, hotel_tel, hotel_address, hotel_business_name, FORMAT(hotel_price, 0) AS hotel_price, hotel_rating FROM hotel_info_list WHERE hotel_name LIKE ?";
        PreparedStatement ps = conn.prepareStatement(sqlQuery);
        ps.setString(1, "%" + hotelName + "%");
        ResultSet rs = ps.executeQuery();

        // 호텔 정보를 담을 JSON 배열 생성
        JSONArray hotelArray = new JSONArray();

        // 결과가 있는지 여부 확인
        if (rs.next()) {
            // 성공 응답 설정
            responseJson.put("success", true);

            // 결과를 JSON 배열에 추가
            do {
                JSONObject hotelInfo = new JSONObject();
                hotelInfo.put("hotel_id", rs.getInt("hotel_id"));
                hotelInfo.put("hotel_ceo_name", rs.getString("hotel_ceo_name"));
                hotelInfo.put("hotel_name", rs.getString("hotel_name"));
                hotelInfo.put("hotel_tel", rs.getString("hotel_tel"));
                hotelInfo.put("hotel_address", rs.getString("hotel_address"));
                hotelInfo.put("hotel_business_name", rs.getString("hotel_business_name"));
                hotelInfo.put("hotel_price", rs.getString("hotel_price"));
                hotelInfo.put("hotel_rating", rs.getDouble("hotel_rating"));
                hotelArray.put(hotelInfo);
            } while (rs.next());

            // 호텔 정보 배열을 응답 JSON에 추가
            responseJson.put("hotel_list", hotelArray);
        } else {
            // 결과가 없을 때 실패 응답 설정
            responseJson.put("success", false);
            responseJson.put("message", "해당하는 호텔 정보가 없습니다.");
        }

        rs.close();
        ps.close();
    } catch (SQLException e) {
        e.printStackTrace();
        // 데이터베이스 오류 시 오류 메시지 추가
        responseJson.put("success", false);
        responseJson.put("error", "데이터베이스 오류가 발생했습니다.");
    } finally {
        // JSON 문자열로 변환하여 클라이언트에게 응답
        out.println(responseJson.toString());
    }
conn.close();
%>

