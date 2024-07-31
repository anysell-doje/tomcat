<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.JSONObject, java.io.PrintWriter, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../db_connect.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    String admin_pw = request.getParameter("admin_pw");

    // SHA-256 해시 생성
    String hashedPassword = null;
    try {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(admin_pw.getBytes("UTF-8"));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        hashedPassword = hexString.toString();
    } catch (Exception e) {
        // Handle hashing errors
        e.printStackTrace();
    }

    PrintWriter outWriter = response.getWriter();
    JSONObject jsonResponse = new JSONObject();

    try{
    String sql = "insert into admin_accounts(admin_id, admin_pw, admin_email, admin_access_level, admin_tel, admin_name) values(?, ?, ?, ?, ?, ?)";
    PreparedStatement ps = conn.prepareStatement(sql);

    ps.setString(1, request.getParameter("admin_id"));
    ps.setString(2, hashedPassword); // 암호화된 비밀번호로 변경
    ps.setString(3, request.getParameter("admin_email"));
    ps.setString(4, request.getParameter("admin_access_level"));
    ps.setString(5, request.getParameter("admin_tel"));
    ps.setString(6, request.getParameter("admin_name"));

    ps.executeUpdate();

    jsonResponse.put("success", true);
    outWriter.print(jsonResponse.toString());
    } catch(Exception e){
        jsonResponse.put("success", false);
        outWriter.print(jsonResponse.toString());
    }
    conn.close();
%>

