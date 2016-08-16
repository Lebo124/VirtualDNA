

class Flower {
  boolean rolloverOn= false;
  private float[] c = new float[3];
  private float[] c1 = new float[3];
  private float[] c2 = new float[3];
  private float angle, d, s1, s2, s3, s4, e, f;
  private float fitness= 1;
  private int wh=400;
  private int x;
  private int y;
  Rectangle r;
  private float[] genes = new float[15];



  Flower(float[] genes_, int posx, int posy) {
    arrayCopy(genes_, genes);
    x = posx;
    y = posy;
    r = new Rectangle(x-wh/2, y-wh/2, wh, wh);
  }

  void makeVar() {

    for (int i=0; i < 3; i++) {
      c[i]   = genes[i]; 
      c1[i]  = genes[i+3];
      c2[i]  = genes[i+6];
    }
    angle        = map(genes[9], 0, 1, 40, 80);
    d            = map(genes[10], 0, 1, 150, 400);
    s1           = map(genes[11], 0, 1, 30, 20);
    s2           = map(genes[12], 0, 1, -25, 25);
    s3           = map(genes[13], 0, 1, -30, -12);
    s4           = map(genes[14], 0, 1, -14, -16);
    f = 1;
  }


  // make flower  with recursion

  void display() {

    if (d>15) {

      f++;
      if ( d > 120) {
        fill(c[0], c[1], c[2]);
      } else {
        fill(c1[0], c1[1], c1[2]);
      }
      pushMatrix();
      strokeWeight(1);
      stroke(0);
      translate (x, y);
      rotate(angle*f);
      e = map(d, 150, 400, 12, 18);

      bezier(0, 0, 50, 50, 50, 50, 20, 20);
      bezier(0, 0, s1*e, s2, s3*e, s4*e, 0, 0);
      bezier(0, 0, s2*e, s3*e, s4, s1, 0, 0);
      fill(c2[0], c2[1], c2[2]);
      ellipse(75, 75, 20, 20);        

      popMatrix();
      d =  d/2;
      display();
     }
    
    if (rolloverOn) {  //<>//
      fill(0, 0.10);
    } else { 
      noFill();
    }
    rectMode(CENTER);
    noStroke();
    rect(x, y, wh, wh);
    if (scr) {
      dispFit();
    }
  }

  void dispFit() {
   
    textAlign(CENTER);
    //println(fitness);
    fill(0.10);
    strokeWeight(2);  //<>//
    textSize(26);
    text("Score: " + totalScore, x, y+200);
    text("" + floor(fitness), x, y+250);
  } 



  float getFitness() {
    return fitness;
  }

  float[] getDNA() {
    return genes;
  }


  // Increment fitness if mouse is rolling over flower
  void rollover(int mx, int my) {

    if ((r).contains(mx, my)) {
      rolloverOn = true;
      fitness += 0.50;
      dispFit();
    } else {
      rolloverOn = false;
    }
    if (fitness>50) { // maximum fitness = 50
      fitness=50;
    }
  }
}
