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
PFont myFont;
PImage planet; // background tree (does not work with Chrome)

Flower[] population = new Flower[6];
Flower[] matingPool = new Flower[0];
Branch[] tree;
Flower refFlower;
Flower thisFlower;
Rectangle r;

float[] DNA = new float[15];
float[] gen1 = new float[15];
float[] gen2 = new float[15];
float[] momgenes, dadgenes;
float[] child= new float[15];
int score, totalScore;
int n;
int generations;
int angle;
boolean scr=true;
boolean drw=true;
float mutationRate = 0.15; // A pretty high mutation rate here, our population is rather small we need to enforce floatiety
// Create a population with a target phrase, mutation rate, and population max

void setup() {
  size(2400, 1600);
  colorMode(RGB, 1.0, 1.0, 1.0, 1.0);
  myFont = createFont("arial.ttf", 18); 
  textFont(myFont); 
  textAlign(LEFT);
  planet = loadImage("planet.jpg");
  DNA = makeDNA();
  refFlower = new Flower(DNA, 1200, 800);
  for (int i=0; i<6; i++) {
    DNA = makeDNA();
    population[i] = new Flower(DNA, 200+400*i, 200);
  }

  // two buttons for switching between show matepool and next generation

  cp5 = new ControlP5(this);

  cp5.addButton("Show_Tree")
    .setPosition(10, 1200)
      .setSize(300, 150)

        ;

  cp5.addButton("Next_Generation")
    .setPosition(10, 1400)
      .setSize(300, 150)
        ;
        
  cp5.addButton("Reset")
    .setPosition(10, 1000)
      .setSize(300, 150)
      ;

} 


void draw() {

  if (scr) { 
    background(255, 255, 255);
    refFlower.makeVar();
    thisFlower=refFlower;
    scoreDNA();
    refFlower.display();
    for (int i=0; i<6; i++) {
      thisFlower=population[i];
      scoreDNA();
      population[i].makeVar();
      population[i].display();
      population[i].rollover(mouseX, mouseY);
    }

    textSize(26);
    textAlign(LEFT);
    text("You can rate the flowers you like and give them a number ", 320, 1250);
    text("until 50 by putting your finger on the flower. ", 320, 1280);
    text("After that, push this button.", 320, 1310);
    textSize(32);
    text ("RESET", 320, 1100);
    text("Generation " + generations, 10, 500);
    
    textAlign(CENTER);
    text("Try to make a flower like this one (score>90)", 1200, 650);
    
  } else {

    background(150);
    image(planet, 0, 0, 2400, 1600); 
    textSize(26);
    textAlign(LEFT);
    text("Wait till the tree is ready. ", 320, 1450);
    text("Then push this button", 320, 1480);
    text("A new generation flowers shows", 320, 1510);
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

    if (tree[i].timeToBranch()&&(drw)) {
      angle = (floor(random(70, 50)));
      tree = (Branch[])append(tree, tree[i].branch(angle)); // Add one going right, angle randomly between 50,30

      angle = (floor(random(-70, -50)));
      tree = (Branch[])append(tree, tree[i].branch(angle));// add one going left, angle randomly;

      angle = (floor(random(20, 40)));
      tree = (Branch[])append(tree, tree[i].branch(angle));// Add one going right, angle randomly between 50,30

      angle = (floor(random(-20, -40)));
      tree = (Branch[])append(tree, tree[i].branch(angle)); // Add one going right, angle randomly between 50,30

      i=-1;
    }
  }
  while (tree.length > matingPool.length) {
    tree = (Branch[])shorten(tree);
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
  // Based on fitness, each member will get added to the mating pool a certain number 66666
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
    
  }
};
void drawFlower() {
  for (int j = 0; j < matingPool.length; j++) {
    //draw the flowers in the matepool
    float[] DNA = matingPool[j].getDNA();
    int x = int(tree[j].end.x);
    int y = int (tree[j].end.y);
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

void scoreDNA(){
  totalScore=100;
  gen1 = refFlower.getDNA();
  gen2 = thisFlower.getDNA();
  for(int i=0; i<15; i++){
    score = floor(Math.abs(gen1[i]-gen2[i])*10);
    totalScore=totalScore -score;
     }
    }
    
  

void Show_Tree() { 
  scr=false;
  nextTree();
};
void Next_Generation() { //<>//
  reproduction();
  generations++;
  drw=true;
  scr=true;
};

void Reset(){
  noLoop();
  generations=0;
  drw=true;
  scr=true;
  DNA = makeDNA();
  refFlower = new Flower(DNA, 1200, 800);
  for (int i=0; i<6; i++) {
    DNA = makeDNA();
    population[i] = new Flower(DNA, 200+400*i, 200);
    }
  loop();
}
