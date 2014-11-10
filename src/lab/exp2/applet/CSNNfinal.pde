
boolean flagDES = false;
float[][] valueOfIter = new float[30][40];  
boolean[] stage4MARK= new boolean[40];
float[] roomTYPE1= new float[40];
float[] roomTYPE2= new float[40];
float[] roomTYPE3= new float[40];
int initITER= 25;
int countITER = 0;
boolean error3 = false;
int choiceNum=0;
float[] markKIT= new float[40];
float[] markBROM= new float[40];
float[] markOFFC= new float[40];
boolean choice =false;
int valHINTON=0;
boolean initFL = false;
float[][] STATES; // = new float[40][40];
float[] tempARR;
float[] tempARR2 = new float[1600];
byte[] arrayVALtemp;
byte[] arrayVAL;
String[] roomsTYPE = new String[3];
String[] Names;
int stage = 1;

// INITIALIZATION PART 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void setup()
{
  backCreate();
}
void backCreate()
{
  Names = loadStrings("roomunames.txt");
  size(800, 600);
  background(40);
}
void draw()
{
  partOneBack();
  drawHINTON();
  trainBACK();
  viewBACK();
  testCSNN();
  displayITER();
}

//THIS IS PART OF DESIGN AND LAYOUT 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//THIS IS PART OF DESIGN AND LAYOUT 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void partOneBack()
{

  if (stage==1)
  {
    // To show the descriptor list .. 
    backCreate();
    textSize(13);
    fill(200, 250, 0);
    text("FOLLOWING IS A LIST OF DESCRIPTORS USED TO TRAIN THE MODEL", 160, 170);
    text("AND DESCRIBE ABOVE ROOM TYPES", 260, 190);
    //this part deals with the display of descriptors
    fill(255);
    rect(50, 200, 700, 170);
    for (int j=0;j<5;j+=1)
    {
      for (int i=0;i<8;i+=1)
      {
        textSize(14);
        fill(0);
        text(Names[j*8+i], 80+140*(j), 220+(i*20));
        text(Names[j*8+i], 81+140*(j), 220+(i*20));
      }
    }
    //this part writes about the clicking and training model .. 
    fill(255);
    rect(265, 410, 260, 50);
    fill(0);
    rect(270, 415, 250, 40);
    fill(200, 200, 0);
    textSize(13);
    text("Click here to train the model", 310, 440);
    //
    //this part writes about the clicking and seeing the state of the descriptors  .. 
    fill(255);
    rect(265, 510, 260, 50);
    fill(0);
    rect(270, 515, 250, 40);
    fill(200, 200, 0);
    textSize(13);
    text("Click here for descriptors state", 295, 540);

    roomsTYPE[0] = "KITCHEN";
    roomsTYPE[1] = "BEDROOM";
    roomsTYPE[2] = "OFFICE";
    textSize(13);
    fill(255, 200, 20);
    text("CLICK HERE TO SEE THE HINTON DIAGRAM", 250, 50);
    fill(200, 160, 0);
    rect(340, 60, 100, 30);
    stroke(0);
    rect(345, 65, 90, 20);
    textSize(13);
    fill(0);
    text("CLICK", 370, 80);
    noStroke();
    textSize(13);
    fill(250, 200, 0);
    text("THE ROOM TYPES THE MODEL GETS TRAINED FOR ARE "+roomsTYPE[0]+", "+roomsTYPE[1]+" and "+roomsTYPE[2]+" ", 120, 140);
  }
//  if (arrayVAL == null)
//  {
//    arrayVAL = loadBytes("state.txt");
    tempARR = new float[1600];
//    int count=0;
//    for (int j=0;j<arrayVAL.length;j+=1)
//    {
//      if (arrayVAL[j]==118 || arrayVAL[j]==100 || arrayVAL[j]==46)
//      {
//        switch(arrayVAL[j])
//        {
//        case 118:
//          tempARR[count] = 2.5;
//          break;
//        case 100:
//          tempARR[count] = 1;
//          break;
//        case 46:
//          tempARR[count] = 0;
//          break;
//        }
//        count+=1;
//      }
//    }
//    for (int out=0;out<40;out+=1)
//    {
//      for (int in=0;in<40;in+=1)
//      {
//        STATES[out][in] = tempARR[40*out+in];
//      }
//    }
//  }

if(STATES == null)
{
  STATES = new float[40][40];
  String[] s1 = loadStrings("csroomwt.txt");
  for (int i=0;i<s1.length;i+=1)
  {
    int count=0;
    StringTokenizer st = new StringTokenizer(s1[i]);
    while (st.hasMoreTokens ())
    {
      STATES[i][count] = float(st.nextToken());
      count+=1;
    }
  }
}
//for(int i=0;i<40;i+=1)
//{
//for(int j=0;j<40;j+=1)
//{  
//println(STATES[i][j]);
//}
//}
}


//EVENT HANDLERS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void mouseClicked()
{ 
  //Stage 1 movements 
  if (stage == 1 && mouseY>60 && mouseY<90 && mouseX>340 && mouseX<440)
  {

    initFL=true;
    valHINTON = 1;
    fill(255);
  }
  else if (stage == 1 && mouseY>415 && mouseY<455 && mouseX>270 && mouseX<520)
  {
    stage =3;
    trainBACK();
  }
  else if (stage == 1 && mouseY>515 && mouseY<555 && mouseX>270 && mouseX<520)
  {
    stage = 4;
    for (int i=0;i<40;i+=1)
    {
      stage4MARK[i] = false;
    }
    viewBACK();
  }
  else if (stage==1 && valHINTON!=0)
  {
    if (mouseX>610 && mouseX<690 && mouseY>520 && mouseY< 550)
    {
      valHINTON=0;
    }
  }
  // This is when room type has been choosen and the descriptors are being chosen  .. 
  else if (stage == 3)
  {
    if (mouseX>30 && mouseX<750 && mouseY>100 && mouseY<250 && choice==true)
    {
      int px = int((mouseX-30)/90);
      int qx = int((mouseY-100)/30);
      int num = 8*qx+px;

      if (choiceNum==1)
      {
        if (markKIT[num]!=1)
        {
          markKIT[num] = 1;
        }
        else
        {
          markKIT[num] = 0;
        }
      }
      else if (choiceNum==2)
      {
        if (markBROM[num]!=1)
        {
          markBROM[num] = 1;
        }
        else
        {
          markBROM[num] = 0;
        }
      }
      else if (choiceNum==3)
      {
        if (markOFFC[num]!=1)
        {
          markOFFC[num] = 1;
        }
        else
        {
          markOFFC[num] = 0;
        }
      }
    }
    // if CLICKED after choosing the descriptors
    else if (mouseX>610 && mouseX<680 && mouseY>420 && mouseY<450 && choice == true)
    {
      int d1=0;
      int d2=0;
      int d3=0;      
      for (int cc=0;cc<40;cc+=1)
      {
        if (markKIT[cc]==0)
        {
          d1+=1;
        }
        if (markBROM[cc]==0)
        {
          d2+=1;
        }
        if (markOFFC[cc]==0)
        {
          d3+=1;
        }
      }
      if (d1==40 || d2 ==40 || d3==40)
      {
        error3 = true;
      }
      else
      {
        lockVALUES();
      }
    }
    // This is on the second screen when room type is to be choosen 
    else if (choice==false && mouseY>30 && mouseY<60)
    {
      for (int i=0;i<3;i+=1)
      {
        if (mouseX>160+180*i && mouseX<260+180*i)
        {
          choiceNum=i+1;
          choice=true;
        }
      }
    }
    else if (choice==true && mouseY>30 && mouseY<60)
    {
      for (int i=0;i<3;i+=1)
      {
        if (mouseX>160+180*i && mouseX<260+180*i)
        {
          choiceNum=i+1;
          choice=true;
        }
      }
    }
  }
  //Following is the code for the part when descriptors are being shown.. 
  else if (stage ==4)
  {
    if (mouseX>610 && mouseX<690 && mouseY>565 && mouseY<595)
    {
      stage=1;
      choice=false;
      flagDES = false;
    }
  }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This is the part handling the display while the training is done in the second screen .. 
void trainBACK()
{
  if (stage==3)
  {
    //rectangle hiding the entire background
    fill(40);
    rect(0, 0, 800, 600);
    // to display the three room tyes on the heading 
    for (int i=0; i<3;i=i+1)
    {
      fill(255);
      rect(160+180*i, 30, 100, 30);
      fill(120);
      rect(163+180*i, 32, 94, 26);
      fill(220, 250, 0);
      textSize(13);
      text(roomsTYPE[i], 180+185*i, 50);
    }

    //yellow rectangle containing the descriptor names
    fill(200, 150, 0);
    rect(30, 100, 730, 150);
    //drawing boundries
    for (int i=0;i<5;i+=1)
    {
      fill(0);
      line(30, 100+30*i, 760, 100+30*i);
      line(30, 101+30*i, 760, 101+30*i);
    }
    for (int j=0;j<8;j+=1)
    {
      fill(0);
      line(30+90*j, 100, 30+90*j, 250);
      line(30+90*j, 99, 30+90*j, 249);
    }
    // printing the descriptor names within the boundries in yellow box..
    fill(0);
    textSize(14);
    for (int i =0;i<5;i+=1)
    {
      for (int j=0;j<8;j+=1)
      {
        text(Names[8*i+j], 34+90*j, 120+30*i);
        text(Names[8*i+j], 35+90*j, 120+30*i);
      }
    }
    fill(255);
    if (choice==false)
    {
      textSize(13);
      text("Click on any of the above room types to train the model for", 40, 90);
    }
    //when you click the room type to be trained for
    else
    {
      float[] mark = new float[40];
      textSize(13);
      text("Click on the following descriptors to train for - "+roomsTYPE[choiceNum-1], 40, 90);
      text("Click again to deselect the descriptor", 40, 270);
      //the click button after descriptors have been selected
      rect(610, 420, 80, 30);
      rect(612, 422, 76, 26);
      text("for submitting and going back", 540, 470);
      fill(0);
      textSize(13);
      text("CLICK", 625, 442);
      text("CLICK", 626, 442);      
      //the black box containing the name of the descriptors.
      fill(0);
      rect(30, 300, 370, 250);
      fill(255);
      textSize(13);
      text("THE DESCRIPTORS FOR "+roomsTYPE[choiceNum-1]+" ARE --", 60, 340);
      //text(roomsTYPE[choiceNum-1]+" ARE --",80,360);
      textSize(12);
      int j=0;
      int j2 = 0;
      for (int i=0; i<40;i+=1)
      {
        if (choiceNum==1)
        {
          mark = markKIT;
        }
        else if (choiceNum==2)
        {
          mark = markBROM;
        }
        else if (choiceNum==3)
        {
          mark = markOFFC;
        }  

        if (mark[i] ==1)
        {
          if (j>12)
          {
            j2 += 1;
            j=0;
          }
          textSize(12);
          text(Names[i], 60+(100*j2), 360+15*j);
          j+=1;
        }
      }
      for (int i=0;i<40;i++)
      {

        if (choiceNum==1)
        {
          mark = markKIT;
        }
        else if (choiceNum==2)
        {
          mark = markBROM;
        }
        else if (choiceNum==3)
        {
          mark = markOFFC;
        }  

        if (mark[i]==1)
        {
          fill(200, 0, 220);
          rect(33+(i%8)*90, 105+(i/8)*30, 80, 20);
          fill(205, 255, 0); 
          textSize(12);
          text(Names[i], 40+(i%8)*90, 120+(i/8)*30);
        }
      }
      if (error3 == true)
      {
        fill(255);
        textSize(13);
        text("Please train for all three room types", 440, 300);
      }
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// We are saving the desciptors for the particular room type.. Here we can hinge some descriptors to a particular value .
void lockVALUES()
{
  stage=1;  
  choice = false;
  countITER = countITER+1;

  for (int i=0;i<40;i+=1)
  {
    roomTYPE1[i] = roomTYPE1[i]+markKIT[i];
    markKIT[i]=0;
    roomTYPE2[i] = roomTYPE2[i]+markBROM[i];
    markBROM[i]=0;      
    roomTYPE3[i] = roomTYPE3[i]+markOFFC[i];
    markOFFC[i]=0;
  }
  calcPROB();
}    



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculates the probability matrix to be used in the display of Hinton.. countITER[3] kitchenSTATES officeSTATES  bedroomSTATES choiceNum
//void calcPROB(float[][] a,float[][] b,float[][] c)
void calcPROB()
{
  float d1, d2, d3, d4;
  //For Kitchen
  float p1 = 1;
  float p2 = 1;
  float p3 = 1;
  float p4 = 1;         
  float te = 0;
  // intial no of iterations are 25 and rest will count over it.. 
  // int netITER = initITER+countITER;

  for (int i=0;i<40;i+=1)
  { 
    d1 = countITER-roomTYPE1[i];
    for (int j=0;j<40;j+=1)
    {
      d2 = countITER-roomTYPE2[j];
      d3 = countITER-roomTYPE3[j];
      if (roomTYPE1[i]==0 && (roomTYPE2[j]!=0 || roomTYPE3[j]!=0))
      {
        if (roomTYPE2[j]>roomTYPE3[j])
        {
          p1 = roomTYPE2[j]/countITER;
        }
        else
        {
          p1 = roomTYPE3[j]/countITER;
        }
      }
      else if (roomTYPE1[i]!=0 && (roomTYPE2[j]==0 || roomTYPE3[j]==0))
      {
        if (roomTYPE2[j]==0)
        {
          p2 = d2/countITER;
        }
        else
        {
          p2 = d3/countITER;
        }
      }
      float wij  = (p1*p2)/(p3*p4);
      wij = -log(wij);
      if(wij>0.0)
      {
      print(" --->  "+wij);
      }
      STATES[i][j] = STATES[i][j]+wij;
    }
  }

//  for (int i=0;i<40;i+=1)
//  {
//    for (int j=0;j<40;j+=1)
//    {
//      //        System.out.print(" <> "+STATES[i][j]);
//    }
//    //       System.out.println("<br>");
//  }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This part is to display the state of the descriptors after they are selected for the room types..
void viewBACK()
{
  testCSNN();
}





////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void drawHINTON()
{
  if (valHINTON!=0)
  {
    drawH(valHINTON);
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Draws the Hinton Diagram After loadHINTONval has been run .. 
void drawH(int cc)
{
  //Load weight values from the text file
  float[][] temp = new float[40][40];
  temp= STATES;
  float[] tempARRh = new float[1600];
  for (int i=0;i<40;i+=1)
  {
    for (int j=0;j<40;j+=1)
    {
      tempARRh[40*i+j] = temp[i][j];
    }
  }
  //THIS IS THE FRAME RECTANGLE
  int drawX = 10; 
  int drawY = 115;
  fill(160);
  rect(drawX, drawY, 780, 365);
  stroke(0);
  rect(drawX+5, drawY+5, 770, 355);
  noStroke();

  // THIS PART IS DRAWING SMALL RECTAGLES
  drawX = drawX+10;
  drawY = drawY+10;
  for (int i=0;i<5;i+=1)
  {
    for (int j=0;j<8;j+=1)
    {
      fill(255);
      rect(drawX+95*j, drawY+70*i, 85, 50);
      fill(0);
      textSize(13);
      text(Names[8*i+j], drawX+95*j, drawY+70*i+65);
    }
  }
  // This is for drawing the button to go back to stage 1
  textSize(16);
  fill(255);
  rect(610, 520, 80, 30);  
  text("for going back", 650, 570);
  fill(0);
  rect(612, 522, 76, 26);
  textSize(16);
  fill(255);
  text("CLICK", 625, 542);
  text("CLICK", 626, 542);


  for (int i=0;i<5;i+=1)
  {
    for (int j=0;j<8;j+=1)
    {
      //Insert the color scheme here too.. 
      int t = (8*i)+j;

      fill(0);

      for (int in=0;in<5;in+=1)
      {
        for (int out=0;out<8;out+=1)
        {
          int dd = (8*in)+out;

          int tt = (int)(tempARRh[(40*t)+dd]*100); 
          fill(155-tt);
          int tempX = drawX+95*j+4;
          int tempY = drawY+70*i+5;
          rect(tempX+10*out, tempY+9*in, 7, 6);
        }
      }
    }
  }
  trackMOUSE(cc);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This handles the mouse movement while going through the Hinton Diagram screen ..
void trackMOUSE(int ccd)
{
  for (int i=0;i<40;i+=1)
  {
    for (int j=0;j<40;j+=1)
    {
      tempARR[40*i+j] = STATES[i][j];
    }
  }
  int drawX = 20;
  int drawY = 125;
  fill(40);
  rect(0, 490, 600, 100);

  for (int i=0;i<5;i+=1)
  {
    for (int j=0;j<8;j+=1)
    { 
      if (mouseX>drawX+95*j && mouseX<drawX+95*j+85 && mouseY>drawY+70*i && mouseY<drawY+70*i+50)
      {
        fill(120);
        rect(270, 490, 250, 100);
        fill(255);
        rect(275, 495, 240, 90);
        fill(255);
        textSize(18);
        text(Names[(8*i)+j], 120, 550);
        int t = (8*i)+j;
        fill(0);
        for (int out=0;out<5;out+=1)
        {
          stroke(30);
          line(275, 495+18*out, 515, 495+18*out);
          noStroke();
          for (int in=0;in<8;in+=1)
          {
            stroke(30);
            line(275+in*30, 495, 275+in*30, 585);
            noStroke();
            int cc = (8*out)+in;
            int tt = (int)(tempARR[(40*t)+cc]*100); 
            fill(155-tt);


            rect(275+in*30+2, 495+18*out+2, 26, 14);
          }
        }
        noStroke();
        break;
      }
    }
  }
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This part will now deal with the testing probably
void testCSNN()
{
  if (stage == 4)
  {
    //clearing the mark array so that descriptors can be chosen
    fill(70);
    rect(0, 0, 800, 600);
    // Now we'll design the page .. 
    fill(255);
    rect(610, 565, 80, 30);
    stroke(0);
    rect(612, 567, 76, 26);
    text("for going back", 700, 595);
    fill(0);
    textSize(13);
    text("CLICK", 625, 587);
    text("CLICK", 626, 587); 
    textSize(13);      
    // click here to start testing the nw after clamping the descriptors
    fill(255);
    rect(150, 565, 80, 30);
    stroke(0);
    rect(152, 567, 76, 26);
    text("for testing the network", 250, 595);
    text("after done with clamping", 400, 595);
    fill(0);
    textSize(13);      
    text("CLICK", 163, 587);
    text("CLICK", 164, 587); 

    //for display of the descriptors to be clamped.

    for (int j=0;j<5;j+=1)
    {
      stroke(200, 0, 100);
      line(5, 45, 780, 45);
      line(5, 60+j*20, 780, 60+j*20);
      noStroke();
      for (int i=0;i<8;i+=1)
      {
        stroke(200, 0, 100);
        line(15+98*i, 40, 15+98*i, 140);
        line(775, 40, 775, 110);
        noStroke();
        fill(255);
        if (stage4MARK[8*j+i]==false)
        {
          text(Names[8*j+i], 15+98*i, 60+20*j);
        }
        else
        {
          fill(0);
          rect(15+98*i, 45+20*j, 80, 15); 
          fill(255);
          text(Names[8*j+i], 15+98*i, 60+20*j);
        }
        noFill();
      }
    }
  }
}

void mousePressed()
{
  if (stage==4)
  {
    if (mouseY>45 && mouseY <140)
    {
      if (mouseX>5 && mouseX<780)
      {
        int yY = mouseY;
        int xX = mouseX;
        yY = (yY-45)/20;
        xX = (xX-15)/98;
        if (stage4MARK[8*yY+xX]==false)
        {
          stage4MARK[8*yY+xX] = true;
        }
        else
        {
          stage4MARK[8*yY+xX] = false;
        }
      }
    }
    else if (mouseY>565 && mouseY<595 && mouseX>150 && mouseX<230)
    {
      testCircle();
      flagDES = true;
    }
  }
}

//////////////////////////////// ////////////////////////////////?? ////////////////////////////////?? ////////////////////////////////?? 
void testCircle()
{
  int[] clampedINP = new int[40];
  //  int[][] tempI = new int[40][40];
  float [][] tempI = new float[40][40];
  float[] biasVECT = new float[40];

  String[] s1 = loadStrings("csroomwt.txt");
  for (int i=0;i<s1.length;i+=1)
  {
    int count=0;
    StringTokenizer st = new StringTokenizer(s1[i]);
    while (st.hasMoreTokens ())
    {
      tempI[i][count] = float(st.nextToken());
      count+=1;
    }
  }

  //give the clamped inputs a weightage 1
  for (int i=0;i<40;i+=1)
  {
    if (stage4MARK[i] == true)
    {
      clampedINP[i]=1;
    }
    else
    {
      clampedINP[i]=0;
    }
  }

  //
  //  //now take the descriptors and find the bias values 
  //  for (int out=0;out<40;out+=1)
  //  {
  //    for (int in=0;in<40;in+=1)
  //    {
  //      tempI[out][in] = int(tempARR2[out*40+in]);
  //      print("->"+tempI[out][in]);
  //    }
  //    println();
  //  }
  //
  //  for (int i=0;i<40;i+=1)
  //  {
  //    biasVECT[i] = tempI[i][i]/130.0;
  //    if (countITER!=0)
  //    {
  //      biasVECT[i] = (roomTYPE1[i]+roomTYPE2[i]+roomTYPE3[i])/countITER;
  //    }
  //    float ff = (1-biasVECT[i])/biasVECT[i];
  //    ff = -log(ff);
  //    biasVECT[i] = ff;
  //  }
  //  //Done with calculating the bias weights..  
  float[] StatesInit = new float[40];
  float[] StatesNext = new float[40];
  float[] StatesDiff = new float[40];
  for (int i=0;i<40;i+=1)
  {
    if (stage4MARK[i]==true)
    {
      StatesInit[i] = 1.0;
    }
    else
    {
      StatesInit[i] = 0.0001;
    }
    StatesNext[i] = 0.0;
  }
  int countdowhile = 0;
  do
  {
    for (int i=0;i<40;i+=1)
    {
      for (int j=0;j<40;j+=1)
      {
        StatesNext[i] = StatesNext[i]+StatesInit[i]*tempI[i][j];
      }
    }
    //normalization of values ... 
    for (int i=0;i<40;i+=1)
    {
      StatesNext[i] = StatesNext[i]/max(StatesNext);
      StatesNext[i] = (exp(2*(StatesNext[i]))-1)/( exp(2*(StatesNext[i]))+1);
      //      print(" ->"+StatesInit[i]);
      StatesDiff[i] = StatesNext[i] - StatesInit[i];  
      if (StatesInit[i]!=1.0)
      {
        StatesInit[i] = StatesNext[i];
      }
      // here you can put a threshold to this tan value
    }
    for (int i1=0;i1<40;i1+=1)
    {
      valueOfIter[countdowhile][i1] = StatesNext[i1];
    }
    countdowhile+=1;
  }
  while (countdowhile<30);
  displayITER();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void displayITER()
{
  if (stage ==4 && flagDES==true)
  {
    stroke(200, 200, 0);
    rect(10, 155, 400, 400);
    rect(415, 155, 380, 400);
    noStroke();
    int xST = 20;
    int yST = 170;
    for (int i=0;i<20;i+=1)
    {
      textSize(13);
      text(Names[i], xST, yST+20*i);
      text(Names[20+i], xST+400, yST+20*i);
    }
    for (int i = 0;i<20;i+=1)
    {
      for (int j = 0;j<14;j+=1)
      {
        stroke(0);
        int f1 = int(valueOfIter[10+j][i]*100);
        int f2 = int(valueOfIter[10+j][20+i]*100);
        fill(f1);
        rect(xST+100+20*j, (yST-10)+20*i, 10, 10);
        fill(f2);
        rect(xST+500+20*j, (yST-10)+20*i, 10, 10);
        noFill();
        noStroke();
      }
    }
  }
}

