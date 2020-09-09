final class City {
 PVector position;
 int width, height;
 boolean destroyed;
 
 City(int x, int y, int width, int height) {
    this.position = new PVector(x, y);
    this.width = width - width / 8;
    this.height = height;
    this.destroyed = false;
 }
 
 int getX() { return (int)position.x; }
 int getY() { return (int)position.y; }
 
 void draw() {
   strokeWeight(2);
   if (destroyed) {
     fill(0);
     stroke(255, 0, 0);
   }
   else {
     fill(255);
     stroke(0, 255, 0);
   }
   rect(position.x, position.y, width, height);
 }
 
 void hit() {
   destroyed = true; 
 }
}
