//goal, send text to gh, create as pipes
//secondary, get veins to grow in 3d space, limit the bounding block in gh

import peasy.*;
PeasyCam cam;

int pw = 250; //prusa width
int ph = 200; //prusa height

int popSize = 30;
int wormSize = 50;
//create an array of worms
ArrayList<Worm> worms;

//for writing
int trial = 7;
String title = "veins";

//basic setup for 3D
void setup(){
  fullScreen(P3D, 1);
  //size(500, 500, P3D);
  frameRate(15);
  //this is for a close up zoom, https://forum.processing.org/two/discussion/27071/how-far-can-i-go-with-peasycam
  float fov      = PI/3;  // field of view
  float nearClip = 1;
  float farClip  = 500;
  float aspect   = float(width)/float(height);
  perspective(fov, aspect, nearClip, farClip);

  //init the camera
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(1);
  cam.setMaximumDistance(500);

  // init worms, also used to reset
  makeWorms();

  //drawing setup
  background(0);
  lights();
  fill(100); //maybe set each one to random later on?
}

void draw(){

  background(255);

  //printer boundry
  noFill();
  stroke(0);
  rectMode(CENTER);
  rect(0, 0, pw, ph);

  //loop to draw whatever
  for(Worm w : worms){
    fill(w.bodyColor);
    stroke(w.bodyColor);
    strokeWeight(2);
    for(int i = 1; i < w.vertices.size(); i++){
      PVector current = w.vertices.get(i);
      line(current.x, current.y, w.vertices.get(i-1).x, w.vertices.get(i-1).y);
      pushMatrix();
      translate(current.x, current.y, current.z);
      // sphere(0.25);
      popMatrix();
    }
  }

}

void makeWorms(){
  worms = new ArrayList<Worm>();

  for(int i = 0; i < popSize; i++){
    float seedAngle = random(0, TWO_PI); //could be inside loop to give each worm a different angle
    worms.add(new Worm(new ArrayList<PVector>(), wormSize, seedAngle));
    //  println(worms.get(i).vertices);
    worms.get(i).grow(worms); //bug, hitting themselves?!
    // create a sublist minus this current worm?
  }
}

void keyPressed() {
  if(key == 'w'){
    writeSpecimen(title, trial, worms);
    trial++;
  } else if(key == 'x'){
    exit();
  } else if(key == 'r'){
    makeWorms(); //regrow the worms!
  }
  println(worms.size());
}

//generate geometry for open scad
void writeSpecimen(String title, int id, ArrayList<Worm> worms){
  //create writer
  PrintWriter coordinates;
  coordinates = createWriter(title + id + ".scad");
  coordinates.println("WormList = ["); //opening line

  //loop over all the wroms
  for(Worm single : worms){
    //for each worm, add a point at each location
    //for loop, write coordinates of each point in the array list to the file
    //[x, y, z],

    coordinates.println("["); //open single worm
    for(PVector current : single.vertices) {
      coordinates.println("[" + current.x + ", " + current.y + ", " + current.z + "],");
    }
    coordinates.println("],"); //close single worm
  }

  coordinates.println("];"); //closing line
  coordinates.flush();
  coordinates.close();
}
