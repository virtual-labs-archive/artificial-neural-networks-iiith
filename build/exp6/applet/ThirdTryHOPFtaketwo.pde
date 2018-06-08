int startX, startY;
int rad =40;
int nUnits = 3;
int drawStartX = 650; 
int drawStartY = 545;
float[][] probOFtr = new float[8][8];
String[] binArr = new String[int(pow(2, nUnits))];
float[] energyArr = new float[int(pow(2, nUnits))];
staTES[] stateARR = new staTES[int(pow(2, nUnits))];
int[] orderSTATES = new int[int(pow(2, nUnits))];
float[][] weightA;
float[] thresholdA;
int[][] cenArr = new int[nUnits][2];
double[][] probTRANS = new double[8][8];
boolean clickFLAG = false;
double clickVALX = 0;
double clickVALY = 0;
double temprature=0.0;
float clickX;
void setup()
{
  size(800, 600);
  cursor(CROSS);
  background(220, 180, 0);
  fill(120);
  rect(0, 75, 800, 550);
  stroke(120);
  rect(600,0,200,75);
  initLZE();
  createBACK();
  setStates();
  callForEnergy();
  determineORDER(stateARR, energyArr, orderSTATES);
  drawENERGYdiagram(stateARR, orderSTATES);
  drawCONNECIONS(probTRANS, stateARR);
  fill(0);
}
void draw()
{
  loop();
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void loop()
{
  createBACK();
  drawENERGYdiagram(stateARR, orderSTATES);
  
  ask(probTRANS);
  
  drawCONNECIONS(probTRANS, stateARR);
  track();
  markIT();
  printPROBmat();
  System.out.println(temprature);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void ask(double[][] probTRANS)
{
  if (temprature==0.0)
  {
    for (int i=0;i<8;i++)
    {
      for (int j=0;j<8;j++)
      {
        probTRANS[i][j] = 0.0;
      }
    }

    probTRANS[0][0] = Round(0.33, 2);
    probTRANS[0][2] = 0.33;
    probTRANS[0][4] = 0.33;
    probTRANS[1][0] = 0.33;
    probTRANS[1][3] = 0.33;
    probTRANS[1][5] = 0.33;
    probTRANS[3][2] = 0.33;
    probTRANS[3][3] = 0.33;
    probTRANS[3][7] = 0.33;
    probTRANS[5][4] = 0.33;
    probTRANS[5][5] = 0.33;
    probTRANS[5][7] = 0.33;
    probTRANS[6][2] = 0.33;
    probTRANS[6][4] = 0.33;
    probTRANS[6][7] = 0.33;
    probTRANS[2][2] = 1.0;
    probTRANS[4][4] = 1.0;
    probTRANS[7][7] = 1.0;
  }
  else
  {
    //System.out.println();
    for (int j1=0;j1<8;j1++)
      {
        for (int j2=0;j2<8;j2++)
      {
        probTRANS[j1][j2] = 0.0;
      }
    }
    
    for (int t=0;t<8;t++)
    {
      String s = binArr[t];
      double[] dTEMP = probFIRE(t,s, temprature);
      for (int i=0;i<8;i++)
      {
        probTRANS[t][i] = RoundA(dTEMP[i], 3);
      }
       }
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//getting a state seq in form of an integer array out of a number 
int[] getArrayOfState(int p)
{
  int[] temp = new int[3];
  String s= binArr[p];
  char[] c1 = s.toCharArray();
  for (int in=0;in<c1.length;in++) { 
    temp[in]=int(c1[in])-48;
  }
  return temp;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FINDING THE PROBABILITY TO FIRE FOR A GIVEN TEMPRATURE
double[] probFIRE(int i1,String s, double temprature)
{
  double[] probARR = new double[4];
  double[] activationArr = new double[3];
  double activation = 0.0;
  double[] power=  new double[binArr.length];

  // NOW WE HAVE THE ACTIVATION VALUES FOR RESPECTIVE NODES, WE'd CALCULATE THE PROBABILITY OF FIRING
  int[] temp = getArrayOfState(i1);
  activationArr = giveActivation(s);
  int stringNUM = i1;
  for (int i=0;i<3;i++)
    {
      probARR[i] = (1/(1+Math.exp(-(activationArr[i]/temprature))));
      probARR[i] = RoundA(probARR[i], 3);
      System.out.print("~~~>"+probARR[i]);
    }
    System.out.println();
    
 // CHECKING TRANSITION PROBABILITIES WITH REST OF THE STATES
    for (int j=0;j<binArr.length;j++)
    {
      boolean cc = false;
      if (hamminDIST(j, stringNUM))
      {
        int order=-1;
        int[] iT = getArrayOfState(j);
        //System.out.println("~~~>"+iT[0]+iT[1]+iT[2]+"<~~~~>"+temp[0]+temp[1]+temp[2]);
        
        if (iT[0]!=temp[0] && iT[1]==temp[1] && iT[2]==temp[2])
        {
          order = 0;
          if (temp[0] == 1) {
            cc = true;
          }
        }
        else if (iT[0]==temp[0] && iT[1]!=temp[1] && iT[2]==temp[2])
        {
          order = 1; 
          if (temp[1] == 1) {
            cc = true;
          }
        }
        else if (iT[0]==temp[0] && iT[1]==temp[1] && iT[2]!=temp[2])
        {
          order = 2;
          if (temp[2] == 1) {
            cc = true;
          }
        }
        else if (iT[0]==temp[0] && iT[1]==temp[1] && iT[2]==temp[2])
        {
          order = 3;
        }
        else
        {
          order = -1;
        }

        if (order>-1 && order<3 && cc==false)
        {
          power[j] = (1-probARR[order])/3;
        }
        else if (order>-1 && order<3 && cc== true)
        {
          power[j] = probARR[order]/3;
        }
        else
        {
          power[j] = 0.0;
        }
      }
      else
      {
        power[j] = 0.0;
      }
    }
  double ssum=0.0;
  for(int o=0;o<8;o+=1)
  {
    ssum = ssum+power[o];
  }
  power[i1] = 1.0-ssum;
  return power;
}
// FOR ROUNDING OFF DOUBLE VALUES
double RoundA(double Rval, int Rpl) {
  double p = (double)Math.pow(10, Rpl);
  Rval = Rval * p;
  double tmp = Math.round(Rval);
  return (double)tmp/p;
}





//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Takes input as string State and return 3 activation values as output corresponding to three nodes

double[] giveActivation(String ss1)
{
  double activation = 0.0;
  double[] arrAct = new double[3];
  int[] temp = new int[3];
  //converting the input state to char array which then converts to int array.. 
  char[] c1 = ss1.toCharArray();
  for (int in=0;in<c1.length;in++) 
  { 
    temp[in]=int(c1[in])-48;
  }
  //calculating the activation by summing the weights multiplied by the states
  for (int out=0;out<3;out++)
  {  
      activation=0.0;
    for (int in=0;in<3;in++)
    {
      activation = activation + weightA[out][in]*temp[in];
    }
    arrAct[out] = activation;
  }
  //subtracting the threshold
  for (int i=0;i<3;i++)
  {
    arrAct[i] = arrAct[i] - thresholdA[i];
  }
  return arrAct;
}











//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void track()
{
  for (int i=0;i<8;i++)
  {
    if (mouseX>stateARR[i].stateCOX && mouseX<stateARR[i].stateCOX+90 && mouseY>stateARR[i].stateCOY && mouseY<stateARR[i].stateCOY+55)
    {
      for (int oc=0;oc<stateARR.length;oc++)
      {
        
        if (probTRANS[i][oc]>0)
        {
                 float f = 10*(energyArr[i]+energyArr[oc]);
        f = f + abs(stateARR[i].stateCOX - stateARR[oc].stateCOX)/5;
          stroke(0,0,200);
        line(stateARR[i].stateCOX, stateARR[i].stateCOY+30, stateARR[oc].stateCOX-30-f, stateARR[i].stateCOY+30);
        line(stateARR[oc].stateCOX-30-f, stateARR[i].stateCOY+30, stateARR[oc].stateCOX-30-f, stateARR[oc].stateCOY+15);
        line(stateARR[oc].stateCOX-30-f, stateARR[oc].stateCOY+15, stateARR[oc].stateCOX, stateARR[oc].stateCOY+15);
          stroke(0, 200, 0);
         
          fill(200, 150, 0);
          rect(stateARR[i].stateCOX, stateARR[i].stateCOY, 90, 55);
          fill(0, 0, 153);
          rect(stateARR[oc].stateCOX, stateARR[oc].stateCOY, 90, 55);
          fill(255);
          textSize(15);
          text(stateARR[i].staTE, stateARR[i].stateCOX+10, stateARR[i].stateCOY+20);
          text(stateARR[oc].staTE, stateARR[oc].stateCOX+10, stateARR[oc].stateCOY+20);
          text("{"+stateARR[oc].enerGY+"}", stateARR[oc].stateCOX+45, stateARR[oc].stateCOY+20);
          text("P=["+RoundB(probTRANS[i][oc], 2)+"]", stateARR[oc].stateCOX+20, stateARR[oc].stateCOY+45);
          text("P=["+RoundB(probTRANS[i][i], 2)+"]", stateARR[i].stateCOX+20, stateARR[i].stateCOY+45);
          text("{"+stateARR[i].enerGY+"}", stateARR[i].stateCOX+45, stateARR[i].stateCOY+20);

          noStroke();
        }
      }
      break;
    }
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public static float RoundB(double Rval, int Rpl) {
  float p = (float)Math.pow(10, Rpl);
  Rval = Rval * p;
  float tmp = Math.round(Rval);
  return (float)tmp/p;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// A ClASS FOR EVERY STATE AND THEIR ENERGY AS WELL AS RESPECTIVE POSITIONS IN ENERGY DIAGRAM
class staTES
{
  String staTE;
  float enerGY;
  int orDER;
  int stateCOX;
  int stateCOY;
}
// SETS THE INTEGER ARRAY binArr WITH BINARY VALUES 
void setStates()
{
  for (int cc=0;cc<int(pow(2,nUnits));cc++)
  {
    String s1 = binary(cc, 3);
    staTES s = new staTES();
    s.staTE = s1;
    binArr[cc] = s1;
    stateARR[cc] = s;
  }
}
// CALCULATES ENERGY FOR EACH STATE INDIVIDUALLY
float calculateENERGY(char[] cA)
{
  float summ=0.0;
  float sumn=0.0;
  float enerGY;
  int[] temp = new int[3]; 
  for (int in=0;in<cA.length;in++) { 
    temp[in]=int(cA[in])-48;
  }
  for (int p=0;p<nUnits;p++)
  {
    for (int q=0;q<nUnits;q++)
    {
      summ = summ + weightA[p][q]*temp[p]*temp[q];
    }
    sumn = sumn+thresholdA[p]*temp[p];
  }
  enerGY = (-0.5*summ)+sumn;
  enerGY = Round(enerGY, 2);
  return(enerGY);
}
// FOR ROUNDING OFF ENERGY VALUES
float Round(float Rval, int Rpl) {
  float p = (float)Math.pow(10, Rpl);
  Rval = Rval * p;
  float tmp = Math.round(Rval);
  return (float)tmp/p;
}
//TAKES VALUES FROM binArr ONE BY ONE AND CALLS FOR ITS ENERGY
void callForEnergy()
{
  for (int cc=0;cc<int(pow(2,nUnits));cc++)
  {
    char[] cA= binArr[cc].toCharArray();
    energyArr[cc] = calculateENERGY(cA);
    stateARR[cc].enerGY = energyArr[cc];
  }
}
//FINDING HAMMING DISTANCE BETWEEN TWO NODES, RETURN TRUE IF DIST IS ONE
boolean hamminDIST(int outC, int inC)
{
  int coun=0;
  char[] c1 = binArr[outC].toCharArray();
  char[] c2 = binArr[inC].toCharArray();
  for (int c=0;c<c1.length;c++)
  {
    if (c1[c]!=c2[c])
    {
      coun++;
    }
  }
  if (coun<2)
  {
    return true;
  }
  else
  {
    return false;
  }
}




//INITIALIZES THE WEIGHT MATRIX AND THRESHOLD VALUES
void initLZE()
{
  weightA = new float[3][3];
  thresholdA = new float[3];

  weightA[0][0] = 0.0;
  weightA[0][1] = -0.5;
  weightA[0][2] = 0.5;
  weightA[1][0] = -0.5;
  weightA[1][1] = 0.0;
  weightA[1][2] = 0.4;
  weightA[2][0] = 0.5;
  weightA[2][1] = 0.4;
  weightA[2][2] = 0.0;
  
  thresholdA[0] = -0.1;
  thresholdA[1] = -0.2;
  thresholdA[2] = 0.7;

  cenArr[0][0] = 50;
  cenArr[0][1] = 330;
  cenArr[1][0] = 250;
  cenArr[1][1] = 330;
  cenArr[2][0] = 150;
  cenArr[2][1] = 200;
}


void createBACK()
{
  fill(20, 20, 20);
  stroke(240, 160, 0);
  for (int h=0;h<nUnits;h++)
  {
    for (int l=0;l<nUnits;l++)
    {
      line(cenArr[h][0], cenArr[h][1], cenArr[l][0], cenArr[l][1]);
    }
  }
  stroke(150, 120, 0);
  for (int h=0;h<nUnits;h++)
  {
    ellipse(cenArr[h][0], cenArr[h][1], rad, rad);
  }
  noStroke();
  stroke(255);

  rect(20, 80, 300, 60);
  fill(240, 180, 30);
  rect(20, 80, 300, 25);
  line(120, 80, 120, 140);
  line(220, 80, 220, 140);


  textSize(15);
  fill(0);
  textSize(15);
  text("W12 = W21", 30, 100);
  text("W23 = W32", 130, 100);
  text("W31 = W13", 230, 100);
  fill(255); 
  text(""+weightA[0][1], 50, 130);
  text(""+weightA[0][2], 150, 130);
  text(""+weightA[2][1], 250, 130);
  textSize(15);
  fill(255);
  for (int l=0;l<nUnits;l++)
  {
    text(l+1, cenArr[l][0]-5, cenArr[l][1]+5);
  }
  fill(152, 0, 53);
  text("Threshold="+thresholdA[0], 10, 365);
  text("Threshold="+thresholdA[0], 11, 365);
  text("Threshold="+thresholdA[1], 230, 365);
  text("Threshold="+thresholdA[1], 231, 365);
  text("Threshold="+thresholdA[2], 110, 175);
  text("Threshold="+thresholdA[2], 111, 175);
  fill(0);
  text("w13", 210, 265);
  text("w13", 211, 265); 
  text("=w31", 210, 285);
  text("=w31", 211, 285);
  text("w12", 55, 265);
  text("w12", 56, 265); 
  text("=w21", 50, 285);
  text("=w21", 51, 285);
  text("w23", 115, 350);
  text("w23", 116, 350); 
  text("=w32", 155, 350);
  text("=w32", 156, 350);
  fill(0);
  textSize(16);
  text("ADJUST TEMPRATURE", 30, 15);
  tempBAR(10, 20);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void tempBAR(int x, int y)
{
  stroke(155, 0, 0);
  fill(255);
  rect(x, y, 550, 50);
  noStroke();
  fill(230, 230, 0);
  rect(x+5, y+25, 540, 20);
  fill(0);
  stroke(0);
  textSize(15);
  for (int i=0;i<11;i=i+1)
  {
    line(x+17+50*i, y+22, x+17+50*i, y+42);
    if (i<10)
    {
      text("0.", x+5+50*i, y+18);
      text(i, x+20+50*i, y+18);
    }
  }
  text("1.0", x+510, y+18);
  noStroke();
}

void determineORDER(staTES[] stateARRR, float[] energyArrR, int[] orderSTATEStemp)
{
  // TO SORT THE ENERGY ARRAY
  float[] mirrorArr = new float[int(pow(2, nUnits))];
  mirrorArr=energyArrR;
  Arrays.sort(mirrorArr);
  for (int i=0;i<int(pow(2, nUnits));i++)
  {
    int count = 0;
    for (int j=0;j<int(pow(2, nUnits));j++)
    {
      if (stateARRR[j].enerGY==mirrorArr[i])
      {
        stateARRR[j].orDER = i;
        count++;
        if (count==2)
        {
          i++;
        }
      }
    }
  }
  for (int t=0;t<8;t++)
  {
    orderSTATEStemp[t] = stateARRR[t].orDER;
  }
}

void drawENERGYdiagram(staTES[] stateARRR, int[] orderSTATESS)
{
  //stateARR  orderSTATES
  boolean f = false;
  int count=1;
  for (int i=0;i<orderSTATESS.length;i++)
  {
    int drawStartXX = drawStartX;  
    String s = stateARRR[i].staTE;
    int in = stateARRR[i].orDER; 
    for (int y=0;y<orderSTATESS.length;y++)
    {
      if (y!=i && in == stateARRR[y].orDER)
      {
        count++;
        f = true;
      }
    }     
    if (i>=0 && f == true)
    {
      if (count>2) {
        count=1;
      }
      drawStartXX = drawStartXX + 150*(count-2);
      fill(50);
      rect(drawStartXX, drawStartY-(70*in), 90, 55);
      fill(255);
      textSize(15);
      text(s, drawStartXX+10, (drawStartY-(70*in))+20);
      text(s, drawStartXX+11, (drawStartY-(70*in))+20);
      text("{"+stateARRR[i].enerGY+"}", drawStartXX+44, (drawStartY-(70*in))+20);
      text("{"+stateARRR[i].enerGY+"}", drawStartXX+45, (drawStartY-(70*in))+20);
      f= false;
      stateARRR[i].stateCOX = drawStartXX;
      stateARRR[i].stateCOY = drawStartY-(70*in);
      drawStartXX = drawStartX;
    }
    else 
    {
      fill(50);
      rect(drawStartXX, drawStartY-(70*in), 90, 55);
      fill(255);
      textSize(15);
      text(s, drawStartXX+10, (drawStartY-(70*in))+20);
      text(s, drawStartXX+11, (drawStartY-(70*in))+20);
      text("{"+stateARRR[i].enerGY+"}", drawStartXX+44, (drawStartY-(70*in))+20);
      text("{"+stateARRR[i].enerGY+"}", drawStartXX+45, (drawStartY-(70*in))+20);
      stateARRR[i].stateCOX = drawStartXX;
      stateARRR[i].stateCOY = drawStartY-(70*in);
      f = false;
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Draws Lines Betweeen Energy States Showing Possible Transitions
void drawCONNECIONS(double[][] probOFtrTEMPP, staTES[] TEMPstatesARR)
{
  for (int outC=0;outC<8;outC++)
  {
    for (int inC=0;inC<8;inC++)
    {
      if (probOFtrTEMPP[outC][inC]>0)
      {
        float f = 10*(energyArr[outC]+energyArr[inC]);
        f = f + abs(TEMPstatesARR[outC].stateCOX - TEMPstatesARR[inC].stateCOX)/5;
        stroke(0, 200, 0);
        line(TEMPstatesARR[outC].stateCOX, TEMPstatesARR[outC].stateCOY+30, TEMPstatesARR[inC].stateCOX-30-f, TEMPstatesARR[outC].stateCOY+30);
        line(TEMPstatesARR[inC].stateCOX-30-f, TEMPstatesARR[outC].stateCOY+30, TEMPstatesARR[inC].stateCOX-30-f, TEMPstatesARR[inC].stateCOY+15);
        line(TEMPstatesARR[inC].stateCOX-30-f, TEMPstatesARR[inC].stateCOY+15, TEMPstatesARR[inC].stateCOX, TEMPstatesARR[inC].stateCOY+15);
        fill(0);
        triangle(TEMPstatesARR[inC].stateCOX, TEMPstatesARR[inC].stateCOY+15, TEMPstatesARR[inC].stateCOX-10, TEMPstatesARR[inC].stateCOY, TEMPstatesARR[inC].stateCOX-10, TEMPstatesARR[inC].stateCOY+30);
        noFill();
        noStroke();
      }
    }
  }
}

void mouseClicked()
{
  for (int i=0;i<11;i++)
  {//rect(10,20,550,50);
    if (mouseX>10 && mouseX<529 && mouseY>20 && mouseY<70)
    {
      if (mouseButton==LEFT)
      {
        clickFLAG  = true; 
        clickVALX = float(mouseX);
        clickVALY = float(mouseY);
        double p = clickVALX - 27.0;
        temprature = p/500;
        fill(0,255);
        rect(130, 375, 150, 30);
        fill(240, 180, 20);
        textSize(18);
        text("TEMP := "+temprature, 140, 395);
        text("TEMP := "+temprature, 141, 395);
         clickX = mouseX;       
        markIT();
      }
      break;
    }
  }
  
}
void markIT()
{
if(clickFLAG==true)
{
stroke(255,0,0);
line(clickX,45,clickX,65);
fill(255);
ellipse(clickX,55,10,10);
noStroke();
}
}


void printPROBmat()
{
 /// FOR PRINTING THE PROBABILITY MATRIX
fill(0,255);
rect(10,410,385,205); 
fill(240, 180, 20);
//for(int i=0;i<8;i+=1)  {    for(int j=0;j<8;j+=1)    {      //line();    }   }
//  fill(240, 180, 20);
  stroke(40, 20, 220);
  for(int i=0;i<8;i+=1)  
  {
    line(75+40*i,415,75+40*i,593);
  }
  for(int i=0;i<9;i+=1)  
  {
    line(20,430+20*i,385,430+20*i);
  }
  noStroke();
  fill(240,180,20);
  for(int i=0;i<8;i+=1)  
  {
    textSize(14);
   text(binArr[i],35,445+20*i);
   
    for(int j=0;j<8;j+=1)  
  {
   textSize(14);
   text(binArr[j],85+40*j,425);
  double d11 = RoundA(probTRANS[i][j],2);

   text(""+d11,80+40*j,445+20*i); 

  }
   
}
}
