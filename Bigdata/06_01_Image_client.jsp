<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 영상처리(RC4) 클라이언트</title>
</head>
<body>
<%
//세션(입장권 )확인
String u_id=(String)session.getAttribute("u_id");
String u_grade=(String)session.getAttribute("u_grade");

if(u_id.equals("")||u_grade.equals("")){
	out.println("not regal root. return");
	return;
}

%>

<form action="06_01_Image_server.jsp" method="post"
		enctype="multipart/form-data">
	<fieldset style="background-color:#9bc3f8;">
	<legend style="background-color:#c7ebfc;; font-size: 25px">&emsp;JSP 영상처리(RC4) 클라이언트&emsp;</legend><p>
<%
if(u_grade.equals("A")){
%>
	<p> <select name="algo">
			<option value=""> ~~ 알고리즘 선택 ~~~ </option>
			<optgroup label="화소점">
			<option value="101">반전 처리</option>
			<option value="102">밝게/어둡게</option>	
			<option value="103">128흑백반전</option>	
			<option value="104">평균 흑백반전</option>	
			<option value="105">파라볼라 Cap</option>
			<option value="106">파라볼라 Cup</option>
			</optgroup>	
			<optgroup label="기하학">
			<option value="201">상하반전</option>
			<option value="202">좌우반전</option>
			<!-- <option value="203">축소영상</option>
			<option value="204">확대영상</option> -->
			</optgroup>
			<optgroup label="히스토그램">
			<option value="301">히스토그램 스트래칭</option>
			<option value="302">엔드인</option>
			<option value="303">히스토그램 평활화</option>
			</optgroup>
			<optgroup label="마스크 프로세스">
			<option value="401">엠보싱</option>
			<option value="402">블러링</option>
			<option value="403">HPF</option>
			<option value="407">LPF</option>
			<option value="404">샤프닝</option>
			<option value="405">수직엣지검출</option>
			<option value="406">수평엣지검출</option>
			<option value="408">라플라시안 처리</option>
			</optgroup>
			<optgroup label="CV">
			<option value="501">채도 조절</option>
			<option value="502">명도 조절</option>
			
			</optgroup>
		</select>

<%
} else {
%>
	<p> <select name="algo">
			<option value=""> ~~ 알고리즘 선택 ~~~ </option>
			<optgroup label="화소점">
			<option value="101">반전 처리</option>
			<option value="102">밝게/어둡게</option>	
			<option value="103">128흑백반전</option>	
			<option value="104">평균 흑백반전</option>	
			<option value="105">파라볼라 Cap</option>
			<option value="106">파라볼라 Cup</option>
			</optgroup>	
			
		</select>
<%
}
%>
	<p>파일: <input type='file' name='filename'>
	<p> 파라미터1 : <input type="text" value="0" name="para1">
	

	<p><p> <input type="submit" value="영상 처리 진행!">
</fieldset>
</form>
</body>
</html>
