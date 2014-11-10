// THIS PART IS INITIALIZING PART
//AND THIS SHOULD NOT BE CALLED ANYWHERE

float[] cenA= new float[24];
nodes[] nodePOOL = new nodes[12];
int[][] weightMAT = new int[12][12];
boolean flag=false;
boolean flagC=false;
int value = 0;
int posX=125;
//int posY=553;
int posY=495;
Vector nodesVEC = new Vector();
class nodes
{
  String nameOBJ;
  float output;
  float extIN;
  boolean b = true;
  float xCoordO, yCoordO;

  nodes(float x, float y, String s1)
  {
    xCoordO = x;
    yCoordO = y;
    nameOBJ = s1;
  }
}
class weightSAVE
{
  int value;
  int[][] weightM=new int[12][12];
}
// THIS TAKES CARE OF THE FRAMEWORK DEVELOPED AND THEN FUNCTIONS BEING CALLED REGULARLY

void setup()
{
  size(900, 670);
  background(30);
//  frameRate(10);
  cursor(CROSS);
  textSize(40);
  fill(255);
  //  text("WELCOME", 300, 50);
  textSize(13);
  fill(155, 70, 0);
  text("To Train The Network Press - 'K' for Kitchen, 'B' for Bedroom and 'O' for Office", 100, 40);
  textSize(13);
  fill(155, 70, 0);
  text("Press 'D' when training is over", 610, 40);
  textSize(15);
  fill(255);
  text("Click on the circles to draw associations", 140, 20);
  textSize(12);
  fill(255);
  text("Left click for positive association and right for negative", 440, 20);

  int[][] weightMAT = new int[10][10];
  posX=125;
  posY=493;

  fill(255);
  text("ITERATIONS AND STATE OF THE NETWORK", 25, 475);
  text("REFRIGERATOR", 10, 504);
  text("WASHINGMACHINE", 10, 517);
  text("GRINDER", 10, 530);
  text("WALL-CLOCK", 10, 543);
  text("ROOF", 10, 556);
  text("WINDOW", 10, 569);
  text("COMPUTER", 10, 582);
  text("TABLE-LAMP", 10, 595);
  text("WALLS", 10, 608);
  text("SOFA", 10, 621);
  text("WATER-JUG", 10, 634);
  text("TYPEWRITER", 10, 647);

  createBACK();
  setWeightMAT();
  if (flagC==true)
  {
    drwRES();
  }
}

void draw()
{
}
void loop()
{
  //delay(5);
  size(900, 670);
  background(30);
  cursor(CROSS);
  textSize(40);
  fill(255);
  //text("WELCOME", 300, 50);
  textSize(13);
  fill(155, 70, 0);
  text("To Train The Network Press - 'K' for Kitchen, 'B' for Bedroom and 'O' for Office", 100, 40);
  textSize(13);
  fill(155, 70, 0);
  text("Press 'D' when training is over", 610, 40);
  textSize(15);
  fill(255);
  text("Click on the circles to draw associations", 140, 20);
  textSize(12);
  fill(255);
  text("Left click for positive association and right for negative", 440, 20);

  text("ITERATIONS AND STATE OF THE NETWORK", 25, 475);
  text("REFRIGERATOR", 10, 504);
  text("WASHINGMACHINE", 10, 517);
  text("GRINDER", 10, 530);
  text("WALL-CLOCK", 10, 543);
  text("ROOF", 10, 556);
  text("WINDOW", 10, 569);
  text("COMPUTER", 10, 582);
  text("TABLE-LAMP", 10, 595);
  text("WALLS", 10, 608);
  text("SOFA", 10, 621);
  text("WATER-JUG", 10, 634);
  text("TYPEWRITER", 10, 647);

  createBACK();
  drwRES();

  if (flag==true && value ==1)
  {
    textSize(16);
    fill(155, 255, 0);
    text("Training The Network For Kitchen", 280, 60);
  }
  else if (flag==true && value==2)
  {
    textSize(16);
    fill(155, 255, 0);
    text("Training The Network For Bedroom", 280, 60);
  }
  else if (flag==true && value==3)
  {
    textSize(16);
    fill(155, 255, 0);
    text("Training The Network For Office", 280, 60);
  }
  else if (value==4)
  {
    textSize(16);
    fill(155, 255, 0);
    text("You Have Completed Training The Network", 240, 60);
    text("To train again press 'A'", 320, 75);
    showTRAINEDmodel();
  }
  else if (flag==true)
  {
    textSize(16);
    fill(155, 255, 0);
    text("Please Press Appropriate Button", 280, 60);
  }
}

void mouseMoved()
{
  float mX, mY;
  mX = mouseX;
  mY = mouseY;
  //delay(5);
  for (int moveCount=0;moveCount<12; moveCount++)
  {
    if (mouseX>nodePOOL[moveCount].xCoordO-15 && mouseX<nodePOOL[moveCount].xCoordO+15 && mouseY>nodePOOL[moveCount].yCoordO-15 && mouseY<nodePOOL[moveCount].yCoordO+15)
    {
      markLines(moveCount);
      break;
    }
    else
    {
      loop();
    }
  }
}

void mouseClicked()
{
  if (flag==true)
  {
    for (int moveCount=0;moveCount<12; moveCount++)
    {
      if (mouseX>nodePOOL[moveCount].xCoordO-15 && mouseX<nodePOOL[moveCount].xCoordO+15 && mouseY>nodePOOL[moveCount].yCoordO-15 && mouseY<nodePOOL[moveCount].yCoordO+15)
      {
        flagC = true;
        if (mouseButton==LEFT)
        {
          posX =posX+13;
          stroke(255);
          fill(215, 160, 0);
          ellipse(nodePOOL[moveCount].xCoordO, nodePOOL[moveCount].yCoordO, 20, 20);
          noStroke();
          for (int c=0;c<12;c++)
          {
            weightMAT[c][moveCount] = weightMAT[c][moveCount]+4;
          }
          for (int cc=0;cc<12;cc++)
          {
            if (weightMAT[moveCount][cc]>3)
            {
              weightMAT[moveCount][cc] = weightMAT[moveCount][cc]+2;
            }
          }
          calculateRES();
          drwRES();
          markLines(moveCount);
        }
        else if (mouseButton==RIGHT)
        {
          stroke(255);
          fill(0, 160, 215);
          ellipse(nodePOOL[moveCount].xCoordO, nodePOOL[moveCount].yCoordO, 20, 20);
          noStroke();
          for (int cc=0;cc<12;cc++)
          {
            if (weightMAT[moveCount][cc]>1)
            {
              weightMAT[moveCount][cc] = weightMAT[moveCount][cc]-4;
            }
          }
        } 

        break;
      }
    }
  }
}

void drwRES()
{

  int[] a = new int[nodesVEC.size()];
  for (int g=0;g<nodesVEC.size();g++)
  {
    a[g] = (Integer)nodesVEC.get(g);
  }

  if (flag==true && flagC==true)
  {
    int cal = (posX-112)/13;
    for (int n=0;n<cal-1;n++)
    {
      for (int y=0;y<12;y++)
      {
        stroke(255);
        fill(a[n*12+y]);
        rect(125+13*n, posY+13*y, 10, 10);
        noStroke();
      }
    }
  }
}

void calculateRES()
{
  int total=0;
  float score = 0;
  for (int outCount=0;outCount<12;outCount++)
  { 
    total=0;
    for (int inCount=0;inCount<12;inCount++)
    {
      total = total+weightMAT[inCount][outCount];
    }
    // System.out.println("-->C="+outCount+"-->Total="+total);
    score = total;
    if (score<0)
    {
      //System.out.println("SCORE >"+score);
      nodesVEC.add(0);
    }
    else if (score<10)
    {
      //System.out.println("SCORE >"+score);
      nodesVEC.add(0);
    }
    else if (score<60)
    {
      //System.out.println("SCORE >"+score);
      nodesVEC.add(50);
    }
    else if (score<100)
    {
      //System.out.println("SCORE >"+score);
      nodesVEC.add(100);
    }
    else if (score<150)
    {
      //System.out.println("SCORE >"+score);
      nodesVEC.add(150);
    }
    else if (score<200)
    {
      //System.out.println("SCORE >"+score);
      nodesVEC.add(200);
    }
    else
    {
      //System.out.println("SCORE >"+score);
      nodesVEC.add(250);
    }
  }
}


void clampNODE(int v)
{
  if (v==1)
  {
    for (int i=0;i<12;i++)
    {
      weightMAT[i][0] = 100;
    }
  }
  if (v==2)
  {
    for (int i=0;i<12;i++)
    {
      weightMAT[i][9] = 100;
    }
  }
  if (v==3)
  {
    for (int i=0;i<12;i++)
    {
      weightMAT[i][11] = 100;
    }
  }
}

void keyPressed()
{ 
  if (key=='K' || key=='k')
  {
    flag=true;
    value =1;
    clampNODE(value);
    loop();
  }
  else if (key=='B' || key=='b')
  {
    flag=true;
    value =2;
    clampNODE(value);
    loop();
  }
  else if (key=='O' || key=='o')
  {
    flag=true;
    value =3;
    clampNODE(value);
    loop();
  }
  else if (key=='D' || key=='d')
  {
    value =4;
    if (flag=true) {
      flag=false;
    }
    loop();
    showTRAINEDmodel();
  }
  else if (key=='A' || key=='a')
  {
    saveWEIGHTstate(value);
    value=0;
    setup();
  }
  else
  {
    flag=true;
    value = 37;
    loop();
  }
}

void saveWEIGHTstate(int val)
{
  weightSAVE wS = new weightSAVE();
  wS.value = val;
  for (int t=0;t<12;t++)
  {
    for (int n=0;n<12;n++)
    {
      wS.weightM[t][n] = weightMAT[t][n];
    }
  }
}

void showTRAINEDmodel()
{
  for (int ar=0;ar<12;ar++)
  {
    for (int dr=0;dr<12;dr++)
    {
      if (weightMAT[ar][dr]<4)
      {
        stroke(0, 255, 0, 255);
      }
      else
      {
        stroke(255, 0, 255);
      }
      line(nodePOOL[ar].xCoordO, nodePOOL[ar].yCoordO, nodePOOL[dr].xCoordO, nodePOOL[dr].yCoordO);
      noStroke();
    }
  }
}

void markLines(int c)
{
  for (int dr=0;dr<12;dr++)
  {
    if (weightMAT[c][dr]<4)
    {
      stroke(0, 255, 0, 255);
    }
    else
    {
      stroke(255, 0, 255);
    }
    line(nodePOOL[c].xCoordO, nodePOOL[c].yCoordO, nodePOOL[dr].xCoordO, nodePOOL[dr].yCoordO);
    noStroke();
  }
}

void addNAMES()
{
  for (int nc=0;nc<12;nc++)
  {
    fill(255);
    textSize(12);
    text(nodePOOL[nc].nameOBJ, nodePOOL[nc].xCoordO+20, nodePOOL[nc].yCoordO+20);
  }
}

void descriptorNAME()
{
  nodePOOL[0].nameOBJ = "REFRIGERATOR";
  nodePOOL[1].nameOBJ = "WASHING-MACHINE";
  nodePOOL[2].nameOBJ = "GRINDER";
  nodePOOL[3].nameOBJ = "WALL-CLOCK";
  nodePOOL[4].nameOBJ = "ROOF";
  nodePOOL[5].nameOBJ = "WINDOW";
  nodePOOL[6].nameOBJ = "COMPUTER";
  nodePOOL[7].nameOBJ = "TABLE-LAMP";
  nodePOOL[8].nameOBJ = "WALLS";
  nodePOOL[9].nameOBJ = "SOFA";
  nodePOOL[10].nameOBJ = "WATER-JUG";
  nodePOOL[11].nameOBJ = "TYPEWRITER";
}


//THIS FUNCTION HERE INTIALIZES THE WEIGHT MATRIX



void setWeightMAT()
{
  for (int init=0;init<12;init++)
  {
    for (int inti=0;inti<12;inti++)
    {
      if (inti==init)
      {
        weightMAT[init][inti] = 4;
      }
      else {
        weightMAT[init][inti] = 0;
      }
    }
  }
}

void createBACK()
{

  float thet, tcX, tcY;
  int rad = 180;
  int cenX = 400;
  int cenY = 270;

  //CREATING CIRCLES AND NODES AND ADDING THEM TO ARRAY
  for (int cir=0;cir<12;cir++)
  {
    thet = (TWO_PI/12)*cir;
    tcX = cenX+cos(thet)*rad;
    tcY = cenY+sin(thet)*rad;
    cenA[cir*2] = tcX;
    cenA[(cir*2)+1] = tcY;
    fill(153, 153, 136, 255);
    ellipse(tcX, tcY, 30, 30);
    nodes n = new nodes(tcX, tcY, "NAME");
    nodePOOL[cir] = n;
  }
  for (int out=0;out<12;out++)
  {
    for (int in=0;in<12;in++)
    {
      stroke(120, 80, 0);
      line(nodePOOL[out].xCoordO, nodePOOL[out].yCoordO, nodePOOL[in].xCoordO, nodePOOL[in].yCoordO);
      noStroke();
    }
  }

  fill(100, 100, 10);
  rect(120, 490, 770, 160);
  descriptorNAME();
  addNAMES();
}

