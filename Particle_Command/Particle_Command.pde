// Just specify canvas size
// Some constants used to derive sizes for game elements from display size
final int CITY_WIDTH_PROP = 10, CITY_HEIGHT_PROP = 10;
final int BASE_WIDTH_PROP = 15, BASE_HEIGHT_PROP = 7;
final int MISSILE_WIDTH_PROP = 75, MISSILE_HEIGHT_PROP = 50;
public static final float DAMPING = .995f; 

int wave = 1;
boolean next;
int points = 0;
int mainPoints = 0;
int trackTenThous = 0;
Base[] bases;
City[] cities;
int citiesStanding = 6;
ArrayList<Missile> missiles;
ArrayList<Explosion> explosions;
ArrayList<Particle> particles;
ArrayList<Integer> splitting;
int launched = 0;
int maxParts = 10;
int missileMax = 30;
int selected = 1;
          
void setup() {
  fullScreen();
  next = false;
  cities = new City[6];
  bases = new Base[3];
  missiles = new ArrayList<Missile>();
  explosions = new ArrayList<Explosion>();
  particles = new ArrayList<Particle>();
  
  int baseWidth = displayWidth / BASE_WIDTH_PROP;
  int baseHeight = displayHeight / BASE_HEIGHT_PROP;
  
  int cityWidth = displayWidth / CITY_WIDTH_PROP;
  int cityHeight = displayHeight / CITY_HEIGHT_PROP;
  int cityX = displayWidth / 9 - cityWidth / 2; 
  int cityY = displayHeight - cityHeight;
  
  bases[0] = new Base(0, displayHeight - baseHeight, baseWidth, baseHeight, false);
  bases[1] = new Base(displayWidth / 2 - baseWidth, displayHeight - baseHeight, baseWidth, baseHeight, true);
  bases[2] = new Base(displayWidth - baseWidth, displayHeight - baseHeight, baseWidth, baseHeight, false);

  int xCo = cityWidth;
  for (int i = 0; i < 6; i ++) {
    //initProp--;
    cities[i] = new City(xCo, cityY, cityWidth, cityHeight);
    xCo = xCo + cityWidth/2 + cityX;
    if (i == 2) {
      xCo = xCo + cityWidth;
    }
  }
}

// clear background render a pair of lines that intersect at the mouse
// position, render some text describing mouse coords

void draw() {
  background(0);
  
  if (citiesStanding > 0) {
    stroke(255);
    strokeWeight(3);
    line(mouseX - 10, mouseY, mouseX + 10, mouseY);
    line(mouseX, mouseY - 10, mouseX, mouseY + 10);
    fill(255);
    textSize(30);
    int total = mainPoints + points;
    text("Wave: " + wave + "\nScore: " + total, 10, 30); 
    
    for (int i = 0; i < 6; i++) {
      cities[i].draw(); 
    }
    for (int i = 0; i < 3; i++) {
      bases[i].draw(); 
    }
    for (int i = 0; i < missiles.size(); i++) {
      if (missiles.get(i).exploded && !missiles.isEmpty()) {
        Explosion ex = new Explosion(missiles.get(i).getX(), missiles.get(i).getY(), (displayWidth / MISSILE_WIDTH_PROP) * 6, (displayHeight / MISSILE_HEIGHT_PROP) * 6);
        explosions.add(ex);
        missiles.remove(i);
        i--;
      }
      else {
        missiles.get(i).draw();
      }
    }
    for (int i = 0; i < explosions.size(); i++) {
      if(explosions.get(i).finished) {
        explosions.remove(i);
        i--;
      }
      else {
        explosions.get(i).draw();
      }
    }
    
    generate();
    // create particle with random x coordinate, mass, etc. 
    for (int i = 0; i < particles.size(); i++) {
      if (particles.get(i).getX() < 0 || particles.get(i).getY() > displayHeight) { 
        particles.remove(i);
        if (particles.isEmpty()) {
          next = true;
        }
        if (i > 0) {
          i--;
        }
      }
      else {
        particles.get(i).draw();
        if (particles.get(i).split && particles.get(i).split()) {
          Particle part = new Particle(particles.get(i).getX(), particles.get(i).getY(), (displayWidth / MISSILE_WIDTH_PROP) / 2, (displayHeight / MISSILE_HEIGHT_PROP) / 2, wave, false, DAMPING);
          particles.add(part);
        }
      }
    }
    
    // collision detection call
    detect();
    
    // combine points and move onto the next wave
    nextWave();
    
    checkTenThous();
  }
  else {
    textAlign(CENTER);
    textSize(50);
    text("MISSION FAILED. \nPOINTS: " + mainPoints + "\nPlay Again? \n [Press Enter]", displayWidth / 2, displayHeight / 2);
  }
}

void keyPressed() {
  if (key == '1' && !bases[0].destroyed) {
    selected = 0;
    bases[0].selected();
    bases[1].clearSelect();
    bases[2].clearSelect();
  }
  else if (key == '2' && !bases[1].destroyed) {
    selected = 1;
    bases[1].selected();
    bases[0].clearSelect();
    bases[2].clearSelect();
  }
  else if (key == '3' && !bases[2].destroyed) {
    selected = 2;
    bases[2].selected();
    bases[1].clearSelect();
    bases[0].clearSelect();
  }
}

void keyReleased() {
  if (key == ENTER) {
    reset();
  }  
}

void mousePressed() {
}

void mouseReleased() {
  if (bases[selected].ammo > 0) {
    bases[selected].fire();
    int speedDiv = 100;
    if (selected == 1) {
      speedDiv = 75;
    }
    Missile missile = new Missile(bases[selected].getX() + bases[selected].width / 2,
                                  bases[selected].getY(), 
                                  displayWidth / MISSILE_WIDTH_PROP,     // proportions
                                  displayHeight / MISSILE_HEIGHT_PROP, 
                                  mouseX, mouseY,  // target
                                  speedDiv,
                                  DAMPING);    // acceleration
    missiles.add(missile);
  }
}


void generate() {
  // create new particle
  // with each wave generate higher percentage of particles
  if (wave > 1 && next) {
    splitting = new ArrayList<Integer>();
    splitting.add((int) random(0, maxParts - 1));
    for (int i = 0; i < wave - 1; i++) {
      int splitIndex = (int) random(0, maxParts - 1);
      while (splitting.contains(splitIndex)) {
        splitIndex = (int) random(0, maxParts - 1);
      }
      splitting.add(splitIndex);
    }
  }
  next = false;
  boolean generate = false; //<>//
  // random true/false generator
  int number = (int)random(0, 10);
  if (number % 3 == 0) {
    generate = true;
  }
  // if true
  if (generate && launched < maxParts) {
    boolean toSplit = false;
    if (wave > 1 && splitting.contains(particles.size() - 1)) {
      toSplit = true;
    }
    Particle part = new Particle((int)random(0, displayWidth), 0, (displayWidth / MISSILE_WIDTH_PROP) / 2, (displayHeight / MISSILE_HEIGHT_PROP) / 2, wave, toSplit, DAMPING);
    particles.add(part);
    launched++;
  }  
}


void nextWave() {
  if (launched % maxParts == 0 && next && particles.isEmpty()) {
    wave++;
    launched = 0;
    maxParts = maxParts; // + 5
    mainPoints = mainPoints + points;
    mainPoints = mainPoints + (100 * citiesStanding);
    if (wave == 3 || wave == 4) {
      mainPoints = mainPoints * 2;
    }
    else if (wave == 5 || wave == 6) {
      mainPoints = mainPoints * 3;
    }
    else if (wave == 7 || wave == 8) {
      mainPoints = mainPoints * 4;
    }
    else if (wave == 9 || wave == 10) {
      mainPoints = mainPoints * 5;
    }
    else if (wave >= 11) {
      mainPoints = mainPoints * 6;
    }
    points = 0;
    
    for (int i = 0; i < bases.length; i++) {
      bases[i].destroyed = false;
      bases[i].ammo = 10;
    }
  }
}


void detect() {
  // missiles, cities and bases
  // particle destruction
  for (int i = 0; i < explosions.size(); i++) {
    for (int j = 0; j < particles.size(); j++) {
      
      float a = Math.abs(explosions.get(i).getX() - particles.get(j).getX());
      float b = Math.abs(explosions.get(i).getY() - particles.get(j).getY());
      
      a = a * a;
      b = b * b;
      
      float dist = (float) Math.sqrt(a + b);

      if (dist < explosions.get(i).width / 2 + particles.get(j).width / 2 && dist < explosions.get(i).height / 2 + particles.get(j).height / 2) {
        Explosion ex = new Explosion(particles.get(j).getX(), particles.get(j).getY(), (displayWidth / MISSILE_WIDTH_PROP) * 4, (displayHeight / MISSILE_HEIGHT_PROP) * 4);
        particles.remove(j);
        explosions.add(ex);
        
        if (particles.isEmpty()) {
          next = true;
        }
        if (particles.size() > j && j > 0) {
          j--;
        }
        
        points = points + 25;
        trackTenThous = trackTenThous + points;
      }
    }
  }
  
  // checks for city and base collisions
  for (int i = 0; i < cities.length; i++) {
    for (int j = 0; j < particles.size(); j++) {
      boolean collide = false;
      if (i < 3) {
        if (!bases[i].destroyed && (particles.get(j).getX() + particles.get(j).width > bases[i].getX() &&
             particles.get(j).getX() - particles.get(j).width < bases[i].getX() + bases[i].width) &&
             particles.get(j).getY() + particles.get(j).height > bases[i].getY()) {
          if (bases[i].hit()) {
            bases[i].ammo = 0;
            if (selected == i) {
              boolean move = true;
              int l = 0;
              while (move && l < 3) {
                if (!bases[l].destroyed) {
                  selected = l;
                  move = false;
                }
                else {
                  l++;
                }
              }
            }
            collide = true;
          }
        }
      }
       
      // city hit by particle
      if (!cities[i].destroyed && (particles.get(j).getX() + particles.get(j).width > cities[i].getX() &&
          particles.get(j).getX() - particles.get(j).width < cities[i].getX() + cities[i].width) &&
          particles.get(j).getY() + particles.get(j).height > cities[i].getY()) {
        cities[i].hit();
        citiesStanding--;
        collide = true;
      }
      
      if (collide) {
        particles.remove(j);
        if (!particles.isEmpty() && j > 0) {
          j--;
        }
        else if (particles.isEmpty()) {
          next = true;
        }
      }
    }
  }
}

void checkTenThous() {
  if (citiesStanding < 6 && trackTenThous > 10000) {
    boolean check = true;
    int i = 0;
    while (check && i < 6) {
      if (cities[i].destroyed) {
        cities[i].destroyed = false;
        citiesStanding++;
        check = false;
      }
      i++;
    }
    trackTenThous = 0;
  }
}

void reset() {
  wave = 1;
  points = 0;
  mainPoints = 0;
  trackTenThous = 0;
  bases = null;
  cities = null;
  citiesStanding = 6;
  missiles = null;
  explosions = null;
  particles = null;
  launched = 0;
  maxParts = 10;
  missileMax = 30;
  selected = 1;
  setup();
}

/* Sketch Summaries
    Velocity gives movement and force (?)
    Particle does bounces
    Drag slows things over time
    Mass 
    Gravity gives things a central pull
*/

/* TODO
*/
