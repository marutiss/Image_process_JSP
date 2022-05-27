<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
Connection conn=null; //JSP의 DB를 연결하는 교량.
String url ="jdbc:mysql://192.168.56.101:3306/image_db";
String user ="root";
String password="1234";

Class.forName("com.mysql.jdbc.Driver");//복사한 mysql ,jar파일

conn=DriverManager.getConnection(url,user,password);

String u_id = request.getParameter("u_id");
String u_pass = request.getParameter("u_pass");

// DB 조회
ResultSet  rs = null;  // 조회된 결과
Statement stmt  = conn.createStatement(); // SQL을 실을 트럭.

String sql = "SELECT u_id, u_name, u_pass, u_grade FROM user_table ";
sql += "WHERE u_id='" + u_id + "'";

rs = stmt.executeQuery(sql);  // rs는 읽어온 여러 개의 행 데이터....

String db_name = "";
String db_pass = "";
String db_grade = "";
while (rs.next()) {
	db_name = rs.getString("u_name");
	db_pass = rs.getString("u_pass");
	db_grade = rs.getString("u_grade");
}

if (db_name.equals("")) {
	out.println("누구냐 너. 아이디가 없음");
}else if(!db_pass.equals(u_pass)) {
	out.println("비번오류! 확인요망");
}else {
	// 세션 정보 설정! (입장권)
	session.setAttribute("u_id", u_id);
	session.setAttribute("u_grade", db_grade);
	
	out.println("화녕해..!"+db_name+"고갱님!");
	out.println("<h2> <a href='06_01_Image_client.jsp'> 영상 처리 바로가기! </a></h2>");
}
stmt.close();
conn.close();

%>
</body>
</html>