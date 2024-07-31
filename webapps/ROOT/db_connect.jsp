<%@page import="java.sql.*"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF8"%>
<%
Connection conn = null;
String url = "jdbc:mariadb://localhost:3306/occ";
String id = "root";                     //MySQL에 접속을 위한 계정의 ID
String pwd = "1234";            //MySQL에 접속을 위한 계정의 암호
try{
Class.forName("org.mariadb.jdbc.Driver");
conn = DriverManager.getConnection(url, id, pwd);
}catch(Exception e){
e.printStackTrace();
}
%>
