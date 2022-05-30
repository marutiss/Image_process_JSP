<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
<title>JSP 영상처리 (RC) 서버</title>
</head>
<body>

<%!

// 전역 변수 선언
int[][][] inImage;
int inH, inW;
int[][][] outImage=null;
int outH=0, outW=0;


//파라미터 변수
String inFile,outFile,algo,para1,para2;


public double[] rgb2hsv(int r,int g,int b) {
	double max= Math.max(r, g);
    max=Math.max(max, b);
    double min=Math.min(r,g);
    min=Math.min(min,b);
    double d = max - min;
    double h=0;
    double s = (max == 0 ? 0 : d / max);
    double v = max / 255;
    if(max==min) h = 0;
    else if(max==r){
    	h = (g - b) + d * (g < b ? 6: 0);
    	h /= 6 * d;
    }
    else if(max==g){
    	h = (b - r) + d * 2;
    	h /= 6 * d;
    }
    else if(max==b){
    	h = (r - g) + d * 4;
    	h /= 6 * d;
    }
    
    double hsv[]={h,s,v};
    return hsv;
}
public int[] hsv2rgb(double h,double s,double v) {
    double r=0, g=0, b=0, i, f, p, q, t;

    h = h*360;  s = s*100;    v = v*100;

    // Make sure our arguments stay in-range
    h = Math.max(0, Math.min(360, h));
    s = Math.max(0, Math.min(100, s));
    v = Math.max(0, Math.min(100, v));
    
    h /= 360;   s /= 100;     v /= 100;

    i = Math.floor(h * 6);
    f = h * 6 - i;
    p = v * (1 - s);
    q = v * (1 - f * s);
    t = v * (1 - (1 - f) * s);
    switch ((int)(i % 6)) {
        case 0: r = v; g = t; b = p; break;
        case 1: r = q; g = v; b = p; break;
        case 2: r = p; g = v; b = t; break;
        case 3: r = p; g = q; b = v; break;
        case 4: r = t; g = p; b = v; break;
        case 5: r = v; g = p; b = q; break;
    }
    int rgb[]={(int)Math.round(r * 255),(int)Math.round(g * 255),(int)Math.round(b * 255)};
    return rgb;
}
//---------------------화소점
public void rvsImage(){
	// (3-1) 반전 처리 : out = 255 - in
	/*(중요!)출력 영상의 크기 결정 --> 알고리즘에 의존*/
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//  ** 진짜 영상처리 알고리즘 **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
				outImage[rgb][i][k] = 255 - inImage[rgb][i][k];
			}
		}
	}
}

public void grayImage(){
	// (3-1) 반전 처리 : out = 255 - in
	/*(중요!)출력 영상의 크기 결정 --> 알고리즘에 의존*/
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//  ** 진짜 영상처리 알고리즘 **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
				outImage[rgb][i][k]
						=(inImage[0][i][k]+inImage[1][i][k]+inImage[2][i][k])/3;
			}				
		}
	}
}

public void bwImage(){
	// (3-1) 반전 처리 : out = 255 - in
	/*(중요!)출력 영상의 크기 결정 --> 알고리즘에 의존*/
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//  ** 진짜 영상처리 알고리즘 **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
				int avg 
					= (inImage[0][i][k]+inImage[1][i][k]+inImage[2][i][k])/3;
				
				if(avg>127)
				outImage[rgb][i][k]=255;
				else
				outImage[rgb][i][k]=0;
			}				
		}
	}
}

public void plusImage(){ //밝게하기
	// (3-2) 더하기 : out = in + (para1)
	// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//  ** 진짜 영상처리 알고리즘 **
	int value = Integer.parseInt(para1);
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
				if (inImage[rgb][i][k] + value > 255)
					outImage[rgb][i][k] = 255;
				else if (inImage[rgb][i][k] + value < 0)
					outImage[rgb][i][k] = 0;
				else
					outImage[rgb][i][k] = inImage[rgb][i][k] + value;
			}
		}
	}
}

public void rvs128(){//128기준반전
	//(3-2)
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//  ** 진짜 영상처리 알고리즘 ** 128기준 흑백
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
				int px=inImage[rgb][i][k];
				if(px<128)
		            px=0;
		        else
		            px=255;
				
				outImage[rgb][i][k] =px;
			}
		}
	}
}

public void avgrvs(){//평균반전
	//(3-3)
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//** 진짜 영상처리 알고리즘 ** 평균흑백반전
	int result=0;
	for(int rgb=0;rgb<3;rgb++){
	 for(int i=0; i<inH; i++) {
	     for(int k=0; k<inW; k++) {
	         result+= inImage[rgb][i][k];
	     }
	 }
	}
	int avr=result/(inH*inW);
	
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
				if(inImage[rgb][i][k]<avr)
		            outImage[rgb][i][k]=0;
		        else
		            outImage[rgb][i][k]=255;
			}
		}
	}  
}
public void paracap(){
	//(3-4)
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//** 진짜 영상처리 알고리즘 ** 파라볼라 Cap
	int[] LUT=new int[256];
	for(int i=0;i<256;i++){
		double outV=255*(i/127 - 1)*(i/127 - 1);
	    if(outV<0)
	        outV=0;
	    if(outV>255)
	        outV=255;
	    LUT[i]=(int)outV;
	}
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
	    for(int k=0; k<inW; k++) {
	        outImage[rgb][i][k]=LUT[inImage[rgb][i][k]];
	    }
	} } }

public void paracup(){
	// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//  ** 진짜 영상처리 알고리즘 **
	
	int[] LUT = new int[256];
 	for(int i=0; i<256; i++){
     double outV =  -255.0 * ((i / 127.0) - 1.0) * ((i / 127.0) - 1.0) + 255.0; 
     if(outV <0)
         outV = 0.0;
     if(outV > 255)
         outV = 255.0;
     LUT[i] = (int)outV;
 }
 	for(int rgb=0; rgb<3; rgb++){
 		for(int i=0; i<inH; i++) {
     		for(int k=0; k<inW; k++) {   
         	outImage[rgb][i][k] = LUT[inImage[rgb][i][k]];
			}
		}
	}
} 

//---------------------------기하학
public void updwImage(){
	//(3-7)
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//** 진짜 영상처리 알고리즘 ** 상하반전
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
			outImage[rgb][i][k] =inImage[rgb][outH-i-1][k];
			}
		} 
	}
}
public void rlImage(){
	//(3-8)
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//** 진짜 영상처리 알고리즘 ** 좌우반전
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
			outImage[rgb][i][k] =inImage[rgb][i][outW-k-1];
			}
		} 
	}
}


public void zoomoutImage(){
	//(3-9)
	int scale = Integer.parseInt(para1);
	outH = inH/scale; //출력의 크기가 입력보다 작아진다. -->축소영상
    outW = inW/scale;
       
	// ** 영상처리 알고리즘 구현
    for(int rgb=0;rgb<3;rgb++){
    	for(int i=0; i<inH; i++) {
    		for(int k=0; k<inW; k++) {
             outImage[rgb][(int)(i/scale)][(int)(k/scale)] =inImage[rgb][i][k];
             //화소를 겹치게 되는 형태?
			}
		}
	}
}
public void zoominImage(){
	//(3-9)
	int scale2 = Integer.parseInt(para1);
	outH = inH/scale2; //출력의 크기가 입력보다 작아진다. -->확대영상
       outW = inW/scale2;
       
	// ** 영상처리 알고리즘 구현
       for(int rgb=0;rgb<3;rgb++){
	       for(int i=0; i<inH; i++) {
	           for(int k=0; k<inW; k++) {
	               outImage[rgb][(int)(i/scale2)][(int)(k/scale2)] =inImage[rgb][i][k];
	               //화소를 겹치게 되는 형태?
			}
		}
	}
}
//---------------------------히스토그램
public void histostretch(){//히스토그램 스트레칭
	//(3-10)
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	int[] minValue =new int[3];
	int[] maxValue =new int[3];
	for(int rgb=0; rgb<3;rgb++){
		minValue[rgb]=inImage[rgb][0][0];
		maxValue[rgb]=inImage[rgb][0][0];
	}
		
	//최대 최소 찾기
	for(int rgb=0;rgb<3;rgb++){   
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {   
		    	if (inImage[rgb][i][k] < minValue[rgb]) minValue[rgb] = inImage[rgb][i][k];
		    	if (inImage[rgb][i][k] > maxValue[rgb]) maxValue[rgb] = inImage[rgb][i][k];
			}
		}
	}
	   // outValue =  ( inValue - minValue) / (maxValue - minValue) * 255
	   double LUT1[][]=new double[3][256];
	   for(int rgb=0;rgb<3;rgb++){
	   for(double i=0.0;i<256;i++){
	        LUT1[rgb][(int)i] =  ( i - minValue[rgb]) / (maxValue[rgb] - minValue[rgb]) * 255.0;
	        if (LUT1[rgb][(int)i] < 0) LUT1[rgb][(int)i] = 0.0;
	        if (LUT1[rgb][(int)i] > 255) LUT1[rgb][(int)i] = 255.0;
	    }
	   }
	   for(int rgb=0;rgb<3;rgb++){
		   for(int i=0; i<inH; i++) {
		        for(int k=0; k<inW; k++) {   
		            outImage[rgb][i][k] = (int)LUT1[rgb][inImage[rgb][i][k]];
		        }
		    }
	   }
	   
}
public void endin(){//엔드인
	//(3-10)
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** 영상처리 알고리즘 구현
    int[] minValue =new int[3];
	int[] maxValue =new int[3];
	for(int rgb=0; rgb<3;rgb++){
		minValue[rgb]=inImage[rgb][0][0];
		maxValue[rgb]=inImage[rgb][0][0];
	}
       //최대 최소 찾기
       for(int rgb=0;rgb<3;rgb++){
       for(int i=0; i<inH; i++) {
           for(int k=0; k<inW; k++) {
	           if(inImage[rgb][i][k]<minValue[rgb])
	               minValue[rgb]=inImage[rgb][i][k];
	           if(inImage[rgb][i][k]>maxValue[rgb])
	               maxValue[rgb]=inImage[rgb][i][k];
			}
		}
	}
       
       for(int rgb=0;rgb<3;rgb++){
       minValue[rgb]=minValue[rgb]+50;
       maxValue[rgb]=maxValue[rgb]-50;
       }
       
       double LUT2[][]=new double[3][256];
       for(int rgb=0;rgb<3;rgb++){
       for(double i=0;i<256;i++){ //룩업테이블 생성
       	LUT2[rgb][(int)i]=(i-minValue[rgb])/(maxValue[rgb]-minValue[rgb]) * 255.0;
           if(LUT2[rgb][(int)i]<0)
           	LUT2[rgb][(int)i]=0;
           if(LUT2[rgb][(int)i]>255)
           	LUT2[rgb][(int)i]=255;
           
       }
       }
        //out=[(in-minValue)/(maxValue-minValue)]*255
       for(int rgb=0;rgb<3;rgb++){
	       for(int i=0; i<inH; i++) {
	           for(int k=0; k<inW; k++) {
	               outImage[rgb][i][k]=(int)LUT2[rgb][inImage[rgb][i][k]];
	           }
	       }
	   } 
}
public void histoequal(){//히스토그램 평활화
	//(3-10)
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** 영상처리 알고리즘 구현
    // 1단계: 히스토그램 (막대 그래프 = 빈도수 카운트)
	 int histo[][] = new int[3][256];
	   for(int rgb=0;rgb<3;rgb++){
	      for(int i=0;i<histo[rgb].length;i++){
	         histo[rgb][i]=0;
	      }
	   }
	   for(int rgb=0;rgb<3;rgb++){
	      for(int i=0; i<inH; i++) {
	          for(int k=0; k<inW; k++) {
	              histo[rgb][inImage[rgb][i][k]]++;
	          }
	      }
	   }
	   // 2단계 : 누적 히스토그램
	   int sumHisto[][] = new int[3][256];
	   int sumValue[] = new int[3];
	   for(int rgb=0;rgb<3;rgb++){
	      for (int i=0; i<sumHisto[rgb].length; i++) {
	          sumValue[rgb] += histo[rgb][i];
	          sumHisto[rgb][i] = sumValue[rgb];
	      }
	   }
	   // 3단계 : 정규화된 누적 히스트그램
	   double LUT[][]=new double[3][256];
	   for(int rgb=0;rgb<3;rgb++){
	      for (int i=0; i<256; i++){
	         LUT[rgb][i] = (double)sumHisto[rgb][i] * ( 1.0 / ((double)inH*(double)inW)) * 255.0;
             System.out.println("oi: "+sumHisto[rgb][i]);
	      }
	   }
	    // 최종 : 정규화된 히스토그램을 적용해서 픽셀값 변환
	   for(int rgb=0;rgb<3;rgb++){
	       for(int i=0; i<inH; i++) {
	           for(int k=0; k<inW; k++) {
	               outImage[rgb][i][k] = (int)LUT[rgb][inImage[rgb][i][k]];
	           }
	       }
	   }

}
	
//-----------------마스크
public void embossing() { //엠보싱
	// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** 영상처리 알고리즘 구현
    // mask --> 마스크의 크기의 가로, 세로가 같고, 홀수
    double[][] mask =  { {-1.0, 0.0, 0.0},
                     {0.0, 1.0, 0.0},
                     {0.0, 0.0, 0.0} };
	// 임시 입력 배열 (입력배열 + 2)
	int[][][] tmpInImage = new int[3][inH+2][inW+2];
	//임시 입력 배열 초기화
	for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH + 2; i++) {
        for(int k=0; k<inW + 2; k++) {   
            tmpInImage[rgb][i][k] = 127; // 개선의 여지가 있음..
        }
    }
}
	// 입력 영상 --> 임시 입력 영상의 가운데 쏙~!
    for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
        for(int k=0; k<inW; k++) {   
            tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
        }
    }
    }
 	// 임시 출력 영상 준비
    int[][][] tmpOutImage = new int[3][inH][inW];
    // ***영상처리 알고리즘 --> 회선연산
    for(int rgb=0; rgb<3;rgb++){
    for(int i=0; i<inH; i++) {
        for(int k=0; k<inW; k++) {   
            // 한 점에 대해 처리
            int S = 0; // 9개 곱한 합
            for(int m=0; m<3; m++)
                for(int n=0; n<3; n++)
                    S += tmpInImage[rgb][i+m][k+n] * mask[m][n];
            tmpOutImage[rgb][i][k] = S;
        }
    }
    }
    // 후처리 : 마스크 합이 0 --> +127, 마스크 합이 1 --> 후처리 필요 X
    for(int rgb=0; rgb<3;rgb++){
    for(int i=0; i<outH; i++) 
        for(int k=0; k<outW; k++) 
            tmpOutImage[rgb][i][k] +=127;
    }
    // 임시출력 영상 --> 출력 영상
    for(int rgb=0; rgb<3;rgb++){
	    for(int i=0; i<outH; i++) 
	        for(int k=0; k<outW; k++) 
	            outImage[rgb][i][k] = tmpOutImage[rgb][i][k];
		}

}


public void blurring() {//------------------------블러링------------------------
	// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** 영상처리 알고리즘 구현
 // mask --> 마스크의 크기의 가로, 세로가 같고, 홀수
 double[][] mask =  { {1/9.0, 1/9.0, 1/9.0},
		 			{1/9.0, 1/9.0, 1/9.0},
		 			{1/9.0, 1/9.0, 1/9.0} };
	// 임시 입력 배열 (입력배열 + 2)
	int[][][] tmpInImage = new int[3][inH+2][inW+2];
	//임시 입력 배열 초기화 후처리 : 마스크 합이 0 --> +127, 마스크 합이 1 --> 후처리 필요 X
	/* for(int rgb=0; rgb<3;rgb++)
	for(int i=0; i<inH + 2; i++) {
     for(int k=0; k<inW + 2; k++) {   
         tmpInImage[rgb][i][k] = 127; // 개선의 여지가 있음..
     }
 } */
	// 입력 영상 --> 임시 입력 영상의 가운데 쏙~!
 for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
     for(int k=0; k<inW; k++) {   
         tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
		}
	}
}
	// 임시 출력 영상 준비
 int[][][] tmpOutImage = new int[3][inH][inW];
 // ***영상처리 알고리즘 --> 회선연산
 for(int rgb=0; rgb<3;rgb++){
 for(int i=0; i<inH; i++) {
     for(int k=0; k<inW; k++) {   
         // 한 점에 대해 처리
         int S = 0; // 9개 곱한 합
         for(int m=0; m<3; m++)
             for(int n=0; n<3; n++)
                 S += tmpInImage[rgb][i+m][k+n] * mask[m][n];
         tmpOutImage[rgb][i][k] = S;
     }
 }
 }
 // 임시출력 영상 --> 출력 영상
 for(int rgb=0; rgb<3;rgb++){
 for(int i=0; i<outH; i++) 
     for(int k=0; k<outW; k++) 
         outImage[rgb][i][k] = tmpOutImage[rgb][i][k];
}}
//------------------------고주파------------------------
public void HPF() {
	// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** 영상처리 알고리즘 구현
// mask --> 마스크의 크기의 가로, 세로가 같고, 홀수
double[][] mask =  { {-1/9.0, -1/9.0, -1/9.0},
		 			{-1/9.0, 8/9.0, -1/9.0},
		 			{-1/9.0, -1/9.0, -1/9.0} };
	// 임시 입력 배열 (입력배열 + 2)
	int[][][] tmpInImage = new int[3][inH+2][inW+2];
	//임시 입력 배열 초기화
	for(int rgb=0; rgb<3;rgb++){//후처리 : 마스크 합이 0 --> +127, 마스크 합이 1 --> 후처리 필요 X
		for(int i=0; i<inH + 2; i++) {
			for(int k=0; k<inW + 2; k++) {   
       			tmpInImage[rgb][i][k] = 127; // 개선의 여지가 있음..
   			}
		}
	}
	// 입력 영상 --> 임시 입력 영상의 가운데 쏙~!
for(int rgb=0; rgb<3;rgb++){	
for(int i=0; i<inH; i++) {
   for(int k=0; k<inW; k++) {   
       tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
   }
}}
	// 임시 출력 영상 준비
int[][][] tmpOutImage = new int[3][inH][inW];
// ***영상처리 알고리즘 --> 회선연산
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
	   for(int k=0; k<inW; k++) {   
	       // 한 점에 대해 처리
	       int S = 0; // 9개 곱한 합
	       for(int m=0; m<3; m++)
	           for(int n=0; n<3; n++)
	               S += tmpInImage[rgb][i+m][k+n] * mask[m][n];
	       tmpOutImage[rgb][i][k] = S;
	   }
	}
}
// 후처리 : 마스크 합이 0 --> +127, 마스크 합이 1 --> 후처리 필요 X
for(int rgb=0; rgb<3;rgb++)
	for(int i=0; i<outH; i++) 
	    for(int k=0; k<outW; k++) 
	        tmpOutImage[rgb][i][k] +=127;
// 임시출력 영상 --> 출력 영상
for(int rgb=0; rgb<3;rgb++)
	for(int i=0; i<outH; i++) 
	   for(int k=0; k<outW; k++) 
	       outImage[rgb][i][k] = tmpOutImage[rgb][i][k];
}

public void LPF() {
	// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** 영상처리 알고리즘 구현
// mask --> 마스크의 크기의 가로, 세로가 같고, 홀수
double[][] mask =  { {1/9.0, 1/9.0, 1/9.0},
		 			{1/9.0, 1/9.0, 1/9.0},
		 			{1/9.0, 1/9.0, 1/9.0} };
	// 임시 입력 배열 (입력배열 + 2)
	int[][][] tmpInImage = new int[3][inH+2][inW+2];
	//임시 입력 배열 초기화
	/* for(int rgb=0; rgb<3;rgb++){//후처리 : 마스크 합이 0 --> +127, 마스크 합이 1 --> 후처리 필요 X
		for(int i=0; i<inH + 2; i++) {
			for(int k=0; k<inW + 2; k++) {   
       			tmpInImage[rgb][i][k] = 127; // 개선의 여지가 있음..
   			}
		}
	} */
	// 입력 영상 --> 임시 입력 영상의 가운데 쏙~!
for(int rgb=0; rgb<3;rgb++){	
for(int i=0; i<inH; i++) {
   for(int k=0; k<inW; k++) {   
       tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
   }
}}
	// 임시 출력 영상 준비
int[][][] tmpOutImage = new int[3][inH][inW];
// ***영상처리 알고리즘 --> 회선연산
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
	   for(int k=0; k<inW; k++) {   
	       // 한 점에 대해 처리
	       int S = 0; // 9개 곱한 합
	       for(int m=0; m<3; m++)
	           for(int n=0; n<3; n++)
	               S += tmpInImage[rgb][i+m][k+n] * mask[m][n];
	       tmpOutImage[rgb][i][k] = S;
	   }
	}
}
// 후처리 : 마스크 합이 0 --> +127, 마스크 합이 1 --> 후처리 필요 X
for(int rgb=0; rgb<3;rgb++)
	for(int i=0; i<outH; i++) 
	    for(int k=0; k<outW; k++) 
	        tmpOutImage[rgb][i][k] +=127;
// 임시출력 영상 --> 출력 영상
for(int rgb=0; rgb<3;rgb++)
	for(int i=0; i<outH; i++) 
	   for(int k=0; k<outW; k++) 
	       outImage[rgb][i][k] = tmpOutImage[rgb][i][k];
}

//------------------------샤프닝------------------------
public void sharpening() {
	// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** 영상처리 알고리즘 구현
//mask --> 마스크의 크기의 가로, 세로가 같고, 홀수
double[][] mask =  { {0.0, -1.0, 0.0},
		 			{-1.0, 5.0, -1.0},
		 			{0.0, -1.0, 0.0} };
// 임시 입력 배열 (입력배열 + 2)
int[][][] tmpInImage = new int[3][inH+2][inW+2];
//임시 입력 배열 초기화
	/* for(int i=0; i<inH + 2; i++) {
		for(int k=0; k<inW + 2; k++) {   
	     	tmpInImage[i][k] = 127; // 개선의 여지가 있음..
	 	}
	}  */
	// 입력 영상 --> 임시 입력 영상의 가운데 쏙~!
	for(int rgb=0; rgb<3;rgb++){
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {   
		    	tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
		 	}
		}
	}
	// 임시 출력 영상 준비
int[][][] tmpOutImage = new int[3][inH][inW];
//***영상처리 알고리즘 --> 회선연산
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
	 	for(int k=0; k<inW; k++) {   
	     // 한 점에 대해 처리
	     int S = 0; // 9개 곱한 합
	     for(int m=0; m<3; m++)
	         for(int n=0; n<3; n++)
	             S += tmpInImage[rgb][i+m][k+n] * mask[m][n];
	     tmpOutImage[rgb][i][k] = S;
		}
	}
}
//임시출력 영상 --> 출력 영상
for(int rgb=0; rgb<3;rgb++){	
	for(int i=0; i<outH; i++) {
		for(int k=0; k<outW; k++) {
			// 후처리
			if(tmpOutImage[rgb][i][k] <0)
				tmpOutImage[rgb][i][k] = 0;
	    	if(tmpOutImage[rgb][i][k] > 255)
	    		tmpOutImage[rgb][i][k] = 255;
	     	outImage[rgb][i][k] = tmpOutImage[rgb][i][k];
			}
		}
}

}
//------------------------수직 에지 알고리즘------------------------
public void vEdge() {
	// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** 영상처리 알고리즘 구현
//mask --> 마스크의 크기의 가로, 세로가 같고, 홀수
double[][] mask =  { {0.0, -1.0, 0.0},
		 			{0.0, 1.0, 0.0},
		 			{0.0, 0.0, 0.0} };
//임시 입력 배열 (입력배열 + 2)
int[][][] tmpInImage = new int[3][inH+2][inW+2];
//임시 입력 배열 초기화
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH + 2; i++) {
		for(int k=0; k<inW + 2; k++) {   
	 		tmpInImage[rgb][i][k] = 127; // 개선의 여지가 있음..
		}
	}
}
	// 입력 영상 --> 임시 입력 영상의 가운데 쏙~!
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
		for(int k=0; k<inW; k++) {   
			tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
		}
	}
}
	// 임시 출력 영상 준비
int[][][] tmpOutImage = new int[3][inH][inW];
//***영상처리 알고리즘 --> 회선연산
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
		for(int k=0; k<inW; k++) {   
	 // 한 점에 대해 처리
	 int S = 0; // 9개 곱한 합
	 for(int m=0; m<3; m++)
	     for(int n=0; n<3; n++)
	         S += tmpInImage[rgb][i+m][k+n] * mask[m][n];
	 		tmpOutImage[rgb][i][k] = S;
		}
	}
}
//임시출력 영상 --> 출력 영상
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<outH; i++) {
		for(int k=0; k<outW; k++) {
			// 후처리
			tmpOutImage[rgb][i][k] +=127;
			if(tmpOutImage[rgb][i][k] <0)
				tmpOutImage[rgb][i][k] = 0;
	  	if(tmpOutImage[rgb][i][k] > 255)
	  		tmpOutImage[rgb][i][k] = 255;
	 	outImage[rgb][i][k] = tmpOutImage[rgb][i][k];
			}
		}
	}
	
	
	

}
//------------------------수평 에지 알고리즘------------------------
public void hEdge() {
	// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** 영상처리 알고리즘 구현
//mask --> 마스크의 크기의 가로, 세로가 같고, 홀수
double[][] mask =  { {0.0, 0.0, 0.0},
		 			{-1.0, 1.0, 0.0},
		 			{0.0, 0.0, 0.0} };
//임시 입력 배열 (입력배열 + 2)
int[][][] tmpInImage = new int[3][inH+2][inW+2];
//임시 입력 배열 초기화
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH + 2; i++) {
		for(int k=0; k<inW + 2; k++) {   
	   		tmpInImage[rgb][i][k] = 127; // 개선의 여지가 있음..
		}
	}
}
	// 입력 영상 --> 임시 입력 영상의 가운데 쏙~!
for(int rgb=0; rgb<3;rgb++){	
	for(int i=0; i<inH; i++) {
		for(int k=0; k<inW; k++) {   
	  		tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
		}
	}
}
	// 임시 출력 영상 준비
int[][][] tmpOutImage = new int[3][inH][inW];
//***영상처리 알고리즘 --> 회선연산
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
		for(int k=0; k<inW; k++) {   
	   // 한 점에 대해 처리
	   int S = 0; // 9개 곱한 합
	   for(int m=0; m<3; m++)
	       for(int n=0; n<3; n++)
	           S += tmpInImage[rgb][i+m][k+n] * mask[m][n];
	   		tmpOutImage[rgb][i][k] = S;
		}
	}
}
//임시출력 영상 --> 출력 영상
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<outH; i++) {
		for(int k=0; k<outW; k++) {
			// 후처리
			tmpOutImage[rgb][i][k] +=127;
			if(tmpOutImage[rgb][i][k] <0)
				tmpOutImage[rgb][i][k] = 0;
	    	if(tmpOutImage[rgb][i][k] > 255)
	    		tmpOutImage[rgb][i][k] = 255;
	   	outImage[rgb][i][k] = tmpOutImage[rgb][i][k];
			}
		}
	}
}

public void laple() {
	// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
		outH= inH;
		outW= inW;
		outImage = new int[3][outH][outW];
		// ** 영상처리 알고리즘 구현
	//mask --> 마스크의 크기의 가로, 세로가 같고, 홀수
	double[][] mask =  { {0.0, -1.0, 0.0},
			 			{-1.0, 4.0, -1.0},
			 			{0.0, -1.0, 0.0} };
	//임시 입력 배열 (입력배열 + 2)
	int[][][] tmpInImage = new int[3][inH+2][inW+2];
	//임시 입력 배열 초기화
	for(int rgb=0; rgb<3;rgb++){
		for(int i=0; i<inH + 2; i++) {
			for(int k=0; k<inW + 2; k++) {   
		   		tmpInImage[rgb][i][k] = 127; // 개선의 여지가 있음..
			}
		}
	}
		// 입력 영상 --> 임시 입력 영상의 가운데 쏙~!
	for(int rgb=0; rgb<3;rgb++){	
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {   
		  		tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
			}
		}
	}
		// 임시 출력 영상 준비
	int[][][] tmpOutImage = new int[3][inH][inW];
	//***영상처리 알고리즘 --> 회선연산
	for(int rgb=0; rgb<3;rgb++){
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {   
		   // 한 점에 대해 처리
		   int S = 0; // 9개 곱한 합
		   for(int m=0; m<3; m++)
		       for(int n=0; n<3; n++)
		           S += tmpInImage[rgb][i+m][k+n] * mask[m][n];
		   		tmpOutImage[rgb][i][k] = S;
			}
		}
	}
	//임시출력 영상 --> 출력 영상
	for(int rgb=0; rgb<3;rgb++){
		for(int i=0; i<outH; i++) {
			for(int k=0; k<outW; k++) {
				// 후처리
				tmpOutImage[rgb][i][k] +=127;
				if(tmpOutImage[rgb][i][k] <0)
					tmpOutImage[rgb][i][k] = 0;
		    	if(tmpOutImage[rgb][i][k] > 255)
		    		tmpOutImage[rgb][i][k] = 255;
		   	outImage[rgb][i][k] = tmpOutImage[rgb][i][k];
				}
			}
		}
	
	
	

}
//------------------------ CV
public void changeVal() { //----명도(V)) 변경
	// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
		outH= inH;
		outW= inW;
		outImage = new int[3][outH][outW];
    
    // ** 진짜 영상처리 알고리즘 **
    double value = Float.parseFloat(para1);
    for (int i=0; i<inH; i++) {
            for (int k=0; k<inW; k++) {
            	int R=inImage[0][i][k];
            	int G=inImage[1][i][k];
            	int B=inImage[2][i][k];
                //RGB-->HSV
                double[] hsv =rgb2hsv(R,G,B);
                double H=hsv[0];
                double S=hsv[1];
                double V=hsv[2];
                //체도변경
                V=V+value;
                //HSV-->RGB
                int[] rgb=hsv2rgb(H,S,V);
                int r=rgb[0];
                int g=rgb[1];
                int b=rgb[2];
                //출력이미지에 넣기
                outImage[0][i][k]=r;
                outImage[1][i][k]=g;
                outImage[2][i][k]=b;

            }
        }
   
}

public void changeSatur() { //----채도(S) 변경
	// (중요!) 출력 영상의 크기 결정 --> 알고리즘에 의존
		outH= inH;
		outW= inW;
		outImage = new int[3][outH][outW];
    
    // ** 진짜 영상처리 알고리즘 **
    double value = Float.parseFloat(para1);
    for (int i=0; i<inH; i++) {
            for (int k=0; k<inW; k++) {
            	int R=inImage[0][i][k];
            	int G=inImage[1][i][k];
            	int B=inImage[2][i][k];
                //RGB-->HSV
                double[] hsv =rgb2hsv(R,G,B);
                double H=hsv[0];
                double S=hsv[1];
                double V=hsv[2];
                //체도변경
                S=S+value;
                //HSV-->RGB
                int[] rgb=hsv2rgb(H,S,V);
                int r=rgb[0];
                int g=rgb[1];
                int b=rgb[2];
                //출력이미지에 넣기
                outImage[0][i][k]=r;
                outImage[1][i][k]=g;
                outImage[2][i][k]=b;

            }
        }
   
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
	case "101" : //색반전
		rvsImage();
		break;
	case "102" : //밝게하기
		plusImage();
		break;
	case "103"://128기준 반전
		rvs128();
		break;
	case "104"://평균반전
		avgrvs();
		break;
	case "105"://파라볼라 cap
		paracap();
		break;
	case "106"://파라볼라 cup
		paracup();
		break;
	case "107":
		grayImage();
		break;
	case "108":
		bwImage();
		break;
		
		
	case "201"://상하반전
		rlImage();
		break;
	case "202"://좌우반전
		updwImage();
		break;
	case "203"://영상축소
		zoomoutImage();
		break;
	case "204"://영상확대
		zoominImage();
		break; 
		
	case "301": //히스토그램 스트래칭
		histostretch();
        break;
        
	case "302": //엔드인
		endin();
        break;
        
	case "303": //히스토그램 평활화
		histoequal();
        break;        
        
	case"401": //엠보싱
		embossing();
		break;
	case"402"://블러링
		blurring();
		break;
	case "403": //HPF
		HPF();
		break;
	case "404": //샤프닝
		sharpening();
		break;
	case "405": //수직엣지검출
		vEdge();
		break;	
	case "406": //수평엣지검출
		hEdge();
		break;
	case "407"://LPF
		LPF();
		break;
	case "408":
		laple();
		break;
		
	case "501"://채도변경
		changeSatur();
		break;
	case "502"://명도변경
		changeVal();
		break;
}

//(4) 결과를 파일에 저장하기
File outFp;
outFp = new File("C:/Out/out_"+filename);

BufferedImage oImage
	=new BufferedImage(outH,outW,BufferedImage.TYPE_INT_RGB);

//메모리 --> 파일
for(int i=0; i<outH; i++) {
	for(int k=0; k<outW; k++) {
		int r=outImage[0][i][k];
		int g=outImage[1][i][k];
		int b=outImage[2][i][k];
		int px=0;
		px=px|(r<<16);
		px=px|(g<<8);
		px=px|(b<<0);
		oImage.setRGB(i,k,px);
	}
}
ImageIO.write(oImage, "jpg", outFp);
out.println("<h1> 처리 완료 ! </h1>");
out.println("<h3> 파일명 : </h3>"+filename);
String url = "<p><h1><a href='http://192.168.56.101:8080/";
url += "Bigdata/download.jsp?file=";
url += "out_" + filename + "'>!!!다운로드!!!!</a></h1>";

out.println(url);
%>
</body>
</html>