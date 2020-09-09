final class Particle {
 PVector position, velocity, acceleration, gravity;
 int width, height, colour;
 private float mass;
 boolean split;
 final float DAMPING;
 
 Particle(int x, int y, int width, int height, int wave, boolean split, float damping) {
    this.position = new PVector(x, y);
    this.width = width - width / 8;
    this.height = height;
    this.split = split;
    
    int maxSpeedRestrict = 600 - (wave * 20);
    if (maxSpeedRestrict < 200) {
      maxSpeedRestrict = 200;
    }
    int speed = (int)random(200, maxSpeedRestrict);
    this.velocity = new PVector(random(-displayWidth, displayWidth) / speed, displayHeight / speed);
    this.acceleration = new PVector(0, 0);
    
    this.DAMPING = damping;
    this.mass = random(0.005f, 0.009f);
    if (mass >= 0.005 && mass < 0.006) {
      this.colour = 255;
    }
    else if (mass >= 0.006 && mass < 0.007) {
      this.colour = 180;
    }
    else if (mass >= 0.007 && mass < 0.008) {
      this.colour = 120;
    }
    else {
      this.colour = 60; 
    }
    this.gravity = new PVector(0, random(0, displayHeight));
    float distance = gravity.mag();
    gravity.mult(1/distance);
  }
 
 int getX() { return (int)position.x; }
 int getY() { return (int)position.y; }
 
 void draw() {
   fill(colour);
   strokeWeight(1);
   stroke(255);
   ellipse(position.x, position.y, width, height);
   fall();
 }
  
 void fall() {
   position.add(velocity);
   acceleration = gravity.copy();
   acceleration.mult(mass);
   velocity.add(acceleration);
   velocity.mult(DAMPING);
   
   if ((position.x - width < 0) || (position.x + width > displayWidth)) velocity.x = -velocity.x;
 }
 
 boolean split() {
  int toSplit = (int) random(0, 999);
    if (position.y > displayHeight / 4 && toSplit % 503 == 0) {
      split = false;
      return true;
    }
    else if (position.y > displayHeight / 2) {
      split = false;
      return true;
    }
    return false;
  }
}
