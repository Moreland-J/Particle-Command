final class Missile {
  PVector origin, position, target, vector;
  // normal being the vector of change between position and target
  PVector velocity, acceleration, gravity;
  int width, height, direction;
  private float mass;
  float magnitude;
  boolean exploded;
  final float DAMPING;

  Missile(int x, int y, int width, int height, int targetX, int targetY, int speedDiv, float DAMPING) {
    this.origin = new PVector(x, y);
    this.position = new PVector(x, y);
    this.width = width;
    this.height = height;
    this.target = new PVector(targetX, targetY);
    //if (target.x > origin.x) {
    //  tempTar.x = target.x + (displayWidth - target.x);
    //}
    //else {
    //  tempTar.x = target.x + (target.x);
    //}
    //if (target.y < origin.x) {
    //  tempTar.y = target.y + (target.y);
    //}
    //else {
    //  tempTar.y = target.y + (displayHeight - target.y);
    //}
    
    //divide display into 8ths?
    
    //int multiplier = getExtraThrust();
    int multiplier = 1;
    this.vector = new PVector(multiplier * (target.x - x), multiplier * (target.y - y));
    this.velocity = new PVector((float)vector.x / speedDiv, (float)vector.y / speedDiv);

    this.exploded = false;
    this.DAMPING = DAMPING;
    this.mass = 0.009f;
    this.gravity = new PVector(0, displayHeight);
    float distance = gravity.mag();
    gravity.mult(1/distance);
  }
  
  int getExtraThrust() {
    int multiplier = 1;
    
    float divWidth = displayWidth / 3;
    float divHeight = displayHeight / 3;
    //if (origin.x < divWidth) {
    //  if (target.x < divWidth) {
    //    return 3;
    //  }
    //  else if ((target.x > divWidth && target.x < divWidth * 2)) {
    //    return 2;
    //  }
    //  else if ((target.x > divWidth * 2 && target.x < divWidth * 3)) {
    //    return 1;
    //  }
    //}
    //else if (origin.x > divWidth && origin.x < divWidth * 2) {
    //  if (target.x < divWidth) {
    //    return 1;
    //  }
    //  else if (target.y > divHeight * 2) {
    //    return 8;
    //  }
    //  else if (target.x > divWidth * 2 && target.x < divWidth * 3) {
    //    return 1;
    //  }
    //}
    //else if (origin.x > divWidth * 2) {
    //  if (target.x < divWidth) {
    //    return 1;
    //  }
    //  else if (target.x > divWidth && target.x < divWidth * 2) {
    //    return 2;
    //  }
    //  else if (target.x > divWidth * 2 && target.x < divWidth * 3) {
    //    return 2;
    //  }
    //}
    
    if (target.y > divHeight * 2) {
        return 8;
    }
    else if (target.y > divHeight && target.y < divHeight * 2) {
      return 4; 
    }
    
    return multiplier;
  }

  int getX() { 
    return (int)position.x;
  }
  int getY() { 
    return (int)position.y;
  }
  int getTarX() { 
    return (int)target.x;
  }
  int getTarY() { 
    return (int)target.y;
  }

  void draw() {
    fill(255, 0, 0);
    stroke(255, 0, 0);
    ellipse(position.x, position.y, width, height);
    fly();
  }

  boolean fly() {
    position.add(velocity);
    acceleration = gravity.copy();
    acceleration.mult(mass);
    velocity.add(acceleration);
    velocity.mult(DAMPING);

//|| (velocity.y == 0 && (position.x < target.x + 5 && position.x > target.x - 5)
    if (!exploded && ((target.y < origin.y && position.y < target.y) || (target.x > origin.x && position.x > target.x) || (target.x < origin.x && position.x < target.x))) {
      return explode();
    }
    return false;
  }

  boolean explode() {
    exploded = true;
    return true;
    // return true and create an explosion object
  }
}
