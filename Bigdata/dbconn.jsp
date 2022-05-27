<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DB Connection</title>
</head>
<body>
<%
Connection conn=null; //JSP의 DB를 연결하는 교량.
String url ="jdbc:mysql://192.168.56.101:3306/image_db";
String user ="root";
String password="1234";

Class.forName("com.mysql.jdbc.Driver");//복사한 mysql ,jar파일

conn=DriverManager.getConnection(url,user,password);

conn.close();

out.println("<h1>접속성공</h1>");



%>
</body>
</html>