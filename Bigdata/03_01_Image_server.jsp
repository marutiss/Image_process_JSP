<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%@ page import="java.io.*" %>        
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>JSP 영상처리 (Preview 1) 서버</title>
</head>
<body>

<%



// 전역 변수 선언
int[][] inImage;
int inH, inW;
int[][] outImage=null;
int outH=0, outW=0;

//파라미터 변수
String inFile,outFile,algo,para1,para2;

MultipartRequest multi=new MultipartRequest(request,"C:/Upload",
		5*1024*1024,"utf-8",new DefaultFileRenamePolicy());

String tmp;
Enumeration params = multi.getParameterNames();
tmp=(String) params.nextElement();
para1=multi.getParameter(tmp);
tmp=(String) params.nextElement();
algo=multi.getParameter(tmp);
//파일전송하기
Enumeration files=multi.getFileNames(); //여러개의파일
tmp=(String) files.nextElement();
String filename=multi.getFilesystemName(tmp);

//(1) JSP 파일 처리
File inFp;
FileInputStream inFs;
inFp = new File("C:/Upload/" + filename);
inFs = new FileInputStream(inFp.getPath());
//(2) JSP 배열 처리 : 파일 --> 메모리(2차원 배열)
//(중요!) 입력 영상의 폭과 높이
long len = inFp.length();
inH = inW = (int)Math.sqrt(len);
inImage = new int[inH][inW];
//파일 -->메모리로 로딩
for(int i=0; i<inH; i++) {
	for(int k=0; k<inW; k++) {
		inImage[i][k] = inFs.read();
	}
}
inFs.close();

// (3) 영상처리 알고리즘 적용
switch(algo) {
	case "101" : 
		// (3-1) 반전 처리 : out = 255 - in
		// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
		outH= inH;
		outW= inW;
		outImage = new int[outH][outW];
		//  ** 진짜 영상처리 알고리즘 **
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
				outImage[i][k] = 255 - inImage[i][k];
			}
		}
		break;
	case "102" : 
		// (3-2) 더하기 : out = in + (para1)
		// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
		outH= inH;
		outW= inW;
		outImage = new int[outH][outW];
		//  ** 진짜 영상처리 알고리즘 **
		int value = Integer.parseInt(para1);
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
				if (inImage[i][k] + value > 255)
					outImage[i][k] = 255;
				else if (inImage[i][k] + value < 0)
					outImage[i][k] = 0;
				else
					outImage[i][k] = inImage[i][k] + value;
			}
		}
		break;
		
	case "103":
		//(3-2)
		outH= inH;
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
		}
		break;
		
	case "104":
		//(3-3)
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
		}  
		break;
		
	case "105":
		//(3-4)
		outH= inH;
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
		} 
		break;
	case "201":
		//(3-7)
		outH= inH;
		outW= inW;
		outImage = new int[outH][outW];
		//** 진짜 영상처리 알고리즘 ** 상하반전
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
			outImage[i][k] =inImage[outH-i-1][k];
			}
		} 
		break;
	case "202":
		//(3-8)
		outH= inH;
		outW= inW;
		outImage = new int[outH][outW];
		//** 진짜 영상처리 알고리즘 ** 좌우반전
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
			outImage[i][k] =inImage[i][outH-k-1];
			}
		} 
		break;
	/* case "203":
		//(3-9)
		int scale = Integer.parseInt(para1);
		outH = inH/scale; //출력의 크기가 입력보다 작아진다. -->축소영상
        outW = inW/scale;
        
		// ** 영상처리 알고리즘 구현
        
        for(int i=0; i<inH; i++) {
            for(int k=0; k<inW; k++) {
                outImage[(int)(i/scale)][(int)(k/scale)] =inImage[i][k];
                //화소를 겹치게 되는 형태?
			}
        }
		break;
	case "204":
		//(3-9)
		int scale2 = Integer.parseInt(para1);
		outH = inH/scale2; //출력의 크기가 입력보다 작아진다. -->확대영상
        outW = inW/scale2;
        
		// ** 영상처리 알고리즘 구현
        
        for(int i=0; i<inH; i++) {
            for(int k=0; k<inW; k++) {
                outImage[(int)(i/scale2)][(int)(k/scale2)] =inImage[i][k];
                //화소를 겹치게 되는 형태?
			}
        }
		break; */
		
	case "301": //히스토그램 스트래칭
		//(3-10)
		outH= inH;
		outW= inW;
		outImage = new int[outH][outW];
		int minValue = inImage[0][0];
		   int maxValue = inImage[0][0];
		   for(int i=0; i<inH; i++) {
		       for(int k=0; k<inW; k++) {   
		           if (inImage[i][k] < minValue) minValue = inImage[i][k];
		           if (inImage[i][k] > maxValue) maxValue = inImage[i][k];
		       }
		   }
		   // outValue =  ( inValue - minValue) / (maxValue - minValue) * 255
		   double LUT1[]=new double[256];
		   for(double i=0.0;i<LUT1.length;i++){
		        LUT1[(int)i] =  ( i - minValue) / (maxValue - minValue) * 255.0;
		        if (LUT1[(int)i] < 0) LUT1[(int)i] = 0.0;
		        if (LUT1[(int)i] > 255) LUT1[(int)i] = 255.0;
		    }
		   for(int i=0; i<inH; i++) {
		        for(int k=0; k<inW; k++) {   
		            outImage[i][k] = (int)LUT1[inImage[i][k]];
		        }
		    }
		
        break;
        
	case "302": //엔드인
		//(3-10)
		outH= inH;
		outW= inW;
		outImage = new int[outH][outW];
		// ** 영상처리 알고리즘 구현
        int minValue1=inImage[0][0];
        int maxValue1=inImage[0][0];
        //최대 최소 찾기
        for(int i=0; i<inH; i++) {
            for(int k=0; k<inW; k++) {
                
                if(inImage[i][k]<minValue1)
                    minValue1=inImage[i][k];
                if(inImage[i][k]>maxValue1)
                    maxValue1=inImage[i][k];
            }
        }

        minValue1=minValue1+50;
        maxValue1=maxValue1-50;
        
        double[] LUT2=new double[256];
        for(double i=0;i<256;i++){ //룩업테이블 생성
        	LUT2[(int)i]=(i-minValue1)/(maxValue1-minValue1) * 255;
            if(LUT2[(int)i]<0)
            	LUT2[(int)i]=0;
            if(LUT2[(int)i]>255)
            	LUT2[(int)i]=255;
            
        }
         //out=[(in-minValue)/(maxValue-minValue)]*255
        for(int i=0; i<inH; i++) {
            for(int k=0; k<inW; k++) {
                int inValue=inImage[i][k]; 
                outImage[i][k]=(int)LUT2[inImage[i][k]];
            }
        }
        break;
        
	case "303": //히스토그램 평활화
		//(3-10)
		outH= inH;
		outW= inW;
		outImage = new int[outH][outW];
		// ** 영상처리 알고리즘 구현
        // 1단계 : 히스토그램 (막대그래프 = 빈도수 카운트)
        double[] histo = new double[256];
        for (int i=0; i<256; i++) // 초기화 0
            histo[i] = 0;
        for(int i=0; i<inH; i++) {
            for(int k=0; k<inW; k++) {   //이미지 값=histo배열 위치값
                histo[inImage[i][k]]++;  //따라서 특정 이미지 값이 몇번나왔는지 저장.
            }
        }
        // 2단계 : 누적 히스토그램
        int[] sumHisto = new int[256];
        for (int i=0; i<256; i++) // 초기화 0
            sumHisto[i] = 0;
        int sumValue = 0;  //누적해서 sumHisto에 몇번 나왔는지 누적해서 기록. 누적값
        for (int i=0; i<256; i++) {
            sumValue += histo[i];
            sumHisto[i] = sumValue;
        }        
    
        // 3단계 : 정규화된 누적 히스트고램
        // n = sumHisto * ( 1 / 총픽셀수 ) * 최대픽셀밝기
        double[] normalHisto = new double[256];
        for (double i=0; i<256; i++) // 초기화 0
            normalHisto[(int)i] = 0;
        for (double i=0; i<256; i++)
            normalHisto[(int)i] = sumHisto[(int)i] * ( 1 / (inH*inW)) * 255;  //계산해서 최저 명도부터 누적명도 기록
        // 최종 : 정규화된 히스토그램을 적용해서 픽셀값 변환
        for(int i=0; i<inH; i++) {
            for(int k=0; k<inW; k++) {   
                outImage[i][k] = (int)(normalHisto[inImage[i][k]]); //최초픽셀부터 누적된 명도를 반올림처리해서 표현
            }
        }       
        break;        
        
}

//(4) 결과를 파일에 저장하기
File outFp;
FileOutputStream outFs;
outFp = new File("C:/Out/out_"+filename);
outFs = new FileOutputStream(outFp.getPath());
//메모리 --> 파일
for(int i=0; i<outH; i++) {
	for(int k=0; k<outW; k++) {
		outFs.write(outImage[i][k]);
	}
}
outFs.close();
out.println("<h1> 처리 완료 ! </h1>");
String url = "<p><h1><a href='http://192.168.56.101:8080/";
url += "Bigdata/download.jsp?file=";
url += "out_" + filename + "'>!!!다운로드!!!!</a></h1>";

out.println(url);
%>
</body>
</html>