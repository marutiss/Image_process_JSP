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
<title>JSP Į�� ����ó�� (RC 1) ����</title>
</head>
<body>
<%!  

//���� �Լ�
int[][][] inImage;
int inH, inW;
int[][][] outImage=null;
int outH=0, outW=0;

//�Ķ���� ����
String inFile,outFile,algo,para1,para2;

public void reverseImage() {
	// (3-1) ���� ó�� : out = 255 - in
	// (�߿�!) ��� ������ ũ�� ���� --> �˰��� ����
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//  ** ��¥ ����ó�� �˰��� **
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
Enumeration params = multi.getParameterNames(); // ����! ���ʰ� �ݴ��...
tmp = (String) params.nextElement();
para1 = multi.getParameter(tmp);
tmp = (String) params.nextElement();
algo = multi.getParameter(tmp);
// ������ �����ϱ�
Enumeration  files = multi.getFileNames(); // �������� ����
tmp = (String)files.nextElement(); // ���� �Ѱ�
String filename = multi.getFilesystemName(tmp); // ���ϸ��� ����


//(1) JSP ���� ó��
File inFp;
inFp = new File("C:/Upload/" + filename);
BufferedImage  bImage = ImageIO.read(inFp); 

//(2) JSP �迭 ó�� : ���� --> �޸�(2���� �迭)
//(�߿�!) �Է� ������ ���� ����
inW = bImage.getHeight();
inH = bImage.getWidth();
inImage = new int[3][inH][inW];

//���� -->�޸𸮷� �ε�
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

// (3) ����ó�� �˰��� ����
switch(algo) {
	case "101" : 
		reverseImage();
		break;
	case "102" : 
		addImage();
		break;
}

//(4) ����� ���Ͽ� �����ϱ�
File outFp;
outFp = new File("C:/out/out_"+filename);

BufferedImage oImage 
	= new BufferedImage(outH, outW, BufferedImage.TYPE_INT_BGR);

//�޸� --> ����
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

out.println("<h1> ó�� �Ϸ� ! </h1>");
String url = "<p><h1><a href='http://192.168.56.101:8080/";
url += "BigData/download.jsp?file=";
url += "out_" + filename + "'>!!!�ٿ�ε�!!!!</a></h1>";

out.println(url);
%>
</body>
</html>