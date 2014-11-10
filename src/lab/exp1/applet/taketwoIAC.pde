// IAC Ñ a "Processing" implementation
// axcleer@ulb.ac.be


boolean click = false;
boolean run = true;

int maxunits = 68;
int numunits = 0;
int Radius = 20;
int maxtimeSteps = 350;

float decay = 0.1;
float beta = 0.1;
float gamma = 0.1;
float estr = 0.4;
float actmax = 1.0;
float actmin = -1.0;
float actrest = -0.1;

int cycle = 0;
float gDelta = 0;
float maxgDelta = 0.001;

float[] history;
Unit[] Units;
float[][] Weights;
byte b[];

void setup()
{
  size(800, 600);
  smooth();
  noStroke();
  ellipseMode(CENTER_DIAMETER);

  cursor(CROSS);



  Units = new Unit[maxunits];
  numunits = 68;
  readNames();
  placeUnits();

  Weights = new float[maxunits][maxunits];
  readWeights();
  
  history = new float[maxtimeSteps];
}
void draw()
{
loop();
}
void loop() {
  background(30);
  smooth();
  noStroke();
  fill(153, 153, 136, 255);
  rect(0, 580, 800, 20);
  rect(0, 0, 800, 20);
  noSmooth();
  fill(255, 255, 255, 255);

  text("Interactive Activation v. 1.1 - click on units to activate, SPACE to pause, 'r' to reset", 10, 13);
  text("Cycle: ", 10, 595);
  text(cycle, 50, 595);
  text("Global Change: ", 100, 595);
  if ((gDelta < 0.0001) && (gDelta > 0)) {
    fill(0, 255, 0, 255);
  } else {
    fill(255, 255, 255, 255);
  }
  text(gDelta, 190, 595);
  smooth();
    plotgDelta(cycle);

  
  for (int i = 0; i < numunits; i++) {
    Units[i].display();
  }
  if (run == true) {
    for (int i = 0; i < numunits; i++) {
      Units[i].getnet();
    }
    for (int i = 0; i < numunits; i++) {
      Units[i].update(); 
    }
  }
    for (int i = 0; i < numunits; i++) {
      Units[i].interact();
 }
 if (run == true) {
   cycle++;
 }
}

void plotgDelta(int c) {
   if (run == true) {
     if (c > maxtimeSteps - 1) {
        c = maxtimeSteps - 1;
        for (int i = 0; i < maxtimeSteps - 1; i++) {
         history[i] = history[i + 1];
         }
      }
      //rescale
      if (gDelta > maxgDelta) {
        maxgDelta = gDelta;
      }
      history[c] = gDelta;
   }
   stroke(0, 255, 0, 255);
   for (int i = 0; i < maxtimeSteps - 1; i++) {
    line (250+i, 595, 250+i, (594 - (12*(history[i]/maxgDelta))));
   }
}
  
void readWeights() {
  byte b[] = loadBytes("network.txt");

  for (int i = 0; i < 68; i++) {
    for (int j = 0; j < 68; j++) {
      int a = b[(i * 69) + j] & 0xff;
    if (a == 46) {Weights[i][j] = 0.0;}
    if ((a == 104) || (a == 118)) {Weights[i][j] = -1.0;}
    if ((a == 100) || (a == 117)) {Weights[i][j] = 1.0;}
    }
  }
}

void readNames() {
  String Names[] = loadStrings("names.txt");
  for (int i = 0; i < numunits; i++) {
    //Units[i] = new Unit(i, Names[i], 20 + (i*60)%600, 20 + (i/10)*60);
    Units[i] = new Unit(i, Names[i], 20, 20);
  }
}

void placeUnits() {
  int r = 60;
  int cx =180;
  int cy = 400;
  float len = 0;
  int i = numunits - 1;
  int j = 0;
  int n = 0;
  int interval = Radius + 20;
  int angle;

  System.out.println("67"+"----"+Units[67].name);

  while (i >= 42) {
    len = 2 * PI * r; //circumference of a circle with radius r
    n = int(len/interval); //# of units I can put on the circle
    for (j = 0; ((j < n) && (i >= 0)); j++, i--) {
      if ((i == 40) || (i == 13) || (i == 10) || (i == 7) || (i == 4) || (i == 1)) {
        j +=1;
      }

      angle = 270 + int(j * (360/n));
      Units[i].posx = cx + int(cos(radians(angle)) * r);
      Units[i].posy = cy + int(sin(radians(angle)) * r);
    }
    r += 60;
  }
  
  cx = 550;
  r = 60;

  System.out.println(i+"----"+Units[i].name);

    while (i >= 14) {
    len = 2 * PI * r; //circumference of a circle with radius r
    n = int(len/interval); //# of units I can put on the circle
   
    for (j = 0; ((j < n) && (i >= 0)); j++, i--) {
      if (i==13){//((i == 40) || (i == 13) || (i == 10) || (i == 7) || (i == 4) || (i == 1)) {
        j +=1;
      }

      angle = 270 + int(j * (360/n));
      Units[i].posx = cx + int(cos(radians(angle)) * r);
      Units[i].posy = cy + int(sin(radians(angle)) * r);
    }
    
    r += 60;
  }
  
      Units[0].posx = 370; 
      Units[0].posy = 310;
      Units[1].posx = 370; 
      Units[1].posy = 510;
i = 13;

      for(int out=0;out<4;out+=1)
          {
            Units[i].posx = 60+out*200; 
            Units[i].posy = 180;
            Units[i-1].posx = 30+out*200; 
            Units[i-1].posy = 210;
            Units[i-2].posx = 90+out*200; 
            Units[i-2].posy = 210;
            i-=3;         
          }

}



void reset() {
  for (int i = 0; i < maxunits; i++) {
    Units[i].reset();
    cycle = 0;
  }
}

void mouseReleased() {
  click = true;
}


void keyReleased() {
if (key == ' ') {
  if (run == true) {
    run = false;
    } else {
      run = true;
    }
   } else if (key == 'r') {
     reset();
   }
}

class Unit {
  float extinput, excitation, inhibition, netinput, activation, q, deltaExc, deltaInh;
  int i, posx, posy;
  int radiusx, radiusy;
  boolean highlight;
  String name;
  Unit (int id, String s, int x, int y) {
    i = id;
    name = s;
    posx = x;
    posy = y;
    radiusx = Radius;
    radiusy = Radius;

    extinput = netinput = inhibition = excitation = 0.0;
    activation = actrest;
  }

  void display() {
    //strokeWeight(1);
    noStroke();
    if (extinput > 0) {
      //stroke(255, 255, 255);
      fill(0, 255, 0, 255);
    }
    else if (extinput < 0) {
      //stroke(255, 0, 0);
      fill(255, 0, 0, 255);
    }
    else if (extinput == 0) {
      fill(0, 0, 0, 0);
      //noStroke();
    }
    ellipse(posx, posy, radiusx+2, radiusy+2);
    if (deltaExc > 0) {
      fill(0, 255, 0, 100);
      ellipse(posx, posy, 2000*deltaExc, 2000*deltaExc);
      }
      else if (deltaInh < 0) {
      fill(255, 0, 0, 100);
      ellipse(posx, posy, 2000*abs(deltaInh), 2000*abs(deltaInh));
      }
    
    if (highlight) {
      fill(255, 255, 255, 200);
      ellipse(posx, posy, radiusx, radiusy); //highlight the unit itself
      
      stroke(255, 255, 255, 255);
      fill(0, 0, 0, 0);
      rect(20, 60, 112, 19);
      if (activation > 0) {
        fill (0, 255, 0, 128*activation);
      } else if (activation < 0) {
        fill (255, 0, 0, 128*abs(activation));
      }
      rect(20, 79, 112, 19);
          
      //line(20, 80, 142, 80);
      //line(20, 100, 142, 100);
      if (netinput > 0) {
        fill(0, 255, 0, 255*netinput);
      } else if (netinput < 0) {
        fill(255, 0, 0, 255*abs(netinput));
      } else {
        fill(0, 0, 0, 0);
      }
      rect(20, 98, 112, 19);
      
     // noStroke();
     // rect(20, 80, 120, 20);
      stroke(255, 255, 255, 255);
      fill(255, 255, 255, 255);
      noSmooth();
      text("Unit #", 25, 74);
      text(i, 60, 74);
      text("Activation: ", 25, 93);
      text("Net Input: ", 25, 112);
      text(name, 139, 74);
      text(activation, 139, 93);
      text(netinput, 139, 112);
      smooth();
      
    } else {
      fill(255, 153, 0, 80);
      ellipse(posx, posy, radiusx, radiusy);
    }
    if (activation > 0) {
      fill(255, 204, 0, 255);
    }
    else if (activation < 0) {
      fill(255, 0, 0, 255);
    }
    noStroke();
    ellipse(posx, posy, abs(activation)*radiusx, abs(activation)*radiusy);
    fill(255, 255, 255, 255);
    noSmooth();
    text(name, posx, posy + Radius);
    smooth();
    if (highlight) {
      for (int j = 0; j < maxunits; j++) {
        if (Weights[i][j] > 0) {
          strokeWeight(1);
          stroke(0, 255, 100, 255);
          //curve(posx, posy, 200, 200, 200, 200, Units[j].posx, Units[j].posy);
          line(posx, posy, Units[j].posx, Units[j].posy);
          strokeWeight(1);
        }
        else if (Weights[i][j] < 0) {
          strokeWeight(1);
          stroke(255, 0, 100, 255);
          //curve(posx, posy, 200, 200, 200, 200, Units[j].posx, Units[j].posy);
          line(posx, posy, Units[j].posx, Units[j].posy);
          strokeWeight(1);
        }
      }
    }
  }

  void getnet() {
    inhibition = excitation = 0.0;
    for (int j = 0; j < numunits; j++) {
      if (Units[j].activation > 0) {
        if (Weights[i][j] > 0) {
          q = Weights[i][j] * Units[j].activation;
          excitation += q;
          stroke(0, 255, 0, q*200);
          //curve(posx, posy, 200, 200, 200, 200, Units[j].posx, Units[j].posy);
        line(posx, posy, Units[j].posx, Units[j].posy);}
        else if (Weights[i][j] < 0) {
          q = Weights[i][j] * Units[j].activation;
          inhibition += q;
          stroke(255, 0, 0, abs(q)*200);
          //curve(posx, posy, 200, 200, 200, 200, Units[j].posx, Units[j].posy);
        line(posx, posy, Units[j].posx, Units[j].posy);}
      }
      netinput = (estr * extinput) + (beta * excitation) + (gamma * inhibition);
    //if (i == 60) {println(netinput);}
    }
  }

  void update() {
    gDelta = 0;
    if (netinput > 0) {
      deltaExc = (actmax - activation) * netinput - decay * (activation - actrest);
      activation += deltaExc;
      gDelta += abs(deltaExc);
    }
    else if (netinput < 0) {
      deltaInh = (activation - actmin) * netinput - decay * (activation - actrest);
      activation += deltaInh;
      gDelta += abs(deltaInh);
    }
  if(activation > actmax) {activation = actmax;}
  if(activation < actmin) {activation = actmin;}
  }

  void interact() {
    float disX = Units[i].posx - mouseX;
    float disY = Units[i].posy - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < Radius/2 ) {
      highlight = true;
      if(i<41)
    {
      if (click == true) {
      if (extinput == 0) {extinput = 1.0;}
      else if (extinput == 1.0) {extinput = 0.0;}
        click = false;
      }
      }
      else
      {
        click = false;
      }
    }
  else {highlight = false;}
    
  }
  
  void reset() {
    netinput = excitation = inhibition = extinput = deltaInh = deltaExc = 0;
    activation = actrest;
    for (int i = 0; i < maxtimeSteps; i++) {
      history[i] = 0;
    maxgDelta = 0.001;
    }
  }
}

