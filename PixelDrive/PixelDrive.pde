SlidingImage land, sky;
int currentSeason;
PImage glow;
String seasons[] = { 
  "winter", "spring", "summer", "fall"
};

void setup() {
  size(640, 360);
  smooth();
  glow = loadImage("glow.png");
  startUp();
}

void startUp() {
  background(0);
  
  // Create some land and some sky.
  land = new SlidingImage(width, height);
  sky = new SlidingImage(width, height);
  
  // Set up each with some initial parameters.
  land.setup("land-" + seasons[currentSeason] + ".jpg", 100, 0);
  sky.setup("sky-" + seasons[currentSeason] + ".jpg", 0, 100);
}

void draw() {
  background(255);
  
  // Update our land and sky.
  sky.draw(0.000035, 5, "top");
  land.draw(0.00004, 10, "bottom");
  
  // Draw!
  image(sky.composite, 0, 0, width, height);
  blend(glow, 0, 0, width, height, 0, 0, width, height, ADD);
  image(land.composite, 0, 0, width, height);
}

void keyPressed() {
  // Hit the space key, get a new season!
  if (key==' ') {
    currentSeason = (currentSeason<seasons.length-1) ? currentSeason + 1 : 0;
    startUp();
  }
}

