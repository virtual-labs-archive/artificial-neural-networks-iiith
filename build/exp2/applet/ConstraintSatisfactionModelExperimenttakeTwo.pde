// THIS IS THE PART OF DECLARATION
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int[] countITER =new int[3];
int choiceNum=0;
boolean choice =false;
byte[] arrayVAL;
float[] tempARR;
String[] Names;
int roomTRACK;
String[] roomsTYPE = new String[3];
int stage = 1;
boolean descriptorCHECK = false;
int valHINTON=0;
boolean checked = false;
boolean[] initFL = new boolean[3];
float[] mark= new float[40];
float[] roomTYPE1= new float[40];
float[] roomTYPE2= new float[40];
float[] roomTYPE3= new float[40];
float[][] kitchenSTATES = new float[40][40];
float[][] officeSTATES = new float[40][40];
float[][] bedroomSTATES = new float[40][40];
// INITIALIZATION PART 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void setup()
{
  backCreate();
}

void backCreate()
{
  Names = loadStrings("descriptors.txt");
  size(800, 600);
  background(40);
}
void draw()
{
  partOneBack();
  drawHINTON();
  trainBACK();
  viewBACK();
}

//THIS IS PART OF DESIGN AND LAYOUT 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//THIS IS PART OF DESIGN AND LAYOUT 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void partOneBack()
{

  if (stage==1)
  {
    backCreate();
    roomsTYPE[0] = "KITCHEN";
    roomsTYPE[1] = "BEDROOM";
    roomsTYPE[2] = "OFFICE";
    for (int i=0; i<3;i=i+1)
    {
      fill(255);
      rect(160+180*i, 30, 100, 30);
      fill(120);
      rect(163+180*i, 32, 94, 26);
      fill(220, 250, 0);
      textSize(16);
      text(roomsTYPE[i], 175+180*i, 50);
    }


    textSize(16);
    fill(200, 250, 0);
    text("CLICK YOUR MOUSE ON ANY OF THE ABOVE ROOM TYPES", 150, 90);
    text("TO SEE THE HINTON DIAGRAM", 250, 110);
  }
  if (arrayVAL == null)
  {
    for (int i=0;i<3;i+=1)
    {
      if (i==0)
      {
        arrayVAL = loadBytes("state_kitchen.txt");
      }
      else if (i==1)
      {
        arrayVAL = loadBytes("state_bedroom.txt");
      }
      else if (i==2)
      {
        arrayVAL = loadBytes("state_office.txt");
      }

      tempARR = new float[1600];
      int count=0;
      for (int j=0;j<arrayVAL.length;j+=1)
      {
        if (arrayVAL[j]==118 || arrayVAL[j]==100 || arrayVAL[j]==46)
        {
          switch(arrayVAL[j])
          {
          case 118:
            tempARR[count] = 2.5;
            break;
          case 100:
            tempARR[count] = 1;
            break;
          case 46:
            tempARR[count] = 0;
            break;
          }
          count+=1;
        }
      }
      for (int out=0;out<40;out+=1)
      {
        for (int in=0;in<40;in+=1)
        {
          switch(i)
          {
          case 0:
            kitchenSTATES[out][in] = tempARR[40*out+in];
            break;
          case 1:
            bedroomSTATES[out][in] = tempARR[40*out+in];
            break;
          case 2:
            officeSTATES[out][in] = tempARR[40*out+in];
            break;
          }
        }
      }
    }
  }
  // To show the descriptor list .. 
  textSize(16);
  fill(200, 250, 0);
  text("FOLLOWING IS A LIST OF DESCRIPTORS USED TO TRAIN THE MODEL", 120, 160);
  text("AND DESCRIBE ABOVE ROOM TYPES", 240, 180);
  //this part deals with the display of descriptors
  fill(255);
  rect(50, 200, 700, 170);
  for (int j=0;j<5;j+=1)
  {
    for (int i=0;i<8;i+=1)
    {
      textSize(13);
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
  textSize(16);
  text("Click here to train the model", 290, 440);
  //
  //this part writes about the clicking and seeing the state of the descriptors  .. 
  fill(255);
  rect(265, 510, 260, 50);
  fill(0);
  rect(270, 515, 250, 40);
  fill(200, 200, 0);
  textSize(16);
  text("Click here for descriptors state", 275, 540);
}


//EVENT HANDLERS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void mouseClicked()
{ 
  if (stage==1 && mouseY>30 && mouseY<60)
  {
    for (int i=0;i<3;i+=1)
    {
      if (mouseX>160+180*i && mouseX<260+180*i)
      {
        initFL[i]=true;
        valHINTON = i+1;
        //loadHINTONval(valHINTON);
        fill(255);
      }
    }
  }
  else if (stage == 1 && mouseY>415 && mouseY<455 && mouseX>270 && mouseX<520)
  {
    stage =3;
    trainBACK();
  }
  else if (stage == 1 && mouseY>515 && mouseY<555 && mouseX>270 && mouseX<520)
  {
    stage = 4;
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
      if (mark[num]!=1)
      {
        mark[num] = 1;
      }
      else
      {
        mark[num] = 0;
      }
    }
    // if CLICKED after choosing the descriptors
    else if (mouseX>610 && mouseX<680 && mouseY>420 && mouseY<450 && choice == true)
    {

      lockVALUES();
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
  }
  //Following is the code for the part when descriptors are being shown.. 
  else if (stage ==4)
  {
    if (choice==false && mouseY>30 && mouseY<60)
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
    else if (mouseX>610 && mouseX<680 && mouseY>470 && mouseY<500 && choice == true)
    {
      stage=1;
      choice=false;
    }
  }
}



//FUNCTIONS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//void loadHINTONval(int roomNO)
//{}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// load tempARR to roomtypeSTATES array and then read from there../
//void changetempARRtoroomtypeARR(int roomNO)
//{
//if (roomNO==1)  {    for (int i=0;i<40;i+=1)    {      for (int j=0;j<40;j+=1)      {        kitchenSTATES[i][j] = tempARR[40*i+j];      }    }  }
//else if (roomNO==2)  {    for (int i=0;i<40;i+=1)    {      for (int j=0;j<40;j+=1)      {        officeSTATES[i][j] = tempARR[40*i+j];      }    }  }
// else if (roomNO==3)  {    for (int i=0;i<40;i+=1)    {      for (int j=0;j<40;j+=1)      {        bedroomSTATES[i][j] = tempARR[40*i+j];      }    }  }
//}
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
  if (cc==1)
  {
    temp=kitchenSTATES;
  }
  else if (cc==2)
  {
    temp=bedroomSTATES;
  }
  else if (cc==3)
  {
    temp=officeSTATES;
  }
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
          if (tempARRh[(40*t)+dd] == 0)
          {
            fill(200);
          }
          else if (tempARRh[(40*t)+dd] >0 && tempARRh[(40*t)+dd] <=4)
          {
            fill(100);
          }
          else if (tempARRh[(40*t)+dd]>4)
          {
            fill(0);
          }   
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
  switch(ccd)
  {
  case 1:
    for (int i=0;i<40;i+=1)
    {
      for (int j=0;j<40;j+=1)
      {
        tempARR[40*i+j] = kitchenSTATES[i][j];
      }
    }
    break;
  case 2:
    for (int i=0;i<40;i+=1)
    {
      for (int j=0;j<40;j+=1)
      {
        tempARR[40*i+j] = bedroomSTATES[i][j];
      }
    }
    break;
  case 3:
    for (int i=0;i<40;i+=1)
    {
      for (int j=0;j<40;j+=1)
      {
        tempARR[40*i+j] = officeSTATES[i][j];
      }
    }
    break;
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
            if (tempARR[(40*t)+cc] ==0)
            {
              fill(200);
            }
            else if (tempARR[(40*t)+cc] > 0 && tempARR[(40*t)+cc] < 4)
            {
              fill(100);
            }
            else if (tempARR[(40*t)+cc]>=4)
            {
              fill(0);
            }   
            rect(275+in*30+2, 495+18*out+2, 26, 14);
          }
        }
        noStroke();
        break;
      }
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
    rect(0, 70, 800, 530);
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
    // printing the descriptor names within the boundries in yesllow box..
    fill(0);
    textSize(12);
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
      textSize(16);
      text("Click on any of the above room types to train the model for", 40, 90);
    }
    //when you click the room type to be trained for
    else
    {
      textSize(16);
      text("Click on the following descriptors to train for - "+roomsTYPE[choiceNum-1], 40, 90);
      text("Click again to deselect the descriptor", 40, 270);
      //the click button after descriptors have been selected
      rect(610, 420, 80, 30);
      rect(612, 422, 76, 26);
      text("for submitting and going back", 540, 470);
      fill(0);
      textSize(16);
      text("CLICK", 625, 442);
      text("CLICK", 626, 442);      
      //the black box containing the name of the descriptors.
      fill(0);
      rect(30, 300, 370, 250);
      fill(255);
      textSize(16);
      text("THE DESCRIPTORS FOR "+roomsTYPE[choiceNum-1]+" ARE --", 60, 340);
      //text(roomsTYPE[choiceNum-1]+" ARE --",80,360);
      textSize(12);
      int j=0;
      int j2 = 0;
      for (int i=0; i<40;i+=1)
      {
        if (mark[i] ==1)
        {
          if (j>12)
          {
            j2 += 1;
            j=0;
          }
          text(Names[i], 60+(100*j2), 360+15*j);
          j+=1;
        }
      }
      for (int i=0;i<40;i++)
      {
        if (mark[i]==1)
        {
          fill(0, 0, 220);
          rect(33+(i%8)*90, 105+(i/8)*30, 80, 20);
          fill(205, 255, 0); 
          text(Names[i], 40+(i%8)*90, 120+(i/8)*30);
        }
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
  countITER[choiceNum-1]=countITER[choiceNum-1]+1;

  if (choiceNum==1)
  {
    for (int i=0;i<40;i+=1)
    {
      roomTYPE1[i] = roomTYPE1[i]+(mark[i]/5);
    }
  }
  else if (choiceNum==2)
  {
    for (int i=0;i<40;i+=1)
    {
      roomTYPE2[i] = roomTYPE2[i]+(mark[i]/5);
    }
  }
  else if (choiceNum==3)
  {
    for (int i=0;i<40;i+=1)
    {
      roomTYPE3[i] = roomTYPE3[i]+(mark[i]/5);
    }
  }

  for (int i=0;i<40;i+=1)
  {
    mark[i]=0;
  }
  calcPROB();
}    


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculates the probability matrix to be used in the display of Hinton.. countITER[3] kitchenSTATES officeSTATES  bedroomSTATES choiceNum
void calcPROB()
{
  //For Kitchen
  if (countITER[0]!=0)
  {
    for (int i=0;i<40;i+=1)
    {
      for (int j=0;j<40;j+=1)
      {
        float p1 = 1;
        float p2 = 1;
        float p3 = 1;
        float p4 = 1;         
        float te = 0;

        if (roomTYPE1[i]==0 && roomTYPE1[j]!=0)
        {
          p1 = roomTYPE1[j]/countITER[0];
        }
        if (roomTYPE1[j]==0 && roomTYPE1[i]!=0)
        {
          p2 = roomTYPE1[i]/countITER[0];
        }
        if (roomTYPE1[i]==0 && roomTYPE1[j]==0)
        {
          p3 = 1;
        }
        if (roomTYPE1[i]!=0 && roomTYPE1[j]!=0)
        {
          if (roomTYPE1[i]>=roomTYPE1[j])
          {
            te = roomTYPE1[j];
          }
          else
          {
            te = roomTYPE1[i];
          }
          p4 = te/countITER[0];
        }

        float wij = (p1*p2)/(p3*p4);
        wij = -log(wij);
        kitchenSTATES[i][j] = kitchenSTATES[i][j]+wij;
      }
    }
  }
  else if (countITER[1]!=0)
  {
    for (int i=0;i<40;i+=1)
    {
      for (int j=0;j<40;j+=1)
      {
        float p1 = 1;
        float p2 = 1;
        float p3 = 1;
        float p4 = 1;         
        float te = 0;

        if (roomTYPE2[i]==0 && roomTYPE2[j]!=0)
        {
          p1 = roomTYPE2[j]/countITER[1];
        }
        if (roomTYPE2[j]==0 && roomTYPE2[i]!=0)
        {
          p2 = roomTYPE2[i]/countITER[1];
        }
        if (roomTYPE2[i]==0 && roomTYPE2[j]==0)
        {
          p3 = 1;
        }
        if (roomTYPE2[i]!=0 && roomTYPE2[j]!=0)
        {
          if (roomTYPE2[i]>=roomTYPE2[j])
          {
            te = roomTYPE2[j];
          }
          else
          {
            te = roomTYPE2[i];
          }
          p4 = te/countITER[1];
        }

        float wij = (p1*p2)/(p3*p4);
        wij = -log(wij);
        bedroomSTATES[i][j] = bedroomSTATES[i][j]+wij;
      }
    }
  }
  else if (countITER[2]!=0)
  {
    for (int i=0;i<40;i+=1)
    {
      for (int j=0;j<40;j+=1)
      {
        float p1 = 1;
        float p2 = 1;
        float p3 = 1;
        float p4 = 1;         
        float te = 0;

        if (roomTYPE3[i]==0 && roomTYPE3[j]!=0)
        {
          p1 = roomTYPE3[j]/countITER[2];
        }
        if (roomTYPE3[j]==0 && roomTYPE3[i]!=0)
        {
          p2 = roomTYPE3[i]/countITER[2];
        }
        if (roomTYPE3[i]==0 && roomTYPE3[j]==0)
        {
          p3 = 1;
        }
        if (roomTYPE3[i]!=0 && roomTYPE3[j]!=0)
        {
          if (roomTYPE3[i]>=roomTYPE3[j])
          {
            te = roomTYPE3[j];
          }
          else
          {
            te = roomTYPE3[i];
          }
          p4 = te/countITER[2];
        }

        float wij = (p1*p2)/(p3*p4);
        wij = -log(wij);
        officeSTATES[i][j] = officeSTATES[i][j]+wij;
      }
    }
  }
  else
  {
    for (int i=0;i<40;i+=1)
    {
      for (int j=0;j<40;j+=1)
      {
        kitchenSTATES[i][j] = kitchenSTATES[i][j]+0;
        bedroomSTATES[i][j] = bedroomSTATES[i][j]+0;
        officeSTATES[i][j] = officeSTATES[i][j]+0;
      }
    }
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This part is to display the state of the descriptors after they are selected for the room types..
void viewBACK()
{
  float[][] temp = new float[40][40];  
  float[] tempD = new float[40];
  if (stage==4)
  {
    fill(40);
    rect(0, 70, 800, 530);
    textSize(16);
    if (choice!=true)
    {
      fill(255);
      textSize(16);
      text("Click on any of the above room to view descriptor states.", 40, 90);
    }
    else  
    {
      fill(255);
      textSize(16);
      text("Click on any other room to view their descriptor states.", 40, 90);
      if (choiceNum==1)
      {
        temp = kitchenSTATES;
      }
      else if (choiceNum==2)
      {
        temp = officeSTATES;
      }
      else if (choiceNum==3)
      {
        temp = bedroomSTATES;
      }

      for (int i=0;i<40;i+=1)
      {
        tempD[i] = temp[i][i];
      }

      for (int i=0;i<20;i+=1)
      {
        fill(255);
        textSize(16);
        text(Names[i], 10, 150+15*i);
        text(tempD[i], 110, 150+15*i);
      }
      for (int i=20;i<40;i+=1)
      {
        fill(255);
        textSize(16);
        text(Names[i], 410, 150+15*(i-20));
        text(tempD[i], 530, 150+15*(i-20));
      }
      rect(610, 470, 80, 30);
      rect(612, 472, 76, 26);
      text("for going back", 540, 520);
      fill(0);
      textSize(16);
      text("CLICK", 625, 492);
      text("CLICK", 626, 492);
    }
  }
}

