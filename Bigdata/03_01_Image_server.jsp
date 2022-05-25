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
<title>JSP ����ó�� (Preview 1) ����</title>
</head>
<body>

<%



// ���� ���� ����
int[][] inImage;
int inH, inW;
int[][] outImage=null;
int outH=0, outW=0;

//�Ķ���� ����
String inFile,outFile,algo,para1,para2;

MultipartRequest multi=new MultipartRequest(request,"C:/Upload",
		5*1024*1024,"utf-8",new DefaultFileRenamePolicy());

String tmp;
Enumeration params = multi.getParameterNames();
tmp=(String) params.nextElement();
para1=multi.getParameter(tmp);
tmp=(String) params.nextElement();
algo=multi.getParameter(tmp);
//���������ϱ�
Enumeration files=multi.getFileNames(); //������������
tmp=(String) files.nextElement();
String filename=multi.getFilesystemName(tmp);

//(1) JSP ���� ó��
File inFp;
FileInputStream inFs;
inFp = new File("C:/Upload/" + filename);
inFs = new FileInputStream(inFp.getPath());
//(2) JSP �迭 ó�� : ���� --> �޸�(2���� �迭)
//(�߿�!) �Է� ������ ���� ����
long len = inFp.length();
inH = inW = (int)Math.sqrt(len);
inImage = new int[inH][inW];
//���� -->�޸𸮷� �ε�
for(int i=0; i<inH; i++) {
	for(int k=0; k<inW; k++) {
		inImage[i][k] = inFs.read();
	}
}
inFs.close();

// (3) ����ó�� �˰��� ����
switch(algo) {
	case "101" : 
		// (3-1) ���� ó�� : out = 255 - in
		// (�߿�!) ��� ������ ũ�� ���� --> �˰��� ����
		outH= inH;
		outW= inW;
		outImage = new int[outH][outW];
		//  ** ��¥ ����ó�� �˰��� **
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
				outImage[i][k] = 255 - inImage[i][k];
			}
		}
		break;
	case "102" : 
		// (3-2) ���ϱ� : out = in + (para1)
		// (�߿�!) ��� ������ ũ�� ���� --> �˰��� ����
		outH= inH;
		outW= inW;
		outImage = new int[outH][outW];
		//  ** ��¥ ����ó�� �˰��� **
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
		}
		break;
		
	case "104":
		//(3-3)
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
		}  
		break;
		
	case "105":
		//(3-4)
		outH= inH;
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
		} 
		break;
	case "201":
		//(3-7)
		outH= inH;
		outW= inW;
		outImage = new int[outH][outW];
		//** ��¥ ����ó�� �˰��� ** ���Ϲ���
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
		//** ��¥ ����ó�� �˰��� ** �¿����
		for(int i=0; i<inH; i++) {
			for(int k=0; k<inW; k++) {
			outImage[i][k] =inImage[i][outH-k-1];
			}
		} 
		break;
	/* case "203":
		//(3-9)
		int scale = Integer.parseInt(para1);
		outH = inH/scale; //����� ũ�Ⱑ �Էº��� �۾�����. -->��ҿ���
        outW = inW/scale;
        
		// ** ����ó�� �˰��� ����
        
        for(int i=0; i<inH; i++) {
            for(int k=0; k<inW; k++) {
                outImage[(int)(i/scale)][(int)(k/scale)] =inImage[i][k];
                //ȭ�Ҹ� ��ġ�� �Ǵ� ����?
			}
        }
		break;
	case "204":
		//(3-9)
		int scale2 = Integer.parseInt(para1);
		outH = inH/scale2; //����� ũ�Ⱑ �Էº��� �۾�����. -->Ȯ�뿵��
        outW = inW/scale2;
        
		// ** ����ó�� �˰��� ����
        
        for(int i=0; i<inH; i++) {
            for(int k=0; k<inW; k++) {
                outImage[(int)(i/scale2)][(int)(k/scale2)] =inImage[i][k];
                //ȭ�Ҹ� ��ġ�� �Ǵ� ����?
			}
        }
		break; */
		
	case "301": //������׷� ��Ʈ��Ī
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
        
	case "302": //������
		//(3-10)
		outH= inH;
		outW= inW;
		outImage = new int[outH][outW];
		// ** ����ó�� �˰��� ����
        int minValue1=inImage[0][0];
        int maxValue1=inImage[0][0];
        //�ִ� �ּ� ã��
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
        for(double i=0;i<256;i++){ //������̺� ����
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
        
	case "303": //������׷� ��Ȱȭ
		//(3-10)
		outH= inH;
		outW= inW;
		outImage = new int[outH][outW];
		// ** ����ó�� �˰��� ����
        // 1�ܰ� : ������׷� (����׷��� = �󵵼� ī��Ʈ)
        double[] histo = new double[256];
        for (int i=0; i<256; i++) // �ʱ�ȭ 0
            histo[i] = 0;
        for(int i=0; i<inH; i++) {
            for(int k=0; k<inW; k++) {   //�̹��� ��=histo�迭 ��ġ��
                histo[inImage[i][k]]++;  //���� Ư�� �̹��� ���� ������Դ��� ����.
            }
        }
        // 2�ܰ� : ���� ������׷�
        int[] sumHisto = new int[256];
        for (int i=0; i<256; i++) // �ʱ�ȭ 0
            sumHisto[i] = 0;
        int sumValue = 0;  //�����ؼ� sumHisto�� ��� ���Դ��� �����ؼ� ���. ������
        for (int i=0; i<256; i++) {
            sumValue += histo[i];
            sumHisto[i] = sumValue;
        }        
    
        // 3�ܰ� : ����ȭ�� ���� ����Ʈ��
        // n = sumHisto * ( 1 / ���ȼ��� ) * �ִ��ȼ����
        double[] normalHisto = new double[256];
        for (double i=0; i<256; i++) // �ʱ�ȭ 0
            normalHisto[(int)i] = 0;
        for (double i=0; i<256; i++)
            normalHisto[(int)i] = sumHisto[(int)i] * ( 1 / (inH*inW)) * 255;  //����ؼ� ���� ������ ������ ���
        // ���� : ����ȭ�� ������׷��� �����ؼ� �ȼ��� ��ȯ
        for(int i=0; i<inH; i++) {
            for(int k=0; k<inW; k++) {   
                outImage[i][k] = (int)(normalHisto[inImage[i][k]]); //�����ȼ����� ������ ���� �ݿø�ó���ؼ� ǥ��
            }
        }       
        break;        
        
}

//(4) ����� ���Ͽ� �����ϱ�
File outFp;
FileOutputStream outFs;
outFp = new File("C:/Out/out_"+filename);
outFs = new FileOutputStream(outFp.getPath());
//�޸� --> ����
for(int i=0; i<outH; i++) {
	for(int k=0; k<outW; k++) {
		outFs.write(outImage[i][k]);
	}
}
outFs.close();
out.println("<h1> ó�� �Ϸ� ! </h1>");
String url = "<p><h1><a href='http://192.168.56.101:8080/";
url += "Bigdata/download.jsp?file=";
url += "out_" + filename + "'>!!!�ٿ�ε�!!!!</a></h1>";

out.println(url);
%>
</body>
</html>