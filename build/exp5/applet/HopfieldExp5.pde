boolean[] mark = new boolean[6];
float[] valA = new float[6];
int nUnits=3;
int pivotX, pivotY;
staTES[] stateARR = new staTES[int(pow(2, nUnits))];
String[] binArr = new String[int(pow(2, nUnits))];
boolean stageONE = false;
boolean errorCHIOCE = false;
boolean stageTWOshow = false;
int clickCount = 0;
String[] sA = new String[2];
String[] ss1= new String[6];
int[] Arr1 = new int[6];
boolean secondTRACK = false;
boolean stageTHREEshow = false;
float[] tWeight = new float[3];
float[] tThreshold = new float[3];
float[][] weightA = new float[3][3];
float[] thresholdA= new float[3];
float[][] probOFtr = new float[8][8];
float[] energyArr = new float[int(pow(2, nUnits))];
int[] orderSTATES = new int[int(pow(2, nUnits))];
int drawStartX = 600; 
int drawStartY = 485;


/////////////////////////////////////////////////////////////////////////////////////////
void createDIAG()
{
  fill(0, 0, 200);
  stroke(250, 240, 0);
  line(380, 380, 300, 480);
  line(380, 380, 460, 480);
  line(460, 480, 300, 480);
  stroke(150, 120, 0);
  ellipse(380, 380, 30, 30);
  ellipse(300, 480, 30, 30);
  ellipse(460, 480, 30, 30);
  noStroke();
  textSize(16);
  fill(255);
  text("1", 375, 385);
  text("2", 295, 485);
  text("3", 455, 485);
  noFill();
  textSize(14);
  fill(152, 0, 53);
  text("Threshold1", 335, 360);
  text("Threshold2", 256, 515);
  text("Threshold3", 420, 515);
  text("w13", 410, 410);
  text("=w31", 425, 425);
  text("w12", 315, 425);
  text("=w21", 285, 445);
  text("w23", 340, 475);
  text("=w23", 370, 475);
  noStroke();
}
/////////////////////////////////////////////////////////////////////////////////////////
void setup()
{
  pivotX = 10;
  pivotY = 60;
  setStates();
  drawOPTIONS();
  for (int g=0;g<6;g++)
  {
    mark[g] = false;
  }
}
/////////////////////////////////////////////////////////////////////////////////////////
void draw()
{
  loop();
}
/////////////////////////////////////////////////////////////////////////////////////////
void loop()
{
  drawOPTIONS();
}
/////////////////////////////////////////////////////////////////////////////////////////
void drawOPTIONS()
{
  drawRECTS();
  trackMOVEMENT();

  if (errorCHIOCE==true)
  {
    fill(0, 0, 255);
    textSize(16);
    text("< WRONG CHOICE::PRESS BUTTON TO ENTER AGAIN >", 170, 150);
    noFill();  
    fill(50);
    rect(620, 130, 70, 25);
    fill(0);
    rect(623, 133, 64, 19);
    textSize(16);
    fill(255);
    text("CLICK", 630, 147);

    clickCount = 0;
    stageONE = false;
    for (int i=0;i<8;i=i+1)
    {
      stateARR[i].selected = false;
    }
  }

  if (stageTWOshow==true && stageTHREEshow == false)
  {
    fill(0);
    textSize(16);
    text("HINT-->> W12 = 0.5; W23 = 0.6; W31 = -0.5; Th1 = 0.4; Th2 = -0.6; Th3 = 0.5", 15, 15);
    text("HINT-->> W12 = 0.5; W23 = 0.6; W31 = -0.5; Th1 = 0.4; Th2 = -0.6; Th3 = 0.5", 16, 15);
    textSize(18);
    text("ADJUST THE WEIGHTS AND THRESHOLDS FOR THE NEW 'STD'", 130, 230); 
    noFill();
    getStrings(sA[0], sA[1]);
    printEQUATIONS();
  }
  if (stageTWOshow == true && stageTHREEshow == false)
  {
    for (int jj=0;jj<6;jj++)
    {
      fill(0);
      text(valA[jj], 600, 285+40*jj);
      rect(350+(200*valA[jj]), 270+40*jj, 20, 10);
    }
    rect(670, 505, 100, 30);
    fill(200, 200, 0);
    rect(680, 510, 80, 20);
    fill(0);
    textSize(18);
    text("DONE", 697, 527);
    rect(20, 505, 100, 30);
    fill(200, 200, 0);
    rect(30, 510, 80, 20);
    fill(0);
    textSize(18);
    text("BACK", 47, 527);
  }
  if (stageTWOshow == false && stageTHREEshow == false)
  {
    fill(0);
    textSize(16);
    text("HINT-->> CLICK ON '011' AND '110' TO BE REPRESENTED AS STABLE STATES", 20, 23);
    text("HINT-->> CLICK ON '011' AND '110' TO BE REPRESENTED AS STABLE STATES", 21, 23);  
    textSize(14);
    fill(0);
    textSize(16);
    //text("THIS IS THE SECOND PART OF THE EXPERIMENT", 170, 180);
    //text("MOVE THE MOUSE OVER THE STATES",240,180);
    text("CLICK OVER THE STATES TO CHOOSE THEM AS MINIMUM ENERGY STATES", 110, 210);
    text("YOU CAN CHOOSE AT MOST TWO STATES AS MINIMUM", 180, 240); 
    text("MAKE SURE THEY ARE SEPARATED BY MORE THAN ONE HAMMING DISTANCE", 100, 270);
    createDIAG();
  }
  else if (stageTHREEshow == true)
  {
    size(800, 550);
    cursor(CROSS);
    background(120);
    //background(220, 180, 0);
    fill(170);
    rect(0, 30, 800, 510);



    fill(200, 200, 0);
    rect(40, 380, 150, 35);
    rect(40, 450, 150, 35);
    fill(120);
    //fill(0, 200, 0);
    rect(43, 382, 144, 30);
    rect(43, 452, 144, 30);
    fill(0);
    textSize(14);
    text("Adjust Weights", 60, 400);
    text("Choose States", 60, 470);
    textSize(14);
    text("Return to select different Weight values", 15, 435);
    text("Return to choose different states", 15, 510);

    boolean flaggs = checkINEQ();
    if (flaggs)
    {
      newEnergyDiagram();
    }
    else
    {
      drawDIAG();
      textSize(20);
      text("INEQUALITIES DO NOT SATISFY", 400, 300);
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////
void drawRECTS()
{
  size(800, 550);
  cursor(CROSS);
  background(120);
  //background(220, 180, 0);
  stroke(150, 120, 0);
  fill(170);
  rect(0, 30, 800, 510);
  int tempX = pivotX;
  int tempY = pivotY; 
  for (int i=0;i<8;i=i+1)
  {
    if (stateARR[i].selected==false)
    {
      fill(120);
    }
    else
    {
      fill(0, 0, 190);
    }

    rect(tempX+100*i, tempY, 75, 50);
    char[] cTEMP = binArr[i].toCharArray();
    if (stateARR[i].selected==false)
    {
      fill(0);
    }
    else
    {
      fill(255);
    }

    textSize(14);
    text(cTEMP[0], tempX+100*i+35, tempY+15);
    text(cTEMP[1], tempX+100*i+10, tempY+30);
    text(cTEMP[2], tempX+100*i+60, tempY+30);
    noFill();
  }
  if (stageONE == false)
  {
    fill(0);
    rect(320, 295, 100, 30);
    fill(200, 200, 0);
    rect(330, 300, 80, 20);
    fill(0);
    textSize(18);
    text("SUBMIT", 337, 317);
    textSize(14);
  }
}
/////////////////////////////////////////////////////////////////////////////////////////
void trackMOVEMENT()
{
  if (stageTWOshow == false && stageTHREEshow == false)
  {
    for (int i=0;i<8;i=i+1)
    {
      if (mouseY -pivotY>0 && mouseY-pivotY<50 && mouseX-(pivotX+100*i)>0 && mouseX-(pivotX+100*i)<75)
      {
        fill(0, 0, 200);
        rect(pivotX+100*i, pivotY, 75, 50);
        char[] cTEMP = binArr[i].toCharArray();
        fill(255);
        text(cTEMP[0], pivotX+100*i+35, pivotY+15);
        text(cTEMP[1], pivotX+100*i+10, pivotY+30);
        text(cTEMP[2], pivotX+100*i+60, pivotY+30);
        noFill();
      }
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////////////
// A ClASS FOR EVERY STATE AND THEIR ENERGY AS WELL AS RESPECTIVE POSITIONS IN ENERGY DIAGRAM
class staTES
{
  String staTE;
  float enerGY;
  int orDER;
  int stateCOX;
  int stateCOY;
  boolean selected;
  boolean printed = false;
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
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void showStageTWO()
{
  int count=0;
  for (int i=0;i<8;i=i+1)
  {
    if (stateARR[i].selected == true)
    {
      sA[count] = stateARR[i].staTE;
      count=count+1;
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////
void mouseClicked()
{
  if (errorCHIOCE==true)
  {
    if (mouseX>620 && mouseX<690 && mouseY>120 && mouseY<155)
    {
      errorCHIOCE = false;
      stageONE = false;
      for (int i =0;i<8;i++)
      {
        if (i<6)
        {
          valA[i]=0;
        }
        stateARR[i].selected = false;
      }
    }
  }
  if (stageONE==false)
  {
    for (int i=0;i<8;i=i+1)
    {
      if (mouseButton == LEFT && mouseY -pivotY>0 && mouseY-pivotY<50 && mouseX-(pivotX+100*i)>0 && mouseX-(pivotX+100*i)<75)
      {
        stateARR[i].selected = true;
      }
    }
    if (mouseX>320 && mouseX<420 && mouseY>295 && mouseY<325)
    {
      stageONE = true;
      validateIPUT();
      for (int i=0;i<6;i=i+1)
      {
        valA[i] = 0;
      }
    }
  }
  if (secondTRACK == true && stageTHREEshow == false)
  {
    for (int i=0;i<6;i=i+1)
    {
      if (mouseY>270+40*i && mouseY < 280+40*i)
      {
        for (int j=0;j<22;j++)
        {
          if (mouseX<150+20*j)
          {
            reTAIN(i, j); 
            break;
          }
        }
      }
    }
  }
  if (secondTRACK == true && stageTHREEshow == false)
  {
    if (mouseX>680 && mouseX<760 && mouseY>510 && mouseY<530)
    {
      stageTHREEshow = true;
    }
    else if (mouseX>20 && mouseX<120 && mouseY>510 && mouseY<530)
    {
      errorCHIOCE = false;
      stageTWOshow = false;
      stageONE = false;
      clearALL();
    }
  }
  if (stageTHREEshow==true)
  {
    if (mouseX>40 && mouseX<190)
    {
      if (mouseY>380 && mouseY<415)
      {
        stageTHREEshow = false;
        stageTWOshow = true;
        for (int i=0;i<6;i=i+1)
        {
          valA[i] = 0;
        }
      }
      else if (mouseY>450 && mouseY<485)
      {
        stageONE = false;
        stageTHREEshow = false;
        stageTWOshow = false;  
        for (int i=0;i<8;i=i+1)
        {
          stateARR[i].selected = false;
        }
      }
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////
void clearALL()
{
  clickCount = 0;
  for (int k=0;k<8;k=k+1)
  {
    stateARR[k].selected = false;
  }
}
/////////////////////////////////////////////////////////////////////////////////////////
void keyPressed()
{
  if (key=='A' || key=='a')
  {
    errorCHIOCE = false;
    for (int i=0;i<8;i=i+1)
    {
      stateARR[i].selected = false;
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////
void validateIPUT()
{
  int[] iT = new int[2];
  for (int i=0;i<8;i=i+1)
  {
    if (stateARR[i].selected==true)
    {

      clickCount=clickCount+1;
    }
  }
  if (clickCount!=2)
  {
    errorCHIOCE = true;
  }
  else
  {
    int ct = 0;
    for (int i=0;i<8;i=i+1)
    {
      if (stateARR[i].selected==true)
      {

        iT[ct]=i;
        ct=ct+1;
      }
    }
    if (hamminDIST(iT[0], iT[1]))
    {
      errorCHIOCE = true;
    }
    else
    {
      errorCHIOCE = false;
      stageTWOshow = true;
      showStageTWO();
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////
// GET THE CHARACTERS AND SEND TO MAKE EQUATIONS
void getStrings(String s1, String s2)
{
  int tp =0;
  char[] c1 = s1.toCharArray();
  char[] c2 = s2.toCharArray();
  for (int i=0;i<3;i++)
  {
    Arr1[i] = int(c1[i])-48;
    tp++;
  }
  for (int i=0;i<3;i++) {   
    Arr1[tp] = int(c2[i])-48;
    tp++;
  }
  stringSHOW(Arr1);
}
// PRINT THE INEQUALITIES 
void stringSHOW(int[] aA)
{
  String te1, te2, te3;
  te1 = "";
  te2 = "";
  te3 = "";
  //  ss1[0] = "W12*("+aA[1]+")+W13*("+aA[2]+")-th1";
  //  ss1[1] = "W21*("+aA[0]+")+W23*("+aA[2]+")-th2";  
  //  ss1[2] = "W31*("+aA[0]+")+W32*("+aA[1]+")-th3";    
  //  ss1[3] = "W12*("+aA[4]+")+W13*("+aA[5]+")-th1";
  //  ss1[4] = "W21*("+aA[3]+")+W23*("+aA[5]+")-th2";  
  //  ss1[5] = "W31*("+aA[3]+")+W32*("+aA[4]+")-th3";  

  ss1[0] = "W12*("+aA[1]+")+W13*("+aA[2]+")";
  ss1[1] = "W21*("+aA[0]+")+W23*("+aA[2]+")";  
  ss1[2] = "W31*("+aA[0]+")+W32*("+aA[1]+")";    
  ss1[3] = "W12*("+aA[4]+")+W13*("+aA[5]+")";
  ss1[4] = "W21*("+aA[3]+")+W23*("+aA[5]+")";  
  ss1[5] = "W31*("+aA[3]+")+W32*("+aA[4]+")";  

  if (aA[0]!=0)
  {
    te1 = ">th1";
  }
  if (aA[0]==0)
  {
    te1 = "<=th1";
  }
  if (aA[1]!=0)
  {
    te2 = ">th2";
  }
  if (aA[1]==0)
  {
    te2 = "<=th2";
  }
  if (aA[2]!=0)
  {
    te3 = ">th3";
  }
  if (aA[2]==0)
  {
    te3 = "<=th3";
  }
  ss1[0] = ss1[0].concat(te1);
  ss1[1] = ss1[1].concat(te2);
  ss1[2] = ss1[2].concat(te3);
  if (aA[3]!=0)
  {
    te1 = ">th1";
  }
  else if (aA[3]==0)
  {
    te1 = "<=th1";
  }
  if (aA[4]!=0) 
  {
    te2 = ">th2";
  }
  else if (aA[4]==0)
  {
    te2 = "<=th2";
  }
  if (aA[5]!=0)
  {
    te3 = ">th3";
  }
  else if (aA[5]==0)
  {
    te3 = "<=th3";
  }
  ss1[3] = ss1[3].concat(te1);
  ss1[4] = ss1[4].concat(te2);
  ss1[5] = ss1[5].concat(te3);
}
/////////////////////////////////////////////////////////////////////////////////////////
/////PRINTS THE EQUATIONS ON THE SCREEN    
void printEQUATIONS()
{
  stroke(0);
  fill(120);
  //fill(220, 180, 0);
  rect(0, 120, 800, 80);
  fill(0);
  textSize(14);
  text("EQUATIONS", 10, 140);
  textSize(14);
  text("THE STATES CHOOSEN TO HAVE MINIMUM ENERGY ARE : "+sA[0]+" & "+sA[1], 250, 140);
  textSize(15);
  for (int tt=0;tt<2;tt++) {     
    fill(255);   
    rect(120, 150+20*tt, 220, 20);
    rect(120+220, 150+20*tt, 220, 20);    
    rect(120+440, 150+20*tt, 220, 20);
  }
  fill(0);
  text("Eqn. for "+sA[0], 20, 165);
  text("Eqn. for "+sA[1], 20, 185);
  for (int coun=0;coun<2;coun++)
  {
    for (int j=0;j<3;j++)
    {
      fill(0);
      text(ss1[3*coun+j], 130+220*j, 165+20*coun);
    }
  }
  giveSLIDERS();
  noStroke();
}
/////////////////////////////////////////////////////////////////////////////////////////
//HARD CODED VALUES
void giveSLIDERS()
{
  //250-550
  textSize(15);
  text("W12 = W21", 50, 280);
  text("W23 = W32", 50, 320);
  text("W31 = W13", 50, 360);
  text("Threshold1", 50, 400);
  text("Threshold2", 50, 440);
  text("Threshold3", 50, 480);
  //the main area
  for (int i=0;i<6;i=i+1)
  {
    //fill(200, 20*i, 40);
    fill(120);
    rect(150, 270+40*i, 420, 10);
    for (int j=0;j<22;j++)
    {
      fill(150);
      line(150+20*j, 270+40*i, 150+20*j, 285+40*i);
    }
  }
  //the markers
  line(150, 260, 150, 480);
  line(350, 260, 350, 480);
  line(370, 260, 370, 480);  
  line(570, 260, 570, 480);
  //the texts
  fill(0);
  text("-1.0", 145, 500);
  text("0", 355, 500);
  text("1.0", 565, 500);
  secondTRACK = true;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void reTAIN(int jj, int ii)
{
  float tt=0.0;
  tt =ii;
  tt = (tt-11)/10;
  mark[jj] = true;
  valA[jj] = tt;
  for (int c=0;c<6;c++)
  {
    if (mark[c] == true && c!=jj)
    {
      textSize(20);
    }
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void newEnergyDiagram()
{
  drawDIAG();
  weightA[0][0] = 0;
  weightA[0][1] = valA[0];
  weightA[0][2] = valA[2];
  weightA[1][0] = valA[0];
  weightA[1][1] = 0;
  weightA[1][2] = valA[1];
  weightA[2][0] = valA[2];
  weightA[2][1] = valA[1];
  weightA[2][2] = 0;
  for (int i=0;i<3;i=i+1)
  {
    thresholdA[i] = valA[3+i];
  }

  callForEnergy();
  calSTTtrsn(probOFtr, energyArr);
  determineORDER(stateARR, energyArr, orderSTATES);
  drawENERGYdiagram(stateARR, orderSTATES);
  drawCONNECIONS(probOFtr, stateARR);
  trackMOUSEmovement();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
      //text(summ,200+40*p,400+30*q);
    }
    sumn = sumn+thresholdA[p]*temp[p];
  }
  enerGY = (-0.5*summ)+sumn;
  enerGY = Round(enerGY, 2);
  //text(enerGY,200,400);
  return(enerGY);
}
// FOR ROUNDING OFF ENERGY VALUES
public static float Round(float Rval, int Rpl) {
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
    //text(stateARR[cc].enerGY,200+50*cc,400);
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
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TRY TO FIND THE TRANSITION PROBABILITIES AND MAKE AN ENTRY TO MATRIX
void calSTTtrsn(float[][] probOFtrT, float[] energyArrR)
{
  for (int outC=0;outC<8;outC++)
  {
    for (int inC=0;inC<8;inC++)
    {
      if (energyArrR[outC]>=energyArrR[inC] && hamminDIST(outC, inC))
      {
        probOFtrT[outC][inC] = 1;
      }
      else
      {
        probOFtrT[outC][inC] = 0;
      }
    }
  }
  for (int outC=0;outC<8;outC++)
  {
    float tt=0.0; 
    for (int inC=0;inC<8;inC++)
    {
      tt = tt+ probOFtrT[outC][inC];
    }
    if (tt>0 && tt<4) {
      tt = 1/tt;
      tt = Round(tt, 1);
    }
    else if (tt>0 && tt==4)
    {
      tt--;
      probOFtrT[outC][outC]=0;
      tt = 1/tt;
      tt = Round(tt, 1);
    }
    for (int inC=0;inC<8;inC++)
    {
      probOFtrT[outC][inC] = probOFtrT[outC][inC]*tt;
    }
  }
}
// ORDER OF THE DISPLAY 
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Draws Lines Betweeen Energy States Showing Possible Transitions
void drawCONNECIONS(float[][] probOFtrTEMPP, staTES[] TEMPstatesARR)
{
  for (int outC=0;outC<8;outC++)
  {
    for (int inC=0;inC<8;inC++)
    {
      if (probOFtrTEMPP[outC][inC]>0)
      {
        float f = 10*(energyArr[outC]+energyArr[inC]);
        f = f + abs(TEMPstatesARR[outC].stateCOX - TEMPstatesARR[inC].stateCOX)/5;
        stroke(200, 200, 0);
        line(TEMPstatesARR[outC].stateCOX, TEMPstatesARR[outC].stateCOY+25, TEMPstatesARR[inC].stateCOX-30-f, TEMPstatesARR[outC].stateCOY+25);
        line(TEMPstatesARR[inC].stateCOX-30-f, TEMPstatesARR[outC].stateCOY+25, TEMPstatesARR[inC].stateCOX-30-f, TEMPstatesARR[inC].stateCOY+15);
        line(TEMPstatesARR[inC].stateCOX-30-f, TEMPstatesARR[inC].stateCOY+15, TEMPstatesARR[inC].stateCOX, TEMPstatesARR[inC].stateCOY+15);
        fill(0);
        triangle(TEMPstatesARR[inC].stateCOX, TEMPstatesARR[inC].stateCOY+15, TEMPstatesARR[inC].stateCOX-10, TEMPstatesARR[inC].stateCOY, TEMPstatesARR[inC].stateCOX-10, TEMPstatesARR[inC].stateCOY+30);
        noFill();
        noStroke();
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// DRAWS STATE TRANSITION DIAGRAM 





///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// DRAWS STATE TRANSITION DIAGRAM 
void drawENERGYdiagram(staTES[] stateARRR, int[] orderSTATESS)
{
  boolean f = false;
  int count=1;
  for (int i=0;i<orderSTATESS.length;i++)
  {
    int drawStartXX = drawStartX;  
    String s = stateARRR[i].staTE;
    int[] tt = new int[3];
    char[] cTEMP = s.toCharArray();
    for (int iC=0;iC<3;iC++)
    {
      tt[iC] = int(cTEMP[iC])-48;
    }
    int in = stateARRR[i].orDER; 
    count =0;
    for (int y=0;y<i;y++)
    {
      if (stateARRR[y].orDER == in)// && stateARRR[y].printed==false)
      {
        count++;
      }
    }     
    drawStartXX = drawStartXX - 150*(count);
    fill(50);
    rect(drawStartXX, drawStartY-(65*in), 90, 45);
    fill(255);
    textSize(15);

    text(tt[0], drawStartXX+40, drawStartY-(65*in)+18);
    text(tt[1], drawStartXX+5, (drawStartY-(65*in))+34);
    text(tt[2], drawStartXX+75, (drawStartY-(65*in))+34);

    text("{"+stateARRR[i].enerGY+"}", drawStartXX+24, (drawStartY-(65*in))+35);
    stateARRR[i].stateCOX = drawStartXX;
    stateARRR[i].stateCOY = drawStartY-(65*in);
    drawStartXX = drawStartX;
  }
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void drawDIAG()
{
  fill(0, 0, 200);
  stroke(250, 240, 0);
  line(180, 200, 100, 300);
  line(180, 200, 260, 300);
  line(260, 300, 100, 300);
  stroke(150, 120, 0);
  ellipse(180, 200, 30, 30);
  ellipse(100, 300, 30, 30);
  ellipse(260, 300, 30, 30);
  noStroke();
  textSize(16);
  fill(255);
  text("1", 175, 205);
  text("2", 95, 305);
  text("3", 255, 305);
  noFill();
  textSize(14);
  fill(152, 0, 53);
  text("Threshold="+valA[3], 135, 180);
  text("Threshold="+valA[4], 56, 335);
  text("Threshold="+valA[5], 220, 335);
  text(valA[2], 210, 235);
  text(valA[0], 105, 235);
  text(valA[1], 150, 295);
  noStroke();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Checks the entered inqualities
boolean checkINEQ()
{

  weightA[0][0] = 0;
  weightA[0][1] = valA[0];
  weightA[0][2] = valA[2];
  weightA[1][0] = valA[0];
  weightA[1][1] = 0;
  weightA[1][2] = valA[1];
  weightA[2][0] = valA[2];
  weightA[2][1] = valA[1];
  weightA[2][2] = 0;
  thresholdA[0] = valA[3];
  thresholdA[1] = valA[4];
  thresholdA[2] = valA[5];

  boolean answer = false;
  int[] temp= new int[6];
  float[] res = new float[6];
  char[] c1 = sA[0].toCharArray();
  char[] c2 = sA[1].toCharArray();
  for (int i=0;i<3;i++)
  {
    temp[i] = int(c1[i])-48;
    temp[3+i] = int(c2[i])-48;
  }

  res[0] = weightA[0][1]*temp[1] + weightA[0][2]*temp[2] - thresholdA[0];
  res[1] = weightA[1][0]*temp[0] + weightA[1][2]*temp[2] - thresholdA[1];
  res[2] = weightA[2][0]*temp[0] + weightA[2][1]*temp[1] - thresholdA[2];
  res[3] = weightA[0][1]*temp[4] + weightA[0][2]*temp[5] - thresholdA[0];
  res[4] = weightA[1][0]*temp[3] + weightA[1][2]*temp[5] - thresholdA[1];
  res[5] = weightA[2][0]*temp[3] + weightA[2][1]*temp[4] - thresholdA[2];
  int oun =0;
  for (int v=0;v<6;v++)
  {
    if ((temp[v]>0 && res[v]>0) || (temp[v]==0 && res[v]<=0))
    {
      oun= oun+1;
    }
  }
  if (oun==6) {
    answer=true;
  }

  return answer;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void trackMOUSEmovement()
{
  for (int i=0;i<8;i=i+1)
  {
    if (mouseX-stateARR[i].stateCOX > 0 && mouseX-stateARR[i].stateCOX < 90 && mouseY-stateARR[i].stateCOY > 0 && mouseY-stateARR[i].stateCOY < 45)
    {
      String s = stateARR[i].staTE;
      int[] tt = new int[3];
      char[] cTEMP = s.toCharArray();
      for (int iC=0;iC<3;iC++)
      {
        tt[iC] = int(cTEMP[iC])-48;
      }

      fill(0, 0, 205);
      rect(stateARR[i].stateCOX, stateARR[i].stateCOY, 90, 45);
      fill(255);
      textSize(15);     
      text(tt[0], stateARR[i].stateCOX+40, stateARR[i].stateCOY+16);
      text(tt[1], stateARR[i].stateCOX+5, stateARR[i].stateCOY+30);
      text(tt[2], stateARR[i].stateCOX+75, stateARR[i].stateCOY+30);
      for (int ii=0;ii<8;ii=ii+1)
      {
        if (probOFtr[i][ii]>0)
        {
          String s1 = stateARR[ii].staTE;
          int[] tt1 = new int[3];
          char[] cTEMP1 = s1.toCharArray();
          for (int iC=0;iC<3;iC++)
          {
            tt1[iC] = int(cTEMP1[iC])-48;
          }

          fill(0, 0, 205);
          rect(stateARR[ii].stateCOX, stateARR[ii].stateCOY, 90, 45);
          fill(255);
          textSize(15);     
          text(tt1[0], stateARR[ii].stateCOX+40, stateARR[ii].stateCOY+16);
          text(tt1[1], stateARR[ii].stateCOX+5, stateARR[ii].stateCOY+30);
          text(tt1[2], stateARR[ii].stateCOX+75, stateARR[ii].stateCOY+30);
          text("{"+probOFtr[i][ii]+"}", stateARR[ii].stateCOX+24, stateARR[ii].stateCOY+35);
          text("{"+probOFtr[i][i]+"}", stateARR[i].stateCOX+24, stateARR[i].stateCOY+35);


          float f = 10*(energyArr[i]+energyArr[ii]);
          f = f + abs(stateARR[i].stateCOX - stateARR[ii].stateCOX)/5;
          stroke(0, 0, 193);

          line(stateARR[i].stateCOX, stateARR[i].stateCOY+25, stateARR[ii].stateCOX-30-f, stateARR[i].stateCOY+25);
          line(stateARR[i].stateCOX, stateARR[i].stateCOY+26, stateARR[ii].stateCOX-30-f, stateARR[i].stateCOY+26);

          line(stateARR[ii].stateCOX-30-f, stateARR[i].stateCOY+25, stateARR[ii].stateCOX-30-f, stateARR[ii].stateCOY+15);
          line(stateARR[ii].stateCOX-31-f, stateARR[i].stateCOY+25, stateARR[ii].stateCOX-31-f, stateARR[ii].stateCOY+15);


          line(stateARR[ii].stateCOX-30-f, stateARR[ii].stateCOY+15, stateARR[ii].stateCOX, stateARR[ii].stateCOY+15);
          line(stateARR[ii].stateCOX-30-f, stateARR[ii].stateCOY+14, stateARR[ii].stateCOX, stateARR[ii].stateCOY+14);


          line(stateARR[i].stateCOX, stateARR[i].stateCOY+26, stateARR[ii].stateCOX-30-f, stateARR[i].stateCOY+26);
          line(stateARR[ii].stateCOX-31-f, stateARR[i].stateCOY+25, stateARR[ii].stateCOX-31-f, stateARR[ii].stateCOY+15);
          line(stateARR[ii].stateCOX-30-f, stateARR[ii].stateCOY+16, stateARR[ii].stateCOX, stateARR[ii].stateCOY+16);
        }
      }
    }
  }
}

