package processing.test.flowersystem;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Flowersystem extends PApplet {



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

  public void makeVar() {

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

  public void display() {

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
      fill(c[0], c[1], c[2]);
      ellipse(50, 50, 10, 10);        

      popMatrix();
      d =  d/2;
      display();
    }




    if (rolloverOn) {  //<>//
      fill(0, 0.10f);
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

  public void dispFit() {
   
    textAlign(CENTER);
    //println(fitness);
    fill(0.10f);
    strokeWeight(2);  //<>//
    textSize(18);
    text("" + floor(fitness), x, y+150);
  } 



  public float getFitness() {
    return fitness;
  }

  public float[] getDNA() {
    return genes;
  }


  // Increment fitness if mouse is rolling over flower
  public void rollover(int mx, int my) {

    if ((r).contains(mx, my)) {
      rolloverOn = true;
      fitness += 0.25f;
      dispFit();
    } else {
      rolloverOn = false;
    }
    if (fitness>50) { // maximum fitness = 50
      fitness=50;
    }
  }
}

// Leo Bode
// Kadenze : Code of Nature
// by Daniel Shiffman
// based on code by Daniel Shiffman.

// In this sketch you can give six different flowers 
// a fitness rate (max=50).
//After that by pressing "Show matepool" a tree is build
// with all the flowers in the matepool.
// Then you can switch to the next generation.

ControlP5 cp5;

PImage planet; // background tree (does not work with Chrome)

Flower[] population = new Flower[6];
Flower[] matingPool = new Flower[0];
Branch[] tree;

Rectangle r;

float[] DNA = new float[15];
float[] gen = new float[15];
float[] momgenes, dadgenes;
float[] partner;
float[] child= new float[15];
int n;
int generations;
int angle;
boolean scr=true;
boolean drw=true;
Textarea myInfo;
Textarea myInfo1;
float mutationRate = 0.15f; // A pretty high mutation rate here, our population is rather small we need to enforce floatiety
// Create a population with a target phrase, mutation rate, and population max

public void setup() {
 
  colorMode(RGB, 1.0f, 1.0f, 1.0f, 1.0f);

  planet = loadImage("planet.jpg");
  for (int i=0; i<6; i++) {
    DNA = makeDNA();
    population[i] = new Flower(DNA, 200+400*i, 200);
  }

  // two buttons for switching between show matepool and next generation

  cp5 = new ControlP5(this);
  // cp5.ControlFont(createFont("arial",18));
  cp5.addButton("Show_Tree")
    .setPosition(10, 1200)
      .setSize(300, 150)
        ;

  cp5.addButton("Next_Generation")
    .setPosition(10, 1400)
      .setSize(300, 150)
        // .setFont ("arial",18);
        ;

  cp5.addTextarea("myInfo")
    .setPosition(10, 550)
      ;

  cp5.addTextarea("myInfo1")
    .setPosition(200, 550)
      .setSize(500, 100)
        .setFont(createFont("arial", 14))
          ;
} 


public void draw() {

  if (scr){ 
    background(255, 255, 255);

    for (int i=0; i<6; i++) {
      population[i].makeVar();
      population[i].display();
      population[i].rollover(mouseX, mouseY);

      //myInfo.setText("Generation #:" + generations);
      //myInfo1.setColor(color(0, 0, 200));
      //myInfo1.setText("You can rate the flowers you like and give them a number until 50 by putting the mouse on the flower. After that, push the 'Show_Tree' button.");
    }
  } else {

    background(150);
    image(planet, 0, 0, 2400, 1600); 

    //myInfo.setText("");
    //myInfo1.setColor(color(0, 0, 0));
    //myInfo1.setText("If you are ready watching. Press next generation. The program will make a new generation out of the chosen flowers. It will mutate some genes. ");
    makeTree();
  }
};


// If the button is clicked, evolve new tree
public void nextTree() {
  selection();
  tree= new Branch[0];
  PVector ed = new PVector(width/2, height);
  PVector vl= new PVector(0, -6);
  Branch br =new Branch(ed, vl, 100);
  tree = (Branch[]) append(tree, br);
};



// Build the new tree. 
public void makeTree() {
  int i =0;

  for (i=0; i<tree.length; i++) {
    // Get the branch, update and draw it
    tree[i].update();
    tree[i].render();

    if (tree[i].timeToBranch() && (drw)) {
      angle = (floor(random(70, 50)));
      tree = (Branch[])append(tree, tree[i].branch(angle)); // Add one going right, angle randomly between 50,30
      if (tree.length < matingPool.length) {
        angle = (floor(random(-70, -50)));
        tree = (Branch[])append(tree, tree[i].branch(angle));// add one going left, angle randomly;
      }
      if (tree.length < matingPool.length) {
        angle = (floor(random(20, 40)));
        tree = (Branch[])append(tree, tree[i].branch(angle));// Add one going right, angle randomly between 50,30
      }
      if (tree.length <matingPool.length) {
        angle = (floor(random(-20, -40)));
        tree = (Branch[])append(tree, tree[i].branch(angle)); // Add one going right, angle randomly between 50,30
      }
      i=-1;
    }
  } 


  if (tree.length >= matingPool.length) {
    drawFlower();
    drw=false;
  }
};



public void selection() {
  matingPool = new Flower[0];

  //println("selection");
  // Calculate total fitness of whole population
  float record = 0;
  for (int i = 0; i < 6; i++) {
    if (population[i].getFitness() > record) {
      record = population[i].getFitness();
    }
  }
  //println("record "+ record);
  // Calculate fitness for each member of the population (scaled to value between 0 and 1)
  // Based on fitness, each member will get added to the mating pool a certain number of times
  // A higher fitness = more entries to mating pool = more likely to be picked as a parent
  // A lower fitness = fewer entries to mating pool = less likely to be picked as a parent
  for (int i = 0; i < 6; i++) { 
    float fitnessNormal = map(population[i].getFitness(), 0, record, 0, 1);
    //println(fitnessNormal);
    n = floor(fitnessNormal * 10);  // multiplier is low, because otherwise there are too many flowers to draw
    //println(n);
    for (int j = 0; j < n; j++) {
      matingPool= (Flower[]) append(matingPool, population[i]);
      //println(matingPool.length);
    }
  }
};

public void reproduction() {
  // Refill the population with children from the mating pool
  for (int i = 0; i < 6; i++) {
  
    // Sping the wheel of fortune to pick two parents
    int m = floor(random(matingPool.length));
    int d = floor(random(matingPool.length));
    // Pick two parents
    Flower mom = matingPool[m];
    Flower dad = matingPool[d];
    println(mom);
    // Get their genes
    momgenes = mom.getDNA();
    dadgenes = dad.getDNA();
    // Mate their genes

    for (int j  = 0; j < 15; j++) {
      if (j > 7) {
        child[j] = momgenes[j];
      } else {
        child[j] = dadgenes[j];
      }
      // Mutate their genes

      if (random(1) < 0.15f) {
        child[j] = random(0, 1);
      }
    }
    // Fill the new population with the new child
    population[i] = new Flower(child, 200+i*400, 200);
    generations++;
  }
};
public void drawFlower() {
  for (int j = 0; j < matingPool.length; j++) {
    //draw the flowers in the matepool
    float[] DNA = matingPool[j].getDNA();
    // int k = floor(random(0, tree.length));
    int x = PApplet.parseInt(tree[j].end.x);
    int y = PApplet.parseInt(tree[j].end.y);
    Flower f = new Flower(DNA, x, y);
    f.makeVar();
    f.display();
  }
};

public float[] makeDNA() {
  for (int i=0; i<15; i++) {
    DNA[i]= random(1);
  }
  return DNA;
};

public void Show_Tree() { 
  scr=false;
  nextTree();
};
public void Next_Generation() { //<>//
  reproduction();
  drw=true;
  scr=true;
 
};

// Used this code from Daniel Shiffman.

// Daniel Shiffman
// https://www.kadenze.com/courses/the-nature-of-code
// http://natureofcode.com/
// Session 5: Evolutionary Computing

// Re-implementing java.awt.Rectangle
// so JS mode works

class Rectangle {
  int x;
  int y;
  int width ;
  int height;

  Rectangle(int x_, int y_, int width_, int height_) {
    x = x_;
    y = y_;
    width = width_;
    height = height_;
  }

  public boolean contains(int px, int py) {
    return (px > x && px < x + width  && py > y && py < y + height);
  }
}


class Branch {
  PVector start;
  PVector end;
  PVector vel;
  float timerstart;
  float timer;
  boolean growing;



  Branch( PVector end_, PVector vel_, float n) {
    start= end_.get();
    end=end_.get();
    vel= vel_.get();
    timerstart = n;
    timer=timerstart;
    growing= true;
  }

  public void update() {
    //println(start, end);
    if (growing) {
      end.add(vel);
      //println(start, end);
    }
  }

  public void render() {
    colorMode(RGB);
    strokeWeight(6);
    stroke(0, 200, 0);
    fill(100, 200, 0);
    triangle(start.x-15, start.y, start.x+15, start.y, end.x, end.y );

    // stroke(0, 0, 0);
  }
  // when timer = 0 new branches
  public boolean timeToBranch() {

    //println(timer);
    if (timer <= 0 && growing) {
      growing = false;
      // println("return true");
      return true;
    } else {
      timer--;
      return false;
    }
  }

  public Branch branch(int angle_) {
    angle = angle_;

    // What is my current heading
    float theta = vel.heading();
    // What is my current speed
    float m = vel.mag();
    // Turn me
    theta += radians(angle);
    // Look, polar coordinates to cartesian!!
    PVector newvel = new PVector(m * cos(theta), m * sin(theta));
    timerstart = timerstart/floor(random(1.5f, 2.5f));
    if (timerstart < 40) {
      timerstart=40;
    }
    // Return a new Branch
    Branch myBranch = new Branch (end, newvel, timerstart);
    return myBranch;
  }
}


  public int sketchWidth() { return 2400; }
  public int sketchHeight() { return 1600; }
}
