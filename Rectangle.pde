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

  boolean contains(int px, int py) {
    return (px > x && px < x + width  && py > y && py < y + height);
  }
}