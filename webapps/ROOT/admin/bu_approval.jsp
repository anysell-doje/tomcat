<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    String sep = request.getParameter("sep");
    String is_change = request.getParameter("change");
    String agency_name = request.getParameter("agency_name");
    String hotel_name = request.getParameter("hotel_name");
    String hotel_address = request.getParameter("hotel_address");
    String agency_address = request.getParameter("agency_address");

    PrintWriter outWriter = response.getWriter();
    JSONObject responseJson = new JSONObject();

    if ("true".equals(is_change)) {
        if ("travel".equals(sep)) {
            String insertQuery = "INSERT INTO travel_info_list (agency_name, agency_tel, ceo_name, agency_address) VALUES (?, ?, ?, ?)";
            String deleteQuery = "DELETE FROM travel_info_list_copy WHERE agency_name = ?";

            try (PreparedStatement insertPs = conn.prepareStatement(insertQuery);
                 PreparedStatement deletePs = conn.prepareStatement(deleteQuery)) {

                insertPs.setString(1, agency_name);
                insertPs.setString(2, request.getParameter("agency_tel"));
                insertPs.setString(3, request.getParameter("ceo_name"));
                insertPs.setString(4, agency_address);

                int insertResult = insertPs.executeUpdate();

                deletePs.setString(1, agency_name);
                int deleteResult = deletePs.executeUpdate();

                if (insertResult > 0 && deleteResult > 0) {
                    responseJson.put("success", true);
                } else {
                    responseJson.put("success", false);
                }
            } catch (SQLException e) {
                responseJson.put("success", false);
                responseJson.put("error_message", e.getMessage());
            }
        } else if ("hotel".equals(sep)) {
            String insertQuery = "INSERT INTO hotel_info_list (hotel_ceo_name, hotel_name, hotel_tel, hotel_address) VALUES (?, ?, ?, ?)";
            String deleteQuery = "DELETE FROM hotel_info_list_copy WHERE hotel_name = ?";

            try (PreparedStatement insertPs = conn.prepareStatement(insertQuery);
                 PreparedStatement deletePs = conn.prepareStatement(deleteQuery)) {

                insertPs.setString(1, request.getParameter("hotel_ceo_name"));
                insertPs.setString(2, hotel_name);
                insertPs.setString(3, request.getParameter("hotel_tel"));
                insertPs.setString(4, hotel_address);

                int insertResult = insertPs.executeUpdate();

                deletePs.setString(1, hotel_name);
                int deleteResult = deletePs.executeUpdate();

                if (insertResult > 0 && deleteResult > 0) {
                    responseJson.put("success", true);
                } else {
                    responseJson.put("success", false);
                }
            } catch (SQLException e) {
                responseJson.put("success", false);
                responseJson.put("error_message", e.getMessage());
            }
        } else {
            responseJson.put("success", false); // 잘못된 sep 값
        }
    } else if ("false".equals(is_change)) {
        if ("travel".equals(sep)) {
            String deleteQuery = "DELETE FROM travel_info_list_copy WHERE agency_name = ?";

            try (PreparedStatement deletePs = conn.prepareStatement(deleteQuery)) {
                deletePs.setString(1, agency_name);

                int result = deletePs.executeUpdate();

                if (result > 0) {
                    responseJson.put("success", true);
                } else {
                    responseJson.put("success", false);
                }
            } catch (SQLException e) {
                responseJson.put("success", false);
                responseJson.put("error_message", e.getMessage());
            }
        } else if ("hotel".equals(sep)) {
            String deleteQuery = "DELETE FROM hotel_info_list_copy WHERE hotel_name = ?";

            try (PreparedStatement deletePs = conn.prepareStatement(deleteQuery)) {
                deletePs.setString(1, hotel_name);

                int result = deletePs.executeUpdate();

                if (result > 0) {
                    responseJson.put("success", true);
                } else {
                    responseJson.put("success", false);
                }
            } catch (SQLException e) {
                responseJson.put("success", false);
                responseJson.put("error_message", e.getMessage());
            }
        } else {
            responseJson.put("success", false); // 잘못된 sep 값
        }
    } else {
        responseJson.put("success", false); // 잘못된 is_change 값
    }

    outWriter.println(responseJson.toString());
    conn.close();
%>

