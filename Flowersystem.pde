// Leo Bode
// Kadenze : Code of Nature
// by Daniel Shiffman
// based on code by Daniel Shiffman.

// In this sketch you can give six different flowers 
// a fitness rate (max=50).
//After that by pressing "Show matepool" a tree is build
// with all the flowers in the matepool.
// Then you can switch to the next generation.
import controlP5.*;
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
float mutationRate = 0.15; // A pretty high mutation rate here, our population is rather small we need to enforce floatiety
// Create a population with a target phrase, mutation rate, and population max

void setup() {
  size(2400, 1600);
  colorMode(RGB, 1.0, 1.0, 1.0, 1.0);

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
    .setColorBackground(200)
    .setColorForeground(50)
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
        .setFont(createFont("arial",14))
          ;
} 


void draw() {

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
void nextTree() {
  selection();
  tree= new Branch[0];
  PVector ed = new PVector(width/2, height);
  PVector vl= new PVector(0, -6);
  Branch br =new Branch(ed, vl, 100);
  tree = (Branch[]) append(tree, br);
};



// Build the new tree. 
void makeTree() {
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



void selection() {
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

void reproduction() {
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

      if (random(1) < 0.15) {
        child[j] = random(0, 1);
      }
    }
    // Fill the new population with the new child
    population[i] = new Flower(child, 200+i*400, 200);
    generations++;
  }
};
void drawFlower() {
  for (int j = 0; j < matingPool.length; j++) {
    //draw the flowers in the matepool
    float[] DNA = matingPool[j].getDNA();
    // int k = floor(random(0, tree.length));
    int x = int(tree[j].end.x);
    int y = int(tree[j].end.y);
    Flower f = new Flower(DNA, x, y);
    f.makeVar();
    f.display();
  }
};

float[] makeDNA() {
  for (int i=0; i<15; i++) {
    DNA[i]= random(1);
  }
  return DNA;
};

void Show_Tree() { 
  scr=false;
  nextTree();
};
void Next_Generation() { //<>//
  reproduction();
  drw=true;
  scr=true;
 
};
