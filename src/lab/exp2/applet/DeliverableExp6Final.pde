
int tempCount=0;
float[] tempVAL = new float[20];
int co =0;
int negCount = 0;
int fmatCount = 0;
int yCR= 100;
float[][] FMAT= new float[20][8];
float[] pMatrix = new float[8];
float tStart = 1.0;
float tTemp;
boolean check = false;
int startX, startY;
int rad =40;
int nUnits = 3;
int drawStartX = 700; //650; 
int drawStartY = 540;
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
double clickVALX = 27;
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
  rect(600, 0, 200, 75);
  initLZE();
  createBACK();
  setStates();
  callForEnergy();
  determineORDER(stateARR, energyArr, orderSTATES);
  drawENERGYdiagram(stateARR, orderSTATES);
  drawCONNECIONS(probTRANS, stateARR);
  fill(0);
  tTemp = 1.0;
}
void draw()
{
  loop();
  annealPART();
  if (check==true)
  {
    makeClickedRect(yCR);
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void loop()
{
  fill(120);
  rect(0, 0, 800, 600);
  createBACK();
  drawENERGYdiagram(stateARR, orderSTATES);

  ask(probTRANS);

  drawCONNECIONS(probTRANS, stateARR);
  track();
  markIT();
  printPROBmat();
  showTempInOne((float)clickVALX, (float)clickVALY);
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
      double[] dTEMP = probFIRE(t, s, temprature);
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
double[] probFIRE(int i1, String s, double temprature)
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
    //      System.out.print("~~~>"+probARR[i]);
  }
  //  System.out.println();

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
  for (int o=0;o<8;o+=1)
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
          stroke(0, 0, 200);
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
      line(cenArr[h][0], cenArr[h][1]-10, cenArr[l][0], cenArr[l][1]-10);
    }
  }
  stroke(150, 120, 0);
  for (int h=0;h<nUnits;h++)
  {
    ellipse(cenArr[h][0], cenArr[h][1]-10, rad, rad);
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
    text(l+1, cenArr[l][0]-5, cenArr[l][1]-5);
  }
  //  fill(0);
  fill(252, 230, 0);
  text("Threshold="+thresholdA[0], 10, 355);
  //  text("Threshold="+thresholdA[0], 11, 365);
  text("Threshold="+thresholdA[1], 230, 355);
  //  text("Threshold="+thresholdA[1], 231, 365);
  text("Threshold="+thresholdA[2], 110, 165);
  //  text("Threshold="+thresholdA[2], 111, 175);
  fill(0);
  textSize(16);
  text("w13", 210, 255);
  //  text("w13", 211, 265); 
  text("=w31", 210, 275);
  //  text("=w31", 211, 285);
  text("w12", 55, 255);
  //  text("w12", 56, 265); 
  text("=w21", 50, 275);
  //  text("=w21", 51, 285);
  text("w23", 115, 310);
  //  text("w23", 116, 350); 
  text("=w32", 155, 310);
  //  text("=w32", 156, 350);
  fill(0);
  textSize(16);
  text("ADJUST TEMPERATURE", 30, 15);
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
// This part shows the temprature value when clicked .. 
void showTempInOne(float clickVALX, float clickVALY)
{
  if (clickFLAG = true)
  {
   double p = clickVALX - 27.0;
    temprature = p/500;
    fill(0, 255);
    rect(330, 75, 150, 30);
    fill(240, 180, 20);
    textSize(18);
    text("TEMP := "+temprature, 340, 95);
    text("TEMP := "+temprature, 341, 95);
  }
}

void mouseClicked()
{
  for (int i=0;i<11;i++)
  {
    if (mouseX>10 && mouseX<529 && mouseY>20 && mouseY<70)
    {
      if (mouseButton==LEFT)
      {
        clickFLAG  = true; 
        clickVALX = float(mouseX);
        clickVALY = float(mouseY);
        clickX = mouseX;       
        markIT();
      }
      break;
    }
  }
  if (mouseX>45 && mouseX<290+45 && mouseY>565 && mouseY<585)
  {
    check = true;
    tStart = 1.0;
  }
  if (check == true)
  {
    if (mouseX>30 && mouseX<45 && mouseY>100 && mouseY<300)
    {
      float t1 = mouseY;
      t1 = t1 - 100.0;
      tTemp = Round(t1/200, 2);
      tTemp = 1-tTemp;
      makeClickedRect(mouseY);
      fmatCount+=1;
              tempCount+=1;
        if(tTemp<0.05)
        {
           tempVAL[tempCount] = 0.00;
        }
        else{
        tempVAL[tempCount] = Round(tTemp, 2);
        }
      if (tTemp>tStart)
      {
        negCount+=1;
      }
      else
      {
        if (negCount>0)
        {
          negCount-=1;
        }
      }
    }
    if (mouseX>70 && mouseX<170 && mouseY>380 && mouseY<410)
    { 
      tTemp=1.0;
      yCR=100;
      check = false;
      fmatCount=0;
      for (int i=0;i<20;i++)
      {
        for (int j=0;j<8;j++)
        {
          FMAT[i][j]=0.0;
        }
      }
      tempCount=0;
      for (int i=0;i<10;i+=1)
      {
        tempVAL[i]=0.0;
      }
    }
  }
}
void markIT()
{
  if (clickFLAG==true)
  {
    stroke(255, 0, 0);
    line((float)clickVALX, 45, (float)clickVALX, 65);
    fill(255);
    ellipse((float)clickVALX, 55, 10, 10);
    noStroke();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void printPROBmat()
{
  /// FOR PRINTING THE PROBABILITY MATRIX
  fill(0, 255);
  rect(10, 370, 385, 185); 
  fill(240, 180, 20);
  stroke(40, 20, 220);
  for (int i=0;i<8;i+=1)  
  {
    line(75+40*i, 375, 75+40*i, 553);
  }
  for (int i=0;i<9;i+=1)  
  {
    line(20, 390+20*i, 385, 390+20*i);
  }
  noStroke();
  fill(240, 180, 20);
  for (int i=0;i<8;i+=1)  
  {
    fill(250, 180, 180);
    textSize(14);
    text(binArr[i], 35, 405+20*i);

    for (int j=0;j<8;j+=1)  
    {
      fill(250, 180, 180);
      textSize(13);
      text(binArr[j], 85+40*j, 385);
      double d11 = RoundA(probTRANS[i][j], 2);

      text(""+d11, 80+40*j, 405+20*i);
    }
  }
  fill(0);
  rect(40, 560, 300, 30);
  stroke(255);
  rect(45, 565, 290, 20);
  noStroke();
  textSize(14);

  fill(160, 240, 0);
  text("Click Here To View The Annealing Schedule", 50, 580);
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This part deals with the window of annealing
void annealPART()
{
  for (int i=0;i<8;i+=1)
  {
    //    pMatrix[0][i] = 0.125;
    pMatrix[i] = 0.125;
  }  
  String[] tableVal;
  if (check)
  {
    float[][] tempTableProb = new float[44][10];
    makeClickedRect(yCR);
    fill(120);
    rect(0, 0, 800, 600);
    PImage im1, im2;
    //Now first settle about the equations display 
    im1 = loadImage("eqn1.jpg");
    im2 = loadImage("eqn2.jpg");
    image(im1, 10, 420, 340, 50);
    image(im2, 10, 480, 180, 45);    
    // load the probability matrix from the table in strings ..
    String[] s = loadStrings("annealTAB.txt");
    String delim = "[ ]";
    for (int i=0;i<s.length-1;i+=1)
    {
      String[] tokens = s[i].split(delim);
      for (int ji=0;ji<tokens.length;ji+=1)
      {
        tempTableProb[i][ji] = float(tokens[ji]);
      }
    }
    tempVAL[0] = 1.0;  
    textSize(13);
    fill(0);
    text("Click on the temperatures to start annealing", 20, 40);
    text("Click on the temperatures to start annealing", 21, 40);
    fill(0);
    rect(70, 380, 100, 30);
    stroke(255);
    rect(75, 385, 90, 20);
    noStroke();
    textSize(16);
    fill(0);
    text("To Go Back To The Previous Screen", 35, 370);
    fill(255);
    text("CLICK", 100, 402);

    //    
    fill(0);
    // header and footer black rects
    rect(25, 91, 25, 10);
    rect(25, 300, 25, 10);   
    fill(230, 130, 0);
    stroke(0);
    //    rect for temp bar 
    rect(30, 100, 15, 200);  
    noStroke();
    fill(0);
    for (int i =0;i<20;i+=1)
    {  
      stroke(0);
      line(30, 100+10*i, 45, 100+10*i);
      noStroke();
    }
    if (tTemp<0.05)
    {
      tTemp = 0.0;
    }
    fill(0);
    text("Click on the bar to lower temperature", 20, 330);
    text("Click on the bar to lower temperature", 21, 330);    
    text("Temperature = "+Round(tTemp, 2), 70, 200);  
    textSize(14);
    text("Due to increased number of anealing steps,", 21, 60);  
    text("Due to increased number of anealing steps,", 20, 60);      
    text("Some steps have been skipped while display", 21, 75);  
    text("Some steps have been skipped while display", 20, 75);      
    if (tTemp<=tStart)
    {
      tStart = tTemp;
      annealNW(Round(tTemp, 3));
    }
    else
    {
      fill(200, 0, 0);
      float t21 = 200*(1-tStart);
      rect(20, t21+100, 40, 3);
      noFill();
      fill(0, 0, 0);
      textSize(15);
      text("Please enter a lower temprature than "+Round(tStart, 3), 60, 130);
      text("to anneal the network", 100, 140);
      noStroke();
    }
  }
}

void makeClickedRect(int y)
{
  stroke(0);
  fill(0);
  yCR = y;
  rect(30, y-5, 15, 10);
  noStroke();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// this part will anneal and then display will be taken care of
void annealNW(float temP)
{
  //********************************************


  //creating the display for annealing values of probability GUI
  //  countPM
  rect(375, 30, 410, 40);
  fill(240, 200, 0);
  rect(380, 35, 400, 30);
  for (int i=0;i<8;i+=1)
  {
    fill(0);
    stroke(0);
    line(380+50*(i+1), 35, 380+50*(i+1), 65);
    text(binArr[i], 390+50*i, 60);
    text(binArr[i], 391+50*i, 60);    
    noStroke();
  }
  //********************************************

  // creating matrix for displaying annealed values 
  int count = 0;
  float[][] tt1 = new float[26][8];
  float[] diff = new float[8];

  //load the current row from State prob matrix in temp matrix
  for (int yi=0;yi<8;yi+=1) 
  {
    tt1[count][yi] = pMatrix[yi];
  }
  // created the probability matrix
  double[][] tempPmat= new double[8][8];
  for (int y=0;y<8;y+=1) 
  {
    String s = binArr[y];
    double[] dTEMP = probFIRE(y, s, temP);
    for (int i=0;i<8;i+=1)
    {
      tempPmat[y][i] = RoundA(dTEMP[i], 3);
    }
  }
  // Taking transpose of the tempPmat
  float[][] trPmat = new float[8][8];
  for (int g =0;g<8;g+=1)
  {
    for (int i=0;i<8;i+=1)
    {
      trPmat[i][g] = (float)tempPmat[g][i];
    }
  }
  //********************************************
  ///////////////////////////////////////////////
  do
  {  
    double[] ty = new double[8];
    for (int i=0;i<8;i+=1)
    {
      float sum = 0.0;
      for (int j=0;j<8;j+=1)
      {
        ty[j] = RoundA(trPmat[i][j], 3);
        double db = tt1[count][j]*ty[j];
        sum = sum+(float)db;
      }

      pMatrix[i] = Round(sum, 3);   
      tt1[count+1][i] = Round(sum, 3);
    }
    count+=1;
    if (count==24)
    {
      for (int yy=0;yy<8;yy+=1)
      {
        pMatrix[yy] = tt1[count-1][yy];
      }
      break;
    }
    for (int u=0;u<8;u+=1)
    {
      diff[u] = Round(tt1[count][u] - tt1[count-1][u], 3);
    }
  }
  while (diff[0]>0.001 || diff[1]>0.001 || diff[2]>0.001 || diff[3]>0.001 || diff[4]>0.001 || diff[5]>0.001 || diff[6]>0.001 || diff[7]>0.001);
  //this is entering the value into prob matrix..
  for (int h =0;h<8;h+=1)
  {
    FMAT[fmatCount][h] = pMatrix[h];
  }

  for (int i=0;i<8;i+=1)
  {
    pMatrix[i] = tt1[count][i];
  }
  // this is for the display of annealing probabilty schedule ...
  int x = 380;
  int y = 110;
  int y1 = y;
  for (int g=0;g<8;g+=1)
  {
    text("0.125", x+5+50*g, y-15);
    text("0.125", x+6+50*g, y-15);
  }
  for (int i=0;i<20;i+=1)
  {
    for (int j=0;j<8;j+=1)
    {
      if (FMAT[i][0]==0.0 && FMAT[i][1]==0.0 && FMAT[i][0]==0.0 && FMAT[i][2]==0.0 && FMAT[i][3]==0.0 && FMAT[i][4]==0.0 && FMAT[i][5]==0.0)
      {
        if (co>2)
        {
          break;
        }
        else
        {
          i+=1;
          co+=1;
        }
      }
      //This prints the probability values for previous temparature 
      text(FMAT[i][j], x+50*j, y1+3);  
      text(FMAT[i][j], x+50*j+1, y1+3);
    }
    
          //This prints the temprature values used in annealing
      textSize(15);
      text("TEMP", x-45, y-40);
      for(int j=0;j<20;j++)
      {
      if (tempVAL[j]!=0)
      {
        text(tempVAL[j], x-45, (y+3)+(20*j));
        stroke(200, 0, 200);
        //a line after every temp value of anneal
        line(x-45, (y+5)+(20*j), x, (y+5)+(20*j));
        noStroke();
      }
      }
    //putting a line after every row in prob matrix...
    y1=y1+20;
    stroke(0);
    line(380, y1-15, 780, y1-15);
    noStroke();
  }
  y = y+20*(fmatCount+1);

// now after printing temp, time to print previous prob
  for (int out=1;out<21-fmatCount;out+=1)
  {
    for (int in=0;in<8;in+=1)
    {
      textSize(16);
      fill(0, 260, 155);
      if (tt1[out][0]==0.0 && tt1[out][1]==0.0 && tt1[out][0]==0.0 && tt1[out][2]==0.0 && tt1[out][3]==0.0 && tt1[out][4]==0.0 && tt1[out][5]==0.0)
      {
        break;
      }
      text(tt1[out][in], x+50*in, y);
    } 
    y = y+20;
    stroke(0);
    line(330+50*(out+1), 75, 330+50*(out+1), 520);
    line(331+50*(out+1), 75, 331+50*(out+1), 520);    
    line(380, 520, 780, 520);
    line(380, 521, 780, 521);    
    line(380, 100, 780, 100);
    line(380, 99, 780, 99);    
    line(380, 69, 380, 520);    
    line(381, 69, 381, 520);        
    noStroke();
  }
}

