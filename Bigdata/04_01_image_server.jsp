<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="javax.imageio.*" %>
<%@ page import="java.awt.image.*" %>
         
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>JSP 칼라 영상처리 (RC 1) 서버</title>
</head>
<body>
<%!  

//전역 함수
int[][][] inImage;
int inH, inW;
int[][][] outImage=null;
int outH=0, outW=0;

//파라미터 변수
String inFile,outFile,algo,para1,para2;

public void reverseImage() {
	// (3-1) 반전 처리 : out = 255 - in
	// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//  ** 진짜 영상처리 알고리즘 **
	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0; i<inH; i++) 	{
			for(int k=0; k<inW; k++) {
				outImage[rgb][i][k] = 255 - inImage[rgb][i][k];
			}
		}
	}
}

public void addImage() {

}

%>
<%

MultipartRequest multi = new MultipartRequest(request, "C:/Upload",
		5*1024*1024, "utf-8", new DefaultFileRenamePolicy());

String tmp;
Enumeration params = multi.getParameterNames(); // 주의! 차례가 반대로...
tmp = (String) params.nextElement();
para1 = multi.getParameter(tmp);
tmp = (String) params.nextElement();
algo = multi.getParameter(tmp);
// 파일을 전송하기
Enumeration  files = multi.getFileNames(); // 여러개의 파일
tmp = (String)files.nextElement(); // 파일 한개
String filename = multi.getFilesystemName(tmp); // 파일명을 추출


//(1) JSP 파일 처리
File inFp;
inFp = new File("C:/Upload/" + filename);
BufferedImage  bImage = ImageIO.read(inFp); 

//(2) JSP 배열 처리 : 파일 --> 메모리(2차원 배열)
//(중요!) 입력 영상의 폭과 높이
inW = bImage.getHeight();
inH = bImage.getWidth();
inImage = new int[3][inH][inW];

//파일 -->메모리로 로딩
for(int i=0; i<inH; i++) {
	for(int k=0; k<inW; k++) {
		int rgb = bImage.getRGB(i,k);
		int r = (rgb >> 16) & 0xFF;
		int g = (rgb >> 8) & 0xFF;
		int b = (rgb >> 0) & 0xFF;
		inImage[0][i][k] = r;
		inImage[1][i][k] = g;
		inImage[2][i][k] = b;
	}
}

// (3) 영상처리 알고리즘 적용
switch(algo) {
	case "101" : 
		reverseImage();
		break;
	case "102" : 
		addImage();
		break;
}

//(4) 결과를 파일에 저장하기
File outFp;
outFp = new File("C:/out/out_"+filename);

BufferedImage oImage 
	= new BufferedImage(outH, outW, BufferedImage.TYPE_INT_BGR);

//메모리 --> 파일
for(int i=0; i<outH; i++) {
	for(int k=0; k<outW; k++) {
		int r = outImage[0][i][k];
		int g = outImage[1][i][k];
		int b = outImage[2][i][k];
		int px = 0;
		px = px | (r << 16);
		px = px | (g << 8);
		px = px | (b << 0);
		oImage.setRGB(i,k,px);
	}
}
ImageIO.write(oImage, "jpg", outFp);

out.println("<h1> 처리 완료 ! </h1>");
String url = "<p><h1><a href='http://192.168.56.101:8080/";
url += "BigData/download.jsp?file=";
url += "out_" + filename + "'>!!!다운로드!!!!</a></h1>";

out.println(url);
%>
</body>
</html>