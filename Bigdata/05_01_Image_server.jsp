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
<title>JSP ����ó�� (RC) ����</title>
</head>
<body>

<%!

// ���� ���� ����
int[][][] inImage;
int inH, inW;
int[][][] outImage=null;
int outH=0, outW=0;


//�Ķ���� ����
String inFile,outFile,algo,para1,para2;

//---------------------ȭ����
public void rvsImage(){
	// (3-1) ���� ó�� : out = 255 - in
	/*(�߿�!)��� ������ ũ�� ���� --> �˰��� ����*/
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//  ** ��¥ ����ó�� �˰��� **
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
				outImage[rgb][i][k] = 255 - inImage[rgb][i][k];
			}
		}
	}
}

public void plusImage(){ //����ϱ�
	// (3-2) ���ϱ� : out = in + (para1)
	// (�߿�!) ��� ������ ũ�� ���� --> �˰��� ����
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//  ** ��¥ ����ó�� �˰��� **
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

public void rvs128(){//128���ع���
	//(3-2)
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//  ** ��¥ ����ó�� �˰��� ** 128���� ���
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

public void avgrvs(){//��չ���
	//(3-3)
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//** ��¥ ����ó�� �˰��� ** ���������
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
	for(int rgb=0;rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
	    for(int k=0; k<inW; k++) {
	        outImage[rgb][i][k]=LUT[inImage[rgb][i][k]];
	    }
	} } }

public void paracup(){
	// (�߿�!) ��� ������ ũ�� ���� --> �˰��� ����
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//  ** ��¥ ����ó�� �˰��� **
	
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

//---------------------------������
public void updwImage(){
	//(3-7)
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	//** ��¥ ����ó�� �˰��� ** ���Ϲ���
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
	//** ��¥ ����ó�� �˰��� ** �¿����
	for(int rgb=0;rgb<3;rgb++){
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
			outImage[rgb][i][k] =inImage[rgb][i][outH-k-1];
			}
		} 
	}
}


public void zoomoutImage(){
	//(3-9)
	int scale = Integer.parseInt(para1);
	outH = inH/scale; //����� ũ�Ⱑ �Էº��� �۾�����. -->��ҿ���
    outW = inW/scale;
       
	// ** ����ó�� �˰��� ����
    for(int rgb=0;rgb<3;rgb++){
    	for(int i=0; i<inH; i++) {
    		for(int k=0; k<inW; k++) {
             outImage[rgb][(int)(i/scale)][(int)(k/scale)] =inImage[rgb][i][k];
             //ȭ�Ҹ� ��ġ�� �Ǵ� ����?
			}
		}
	}
}
public void zoominImage(){
	//(3-9)
	int scale2 = Integer.parseInt(para1);
	outH = inH/scale2; //����� ũ�Ⱑ �Էº��� �۾�����. -->Ȯ�뿵��
       outW = inW/scale2;
       
	// ** ����ó�� �˰��� ����
       for(int rgb=0;rgb<3;rgb++){
	       for(int i=0; i<inH; i++) {
	           for(int k=0; k<inW; k++) {
	               outImage[rgb][(int)(i/scale2)][(int)(k/scale2)] =inImage[rgb][i][k];
	               //ȭ�Ҹ� ��ġ�� �Ǵ� ����?
			}
		}
	}
}
//---------------------------������׷�
public void histostretch(){//������׷� ��Ʈ��Ī
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
		
	//�ִ� �ּ� ã��
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
public void endin(){//������
	//(3-10)
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** ����ó�� �˰��� ����
    int[] minValue =new int[3];
	int[] maxValue =new int[3];
	for(int rgb=0; rgb<3;rgb++){
		minValue[rgb]=inImage[rgb][0][0];
		maxValue[rgb]=inImage[rgb][0][0];
	}
       //�ִ� �ּ� ã��
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
       for(double i=0;i<256;i++){ //������̺� ����
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
public void histoequal(){//������׷� ��Ȱȭ
	//(3-10)
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** ����ó�� �˰��� ����
    // 1�ܰ�: ������׷� (���� �׷��� = �󵵼� ī��Ʈ)
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
	   // 2�ܰ� : ���� ������׷�
	   int sumHisto[][] = new int[3][256];
	   int sumValue[] = new int[3];
	   for(int rgb=0;rgb<3;rgb++){
	      for (int i=0; i<sumHisto[rgb].length; i++) {
	          sumValue[rgb] += histo[rgb][i];
	          sumHisto[rgb][i] = sumValue[rgb];
	      }
	   }
	   // 3�ܰ� : ����ȭ�� ���� ����Ʈ�׷�
	   double LUT[][]=new double[3][256];
	   for(int rgb=0;rgb<3;rgb++){
	      for (int i=0; i<256; i++){
	         LUT[rgb][i] = (double)sumHisto[rgb][i] * ( 1.0 / ((double)inH*(double)inW)) * 255.0;
             System.out.println("oi: "+sumHisto[rgb][i]);
	      }
	   }
	    // ���� : ����ȭ�� ������׷��� �����ؼ� �ȼ��� ��ȯ
	   for(int rgb=0;rgb<3;rgb++){
	       for(int i=0; i<inH; i++) {
	           for(int k=0; k<inW; k++) {
	               outImage[rgb][i][k] = (int)LUT[rgb][inImage[rgb][i][k]];
	           }
	       }
	   }

}
	
//-----------------����ũ
public void embossing() { //������
	// (�߿�!) ��� ������ ũ�� ���� --> �˰��� ����
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** ����ó�� �˰��� ����
    // mask --> ����ũ�� ũ���� ����, ���ΰ� ����, Ȧ��
    double[][] mask =  { {-1.0, 0.0, 0.0},
                     {0.0, 1.0, 0.0},
                     {0.0, 0.0, 0.0} };
	// �ӽ� �Է� �迭 (�Է¹迭 + 2)
	int[][][] tmpInImage = new int[3][inH+2][inW+2];
	//�ӽ� �Է� �迭 �ʱ�ȭ
	for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH + 2; i++) {
        for(int k=0; k<inW + 2; k++) {   
            tmpInImage[rgb][i][k] = 127; // ������ ������ ����..
        }
    }
}
	// �Է� ���� --> �ӽ� �Է� ������ ��� ��~!
    for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
        for(int k=0; k<inW; k++) {   
            tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
        }
    }
    }
 	// �ӽ� ��� ���� �غ�
    int[][][] tmpOutImage = new int[3][inH][inW];
    // ***����ó�� �˰��� --> ȸ������
    for(int rgb=0; rgb<3;rgb++){
    for(int i=0; i<inH; i++) {
        for(int k=0; k<inW; k++) {   
            // �� ���� ���� ó��
            int S = 0; // 9�� ���� ��
            for(int m=0; m<3; m++)
                for(int n=0; n<3; n++)
                    S += tmpInImage[rgb][i+m][k+n] * mask[m][n];
            tmpOutImage[rgb][i][k] = S;
        }
    }
    }
    // ��ó�� : ����ũ ���� 0 --> +127, ����ũ ���� 1 --> ��ó�� �ʿ� X
    for(int rgb=0; rgb<3;rgb++){
    for(int i=0; i<outH; i++) 
        for(int k=0; k<outW; k++) 
            tmpOutImage[rgb][i][k] +=127;
    }
    // �ӽ���� ���� --> ��� ����
    for(int rgb=0; rgb<3;rgb++){
	    for(int i=0; i<outH; i++) 
	        for(int k=0; k<outW; k++) 
	            outImage[rgb][i][k] = tmpOutImage[rgb][i][k];
		}

}


public void blurring() {//------------------------����------------------------
	// (�߿�!) ��� ������ ũ�� ���� --> �˰��� ����
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** ����ó�� �˰��� ����
 // mask --> ����ũ�� ũ���� ����, ���ΰ� ����, Ȧ��
 double[][] mask =  { {1/9.0, 1/9.0, 1/9.0},
		 			{1/9.0, 1/9.0, 1/9.0},
		 			{1/9.0, 1/9.0, 1/9.0} };
	// �ӽ� �Է� �迭 (�Է¹迭 + 2)
	int[][][] tmpInImage = new int[3][inH+2][inW+2];
	//�ӽ� �Է� �迭 �ʱ�ȭ ��ó�� : ����ũ ���� 0 --> +127, ����ũ ���� 1 --> ��ó�� �ʿ� X
	/* for(int rgb=0; rgb<3;rgb++)
	for(int i=0; i<inH + 2; i++) {
     for(int k=0; k<inW + 2; k++) {   
         tmpInImage[rgb][i][k] = 127; // ������ ������ ����..
     }
 } */
	// �Է� ���� --> �ӽ� �Է� ������ ��� ��~!
 for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
     for(int k=0; k<inW; k++) {   
         tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
		}
	}
}
	// �ӽ� ��� ���� �غ�
 int[][][] tmpOutImage = new int[3][inH][inW];
 // ***����ó�� �˰��� --> ȸ������
 for(int rgb=0; rgb<3;rgb++){
 for(int i=0; i<inH; i++) {
     for(int k=0; k<inW; k++) {   
         // �� ���� ���� ó��
         int S = 0; // 9�� ���� ��
         for(int m=0; m<3; m++)
             for(int n=0; n<3; n++)
                 S += tmpInImage[rgb][i+m][k+n] * mask[m][n];
         tmpOutImage[rgb][i][k] = S;
     }
 }
 }
 // �ӽ���� ���� --> ��� ����
 for(int rgb=0; rgb<3;rgb++){
 for(int i=0; i<outH; i++) 
     for(int k=0; k<outW; k++) 
         outImage[rgb][i][k] = tmpOutImage[rgb][i][k];
}}
//------------------------������------------------------
public void HPF() {
	// (�߿�!) ��� ������ ũ�� ���� --> �˰��� ����
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** ����ó�� �˰��� ����
// mask --> ����ũ�� ũ���� ����, ���ΰ� ����, Ȧ��
double[][] mask =  { {-1/9.0, -1/9.0, -1/9.0},
		 			{-1/9.0, 8/9.0, -1/9.0},
		 			{-1/9.0, -1/9.0, -1/9.0} };
	// �ӽ� �Է� �迭 (�Է¹迭 + 2)
	int[][][] tmpInImage = new int[3][inH+2][inW+2];
	//�ӽ� �Է� �迭 �ʱ�ȭ
	for(int rgb=0; rgb<3;rgb++){//��ó�� : ����ũ ���� 0 --> +127, ����ũ ���� 1 --> ��ó�� �ʿ� X
		for(int i=0; i<inH + 2; i++) {
			for(int k=0; k<inW + 2; k++) {   
       			tmpInImage[rgb][i][k] = 127; // ������ ������ ����..
   			}
		}
	}
	// �Է� ���� --> �ӽ� �Է� ������ ��� ��~!
for(int rgb=0; rgb<3;rgb++){	
for(int i=0; i<inH; i++) {
   for(int k=0; k<inW; k++) {   
       tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
   }
}}
	// �ӽ� ��� ���� �غ�
int[][][] tmpOutImage = new int[3][inH][inW];
// ***����ó�� �˰��� --> ȸ������
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
	   for(int k=0; k<inW; k++) {   
	       // �� ���� ���� ó��
	       int S = 0; // 9�� ���� ��
	       for(int m=0; m<3; m++)
	           for(int n=0; n<3; n++)
	               S += tmpInImage[rgb][i+m][k+n] * mask[m][n];
	       tmpOutImage[rgb][i][k] = S;
	   }
	}
}
// ��ó�� : ����ũ ���� 0 --> +127, ����ũ ���� 1 --> ��ó�� �ʿ� X
for(int rgb=0; rgb<3;rgb++)
	for(int i=0; i<outH; i++) 
	    for(int k=0; k<outW; k++) 
	        tmpOutImage[rgb][i][k] +=127;
// �ӽ���� ���� --> ��� ����
for(int rgb=0; rgb<3;rgb++)
	for(int i=0; i<outH; i++) 
	   for(int k=0; k<outW; k++) 
	       outImage[rgb][i][k] = tmpOutImage[rgb][i][k];
}
//------------------------������------------------------
public void sharpening() {
	// (�߿�!) ��� ������ ũ�� ���� --> �˰��� ����
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** ����ó�� �˰��� ����
//mask --> ����ũ�� ũ���� ����, ���ΰ� ����, Ȧ��
double[][] mask =  { {0.0, -1.0, 0.0},
		 			{-1.0, 5.0, -1.0},
		 			{0.0, -1.0, 0.0} };
// �ӽ� �Է� �迭 (�Է¹迭 + 2)
int[][][] tmpInImage = new int[3][inH+2][inW+2];
//�ӽ� �Է� �迭 �ʱ�ȭ
	/* for(int i=0; i<inH + 2; i++) {
		for(int k=0; k<inW + 2; k++) {   
	     	tmpInImage[i][k] = 127; // ������ ������ ����..
	 	}
	}  */
	// �Է� ���� --> �ӽ� �Է� ������ ��� ��~!
	for(int rgb=0; rgb<3;rgb++){
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {   
		    	tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
		 	}
		}
	}
	// �ӽ� ��� ���� �غ�
int[][][] tmpOutImage = new int[3][inH][inW];
//***����ó�� �˰��� --> ȸ������
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
	 	for(int k=0; k<inW; k++) {   
	     // �� ���� ���� ó��
	     int S = 0; // 9�� ���� ��
	     for(int m=0; m<3; m++)
	         for(int n=0; n<3; n++)
	             S += tmpInImage[rgb][i+m][k+n] * mask[m][n];
	     tmpOutImage[rgb][i][k] = S;
		}
	}
}
//�ӽ���� ���� --> ��� ����
for(int rgb=0; rgb<3;rgb++){	
	for(int i=0; i<outH; i++) {
		for(int k=0; k<outW; k++) {
			// ��ó��
			if(tmpOutImage[rgb][i][k] <0)
				tmpOutImage[rgb][i][k] = 0;
	    	if(tmpOutImage[rgb][i][k] > 255)
	    		tmpOutImage[rgb][i][k] = 255;
	     	outImage[rgb][i][k] = tmpOutImage[rgb][i][k];
			}
		}
}

}
//------------------------���� ���� �˰���------------------------
public void vEdge() {
	// (�߿�!) ��� ������ ũ�� ���� --> �˰��� ����
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** ����ó�� �˰��� ����
//mask --> ����ũ�� ũ���� ����, ���ΰ� ����, Ȧ��
double[][] mask =  { {0.0, -1.0, 0.0},
		 			{0.0, 1.0, 0.0},
		 			{0.0, 0.0, 0.0} };
//�ӽ� �Է� �迭 (�Է¹迭 + 2)
int[][][] tmpInImage = new int[3][inH+2][inW+2];
//�ӽ� �Է� �迭 �ʱ�ȭ
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH + 2; i++) {
		for(int k=0; k<inW + 2; k++) {   
	 		tmpInImage[rgb][i][k] = 127; // ������ ������ ����..
		}
	}
}
	// �Է� ���� --> �ӽ� �Է� ������ ��� ��~!
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
		for(int k=0; k<inW; k++) {   
			tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
		}
	}
}
	// �ӽ� ��� ���� �غ�
int[][][] tmpOutImage = new int[3][inH][inW];
//***����ó�� �˰��� --> ȸ������
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
		for(int k=0; k<inW; k++) {   
	 // �� ���� ���� ó��
	 int S = 0; // 9�� ���� ��
	 for(int m=0; m<3; m++)
	     for(int n=0; n<3; n++)
	         S += tmpInImage[rgb][i+m][k+n] * mask[m][n];
	 		tmpOutImage[rgb][i][k] = S;
		}
	}
}
//�ӽ���� ���� --> ��� ����
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<outH; i++) {
		for(int k=0; k<outW; k++) {
			// ��ó��
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
//------------------------���� ���� �˰���------------------------
public void hEdge() {
	// (�߿�!) ��� ������ ũ�� ���� --> �˰��� ����
	outH= inH;
	outW= inW;
	outImage = new int[3][outH][outW];
	// ** ����ó�� �˰��� ����
//mask --> ����ũ�� ũ���� ����, ���ΰ� ����, Ȧ��
double[][] mask =  { {0.0, 0.0, 0.0},
		 			{-1.0, 1.0, 0.0},
		 			{0.0, 0.0, 0.0} };
//�ӽ� �Է� �迭 (�Է¹迭 + 2)
int[][][] tmpInImage = new int[3][inH+2][inW+2];
//�ӽ� �Է� �迭 �ʱ�ȭ
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH + 2; i++) {
		for(int k=0; k<inW + 2; k++) {   
	   		tmpInImage[rgb][i][k] = 127; // ������ ������ ����..
		}
	}
}
	// �Է� ���� --> �ӽ� �Է� ������ ��� ��~!
for(int rgb=0; rgb<3;rgb++){	
	for(int i=0; i<inH; i++) {
		for(int k=0; k<inW; k++) {   
	  		tmpInImage[rgb][i+1][k+1] = inImage[rgb][i][k];
		}
	}
}
	// �ӽ� ��� ���� �غ�
int[][][] tmpOutImage = new int[3][inH][inW];
//***����ó�� �˰��� --> ȸ������
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<inH; i++) {
		for(int k=0; k<inW; k++) {   
	   // �� ���� ���� ó��
	   int S = 0; // 9�� ���� ��
	   for(int m=0; m<3; m++)
	       for(int n=0; n<3; n++)
	           S += tmpInImage[rgb][i+m][k+n] * mask[m][n];
	   		tmpOutImage[rgb][i][k] = S;
		}
	}
}
//�ӽ���� ���� --> ��� ����
for(int rgb=0; rgb<3;rgb++){
	for(int i=0; i<outH; i++) {
		for(int k=0; k<outW; k++) {
			// ��ó��
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
	case "101" : //������
		rvsImage();
		break;
	case "102" : //����ϱ�
		plusImage();
		break;
	case "103"://128���� ����
		rvs128();
		break;
	case "104"://��չ���
		avgrvs();
		break;
	case "105"://�Ķ󺼶� cap
		paracap();
		break;
	case "106"://�Ķ󺼶� cup
		paracup();
		break;
		
		
	case "201"://���Ϲ���
		updwImage();
		break;
	case "202"://�¿����
		rlImage();
		break;
	case "203"://�������
		zoomoutImage();
		break;
	case "204"://����Ȯ��
		zoominImage();
		break; 
		
	case "301": //������׷� ��Ʈ��Ī
		histostretch();
        break;
        
	case "302": //������
		endin();
        break;
        
	case "303": //������׷� ��Ȱȭ
		histoequal();
        break;        
        
	case"401": //������
		embossing();
		break;
	case"402"://����
		blurring();
		break;
	case "403": //HPF
		HPF();
		break;
	case "404": //������
		sharpening();
		break;
	case "405": //������������
		vEdge();
		break;	
	case "406": //����������
		hEdge();
		break;
}

//(4) ����� ���Ͽ� �����ϱ�
File outFp;
outFp = new File("C:/Out/out_"+filename);

BufferedImage oImage
	=new BufferedImage(outH,outW,BufferedImage.TYPE_INT_RGB);

//�޸� --> ����
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
out.println("<h1> ó�� �Ϸ� ! </h1>");
String url = "<p><h1><a href='http://192.168.56.101:8080/";
url += "Bigdata/download.jsp?file=";
url += "out_" + filename + "'>!!!�ٿ�ε�!!!!</a></h1>";

out.println(url);
%>
</body>
</html>