float[] c = new float[3];
float[] c1 = new float[3];
float[] c2 = new float[3];
float angle, d, s1, s2, s3, s4, e, f;
boolean rolloverOn = false;
float fitness=1;
int wh=200;

class Flower {
  private int x;
  private int y;
  private float[] genes;
  // Using java.awt.Rectangle (see: http://java.sun.com/j2se/1.4.2/docs/api/java/awt/Rectangle.html)


  Flower(float[] genes_, int posx, int posy) {
    genes = genes_;
    x = posx;
    y = posy;
  
  }
   void makeVar(){ 
   
    for (int i=0; i < 3; i++) {
    c[i]   = genes[i]; 
    c1[i]  = genes[i+3];
    c2[i]  = genes[i+6];
    }
    angle        = map(genes[9], 0, 1, 40, 80);
    d            = map(genes[10], 0, 1, 150, 400);
    s1           = map(genes[11], 0, 1, 15, 10);
    s2           = map(genes[12], 0, 1, -12, 12);
    s3           = map(genes[13], 0, 1, -15, -6);
    s4           = map(genes[14], 0, 1, -7, -8);
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
      translate (x, y);
      rotate(angle*f);
      e = map(d, 150, 400, 12, 18);

      bezier(0, 0, 50, 50, 50, 50, 20, 20);
      bezier(0, 0, s1*e, s2, s3*e, s4*e, 0, 0);
      bezier(0, 0, s2*e, s3*e, s4, s1, 0, 0);
      fill(c[0], c[1], c[2]);
      ellipse(50, 50, 10, 10);        

      popMatrix();
      d =  d/2;
      display();
    }
  


    strokeWeight(0); // dont want to see the rectangle
    stroke(0);
    if (rolloverOn) { 
      fill(0, 0.25);
    } else { 
      noFill();
    }
    rectMode(CENTER);
    rect(x, y, wh, wh);
    //popStyle();
    if (toggleValue) {
      dispFit();
   }
  }

  void dispFit() {
    //strokeWeight(2);
    textAlign(CENTER);
    //console.log(fitness)
    //if (rolloverOn) fill(50);
    //else fill(0.25);
    strokeWeight(1); 
    textSize(12);
    text("" + floor(fitness), x, y+150);
    strokeWeight(2);
  }


  float getFitness() {
    return fitness;
  }

  float[] getDNA() {
    return genes;
  }
  

  // Increment fitness if mouse is rolling over flower
 // void rollover(int mx, int my) {
  //  
  //  if ((r).contains(mx, my)) {
  //    rolloverOn = true;
   //   fitness += 0.25;
  //  } else {
  //    rolloverOn = false;
  //  }
  //  if (fitness>50) { // maximum fitness = 50
  //    fitness=50;
  //  }
 // }
}