<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>서버</title>
</head>
<body>
<%
//아이디,비번 넘겨받기
String id=request.getParameter("id");
String pass=request.getParameter("pass");

//DB를 조회해서 id,비번일치 여부 확인
if(pass.equals("1234")){
	out.println("아이디:"+id+"님 반가붜요");
}
else{out.println("아이디:"+id+"님 누구냐 넌");}




%>
</body>
</html>