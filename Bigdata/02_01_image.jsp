<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ page import="java.io.*" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>서버 사이드 영상 처리(Alpha 1)</title>
</head>
<body>
<%
// 전역 변수 준비
int[][] inImage;
int inH, inW;
int[][] outImage;
int outH, outW;

// (1) JSP 파일 처리
File inFp;
FileInputStream inFs;
inFp = new File("C:/images/raw/Etc_Raw(squre)/Lenna512.raw");
inFs = new FileInputStream(inFp.getPath());
// (2) JSP 배열 처리 : 파일 --> 메모리(2차원 배열)
// (중요!) 입력 영상의 폭과 높이
inH = inW = 512;
inImage = new int[inH][inW];
// 파일 -->메모리로 로딩
for(int i=0; i<inH; i++) {
	for(int k=0; k<inW; k++) {
		inImage[i][k] = inFs.read();
	}
}
inFs.close();

// (3) 영상 처리 알고리즘 구현
// (3-1) 반전 처리 : out = 255 - in
// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
/* outH= inH;
outW= inW;
outImage = new int[outH][outW];
//  ** 진짜 영상처리 알고리즘 **
for(int i=0; i<inH; i++) {
	for(int k=0; k<inW; k++) {
		outImage[i][k] = 255 - inImage[i][k];
	}
}  */
//(3-2)
/* outH= inH;
outW= inW;
outImage = new int[outH][outW];
//  ** 진짜 영상처리 알고리즘 ** 128기준 흑백
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
//** 진짜 영상처리 알고리즘 ** 평균흑백반전
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
//** 진짜 영상처리 알고리즘 ** 파라볼라 Cap
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
//** 진짜 영상처리 알고리즘 ** 영상밝기증가

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
//** 진짜 영상처리 알고리즘 ** 영상밝기감소

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
//** 진짜 영상처리 알고리즘 ** 상하반전

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
//** 진짜 영상처리 알고리즘 ** 상하반전

int value=100;
for(int i=0; i<inH; i++) {
	for(int k=0; k<inW; k++) {
	outImage[i][k] =inImage[i][outH-k-1];
	}
}

// (4) 결과를 파일에 저장하기
File outFp;
FileOutputStream outFs;
outFp = new File("C:/images/raw/Etc_Raw(squre)/Lenna512_out7.raw");
outFs = new FileOutputStream(outFp.getPath());
// 메모리 --> 파일
for(int i=0; i<outH; i++) {
	for(int k=0; k<outW; k++) {
		outFs.write(outImage[i][k]);
	}
}
outFs.close();

out.println("<h1> 영상 처리 끝! </h1>");
%>
</body>
</html>