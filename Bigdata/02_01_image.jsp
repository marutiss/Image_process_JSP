<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ page import="java.io.*" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>���� ���̵� ���� ó��(Alpha 1)</title>
</head>
<body>
<%
// ���� ���� �غ�
int[][] inImage;
int inH, inW;
int[][] outImage;
int outH, outW;

// (1) JSP ���� ó��
File inFp;
FileInputStream inFs;
inFp = new File("C:/images/raw/Etc_Raw(squre)/Lenna512.raw");
inFs = new FileInputStream(inFp.getPath());
// (2) JSP �迭 ó�� : ���� --> �޸�(2���� �迭)
// (�߿�!) �Է� ������ ���� ����
inH = inW = 512;
inImage = new int[inH][inW];
// ���� -->�޸𸮷� �ε�
for(int i=0; i<inH; i++) {
	for(int k=0; k<inW; k++) {
		inImage[i][k] = inFs.read();
	}
}
inFs.close();

// (3) ���� ó�� �˰��� ����
// (3-1) ���� ó�� : out = 255 - in
// (�߿�!) ��� ������ ũ�� ���� --> �˰��� ����
/* outH= inH;
outW= inW;
outImage = new int[outH][outW];
//  ** ��¥ ����ó�� �˰��� **
for(int i=0; i<inH; i++) {
	for(int k=0; k<inW; k++) {
		outImage[i][k] = 255 - inImage[i][k];
	}
}  */
//(3-2)
/* outH= inH;
outW= inW;
outImage = new int[outH][outW];
//  ** ��¥ ����ó�� �˰��� ** 128���� ���
for(int i=0; i<inH; i++) {
	for(int k=0; k<inW; k++) {
		int px=inImage[i][k];
		if(px<128)
            px=0;
        else
            px=255;
		
		outImage[i][k] =px;
	}
}  */

/* //(3-3)
outH= inH;
outW= inW;
outImage = new int[outH][outW];
//** ��¥ ����ó�� �˰��� ** ���������
int result=0;
 for(int i=0; i<inH; i++) {
     for(int k=0; k<inW; k++) {
         result+= inImage[i][k];
     }
 }
 
int avr=result/(inH*inW);

for(int i=0; i<inH; i++) {
	for(int k=0; k<inW; k++) {
		if(inImage[i][k]<avr)
            outImage[i][k]=0;
        else
            outImage[i][k]=255;
	}
}  */
//(3-4)
/* outH= inH;
outW= inW;
outImage = new int[outH][outW];
//** ��¥ ����ó�� �˰��� ** �Ķ󺼶� Cap
int[] LUT=new int[256];
for(int i=0;i<256;i++){
    int outV=255*(i/127 - 1)*(i/127 - 1);
    if(outV<0)
        outV=0;
    if(outV>255)
        outV=255;
    LUT[i]=outV;
}

for(int i=0; i<inH; i++) {
    for(int k=0; k<inW; k++) {
        outImage[i][k]=LUT[inImage[i][k]];
    }
} */

/* //(3-5)
outH= inH;
outW= inW;
outImage = new int[outH][outW];
//** ��¥ ����ó�� �˰��� ** ����������

int value=100;
for(int i=0; i<inH; i++) {
  for(int k=0; k<inW; k++) {
	  int px=inImage[i][k];
      if(px+value>255)
      px=255;
      else
      px=px+value;

      outImage[i][k] =px;
  }
} */

//(3-6)
/* outH= inH;
outW= inW;
outImage = new int[outH][outW];
//** ��¥ ����ó�� �˰��� ** �����Ⱘ��

int value=100;
for(int i=0; i<inH; i++) {
for(int k=0; k<inW; k++) {
	  int px=inImage[i][k];
    if(px+value<0)
    px=0;
    else
    px=px-value;

    outImage[i][k] =px;
}
} */

//(3-7)
/* outH= inH;
outW= inW;
outImage = new int[outH][outW];
//** ��¥ ����ó�� �˰��� ** ���Ϲ���

int value=100;
for(int i=0; i<inH; i++) {
	for(int k=0; k<inW; k++) {
	outImage[i][k] =inImage[outH-i-1][k];
	}
} */

//(3-8)
outH= inH;
outW= inW;
outImage = new int[outH][outW];
//** ��¥ ����ó�� �˰��� ** ���Ϲ���

int value=100;
for(int i=0; i<inH; i++) {
	for(int k=0; k<inW; k++) {
	outImage[i][k] =inImage[i][outH-k-1];
	}
}

// (4) ����� ���Ͽ� �����ϱ�
File outFp;
FileOutputStream outFs;
outFp = new File("C:/images/raw/Etc_Raw(squre)/Lenna512_out7.raw");
outFs = new FileOutputStream(outFp.getPath());
// �޸� --> ����
for(int i=0; i<outH; i++) {
	for(int k=0; k<outW; k++) {
		outFs.write(outImage[i][k]);
	}
}
outFs.close();

out.println("<h1> ���� ó�� ��! </h1>");
%>
</body>
</html>