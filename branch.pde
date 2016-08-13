

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

  void update() {
    //println(start, end);
    if (growing) {
      end.add(vel);
      //println(start, end);
    }
  }

  void render() {
    colorMode(RGB);
    strokeWeight(6);
    stroke(0, 200, 0);
    fill(100, 200, 0);
    triangle(start.x-15, start.y, start.x+15, start.y, end.x, end.y );

    // stroke(0, 0, 0);
  }
  // when timer = 0 new branches
  boolean timeToBranch() {

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

  Branch branch(int angle_) {
    angle = angle_;

    // What is my current heading
    float theta = vel.heading();
    // What is my current speed
    float m = vel.mag();
    // Turn me
    theta += radians(angle);
    // Look, polar coordinates to cartesian!!
    PVector newvel = new PVector(m * cos(theta), m * sin(theta));
    timerstart = timerstart/floor(random(1.5, 2.5));
    if (timerstart < 40) {
      timerstart=40;
    }
    // Return a new Branch
    Branch myBranch = new Branch (end, newvel, timerstart);
    return myBranch;
  }
}
