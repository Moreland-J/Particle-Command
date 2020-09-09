final class Explosion {
 PVector position;
 int width, height;
 int timer = 0;
 boolean finished = false;
 final int SECOND = 60;
 
 Explosion(int x, int y, int width, int height) {
    this.position = new PVector(x, y);
    this.width = width - width / 16;
    this.height = height;
 }
 
 int getX() { return (int)position.x; }
 int getY() { return (int)position.y; }
 
 void draw() {
   fill(255, 255, 0);
   strokeWeight(1);
   stroke(255, 255, 0);
   ellipse(position.x, position.y, width, height);
   if (timer == SECOND) {
     finished = true; 
   }
   timer++;
 }
 
}
