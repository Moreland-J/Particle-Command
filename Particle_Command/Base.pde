final class Base {
 PVector position;
 int width, height;
 boolean selected;
 boolean destroyed;
 int ammo;
 
 Base(int x, int y, int width, int height, boolean selected) {
    this.position = new PVector(x, y);
    this.width = width - width / 8;
    this.height = height;
    this.selected = selected;
    this.destroyed = false;
    this.ammo = 10;
 }
 
 int getX() { return (int)position.x; }
 int getY() { return (int)position.y; }
 
 void draw() {
   strokeWeight(10);
   if (destroyed) {
     fill(0);
     stroke(255, 0, 0);
     rect(position.x, position.y, width, height);
   }
   else {
     fill(255);
     stroke(255, 0, 0);
     if(selected) {
        stroke(0,0,255);
     }
     rect(position.x, position.y, width, height);
     
     fill(0, 0, 255);
     textSize(20);
     text(ammo, position.x + width / 2, position.y + width / 2);
     stroke(255, 0, 0);
   }
 }
 
 void fire() {
   ammo--; 
 }
 
 boolean hit() {
   destroyed = true;
   return true;
 }
 
 void selected() {
   selected = true; 
 }
 
 void clearSelect() {
    selected = false; 
 }
}
