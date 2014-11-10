// THIS IS THE PART OF DECLARATION
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int[] countITER =new int[3];
int choiceNum=0;
boolean choice =false;
byte[] arrayVAL;
int[] tempARR;
String[] Names;
int roomTRACK;
String[] roomsTYPE = new String[3];
int stage = 1;
boolean descriptorCHECK = false;
int valHINTON=0;
boolean checked = false;
int[] mark= new int[40];
int[] roomTYPE1= new int[40];
int[] roomTYPE2= new int[40];
int[] roomTYPE3= new int[40];
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
        valHINTON = i+1;
        loadHINTONval(valHINTON);
        fill(255);
      }
    }
  }
  else if (stage == 1 && mouseY>415 && mouseY<455 && mouseX>270 && mouseX<520)
  {
    stage =3;
    trainBACK();
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
      stage=1;
      choice=false;
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
}



//FUNCTIONS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void loadHINTONval(int roomNO)
{

  if (roomNO==1)
  {
    arrayVAL = loadBytes("state_kitchen.txt");  
    tempARR = new int[1600];
    int count=0;
    for (int i=0;i<arrayVAL.length;i+=1)
    {
      if (arrayVAL[i]==118 || arrayVAL[i]==100 || arrayVAL[i]==46)
      {
        tempARR[count] = arrayVAL[i];
        count+=1;
      }
    }
  }
  else if (roomNO==2)
  {
    arrayVAL = loadBytes("state_bedroom.txt");
  }
  else if (roomNO==3)
  {
    arrayVAL = loadBytes("state_office.txt");
  }
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
          if (tempARR[(40*t)+dd] == 118)
          {
            fill(200);
          }
          else if (tempARR[(40*t)+dd] == 100)
          {
            fill(100);
          }
          else if (tempARR[(40*t)+dd] == 46)
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
  trackMOUSE();
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This handles the mouse movement while going through the Hinton Diagram screen ..
void trackMOUSE()
{

  int drawX = 20;
  int drawY = 125;
  fill(40);
  rect(270, 490, 250, 100);
  rect(0, 490, 300, 100);
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
            if (tempARR[(40*t)+cc] == 118)
            {
              fill(200);
            }
            else if (tempARR[(40*t)+cc] == 100)
            {
              fill(100);
            }
            else if (tempARR[(40*t)+cc] == 46)
            {
              fill(0);
            }   
            //System.out.print("!!=="+tempARR[(40*t)+cc]);
            rect(275+in*30+2, 495+18*out+2, 26, 14);
            //noStroke();
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
    fill(40);
    rect(0, 70, 800, 530);

    fill(200, 150, 0);
    rect(30, 100, 730, 150);
    fill(255);
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
      text("THE DESCRIPTORS FOR"+roomsTYPE[choiceNum-1]+" ARE --", 60, 340);
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
  countITER[choiceNum-1]=+1;
  choice = false;

  if (choiceNum==1)
  {
    for (int i=0;i<40;i+=1)
    {
      roomTYPE1[i] = roomTYPE1[i]+mark[i];
    }
  }
  else if (choiceNum==2)
  {
    for (int i=0;i<40;i+=1)
    {
      roomTYPE2[i] = roomTYPE2[i]+mark[i];
    }
  }
  else if (choiceNum==3)
  {
    for (int i=0;i<40;i+=1)
    {
      roomTYPE3[i] = roomTYPE3[i]+mark[i];
    }
  }

  for (int i=0;i<40;i+=1)
  {
    mark[i]=0;
  }
  calcPROB();
}    


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// calculates the probability matrix to be used in the display of Hinton.. countITER[3] kitchenSTATES officeSTATES  bedroomSTATES 
void calcPROB()
{
  //For Kitchen
  if (countITER[0]!=0)
  {
    for (int i=0;i<40;i+=1)
    {
      //System.out.print(roomTYPE1[i]);
      for (int j=0;j<40;j+=1)
      {
        float p1 = 1;
        float p2 = 1;
        float p3 = 1;
        float p4 = 1;         
        int te = 0;
        
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
          if (roomTYPE1[i]>roomTYPE1[j])
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
        kitchenSTATES[i][j] = wij;
      }
    }
  }
  else
  {
    for (int i=0;i<40;i+=1)
    {
      //System.out.print(roomTYPE1[i]);
      for (int j=0;j<40;j+=1)
      {
        kitchenSTATES[i][j] = 0;
      }
    }
  }
}


