//units are loosy, but think mm

import peasy.*;
PeasyCam cam;

int px = 250; //prusa width
int py = 200; //prusa height
int pz = 250; //arbitary z height, chane later

float originX, originY, originZ;

ArrayList<String> coords = new ArrayList<String>();
String projectName = "test";
String version = "v1";

ArrayList<PVector> vertices = new ArrayList<PVector>();

ArrayList<PVector> wormPoints = new ArrayList<PVector>();

PVector wormLocation;
ArrayList<PVector> wormVertices = new ArrayList<PVector>();

float wormDiameter = 2;
float distanceThreshold = 50;

//basic setup for 3D
void setup(){
  fullScreen(P3D, 1);
  //size(500, 500, P3D);
  frameRate(15);
  //this is for a close up zoom, https://forum.processing.org/two/discussion/27071/how-far-can-i-go-with-peasycam
  float fov      = PI/3;  // field of view
  float nearClip = 1;
  float farClip  = 1000;
  float aspect   = float(width)/float(height);
  perspective(fov, aspect, nearClip, farClip);

  //init the camera
  cam = new PeasyCam(this, 200);
  cam.setMinimumDistance(1);
  cam.setMaximumDistance(2000);

  //drawing setup
  background(0);
  lights();
  fill(100); //maybe set each one to random later on?

  println("happy birthday");
  //make some coordinates
  for(int i = 0; i < 500; i++){
    //coords.add(str(random(0, width)) + ", " + str(random(0, width)) + ", " + str(random(0, width)));
    float x = random(-px/2, px/2);
    float y = random(-py/2, py/2);
    float z = random(0, pz);

    PVector p = new PVector(x, y, z);
    vertices.add(p);
  }

  wormLocation  = new PVector(0, 0, pz/2); //start location of the worm

  //the search through the space!
  //let the worm travel to the nearest source of food, can't be greater than a certain threshold, distanceThreshold
  //add the vertices to the worm space, but take it away from the food array.
  //repeat while there is still room within a distance
  boolean searching = true;
  
  while(searching == true){
    boolean found = false; //flag to break out of loop
    
    //find closest point
    PVector closest =  new PVector();
    float distance = 20000; //a large number, so the first close point will be a hit
    int indexOfFood = -1;
    /* for(PVector v : vertices){ */
    for(int i = 0; i < vertices.size(); i++){
      PVector v = vertices.get(i);
      float thisDistance = wormLocation.dist(v);

      if(thisDistance < distance && thisDistance < distanceThreshold){
        closest = v;
        found = true; //you found a new point
        distance = thisDistance;
        indexOfFood = i;
      }
    }

    //if nothing was found, we are out of food
    if(found == false){
      searching = false; //break out
    } else {
      distance = wormLocation.dist(closest);//update distance
      wormVertices.add(wormLocation); //add the old worm location to the array of worm locations
      wormLocation = closest; //rest the worm to this location.
      vertices.remove(indexOfFood); //remove this food, its been eaten
    }
  }

  println(wormVertices.size());
}

void draw() {
  background(255);

  //printer floor
  rectMode(CENTER);
  stroke(255, 0, 0);
  fill(255, 0, 0);
  rect(0, 0, px, py);

  pushMatrix();
  translate(0, 0, pz/2);
  noFill();
  stroke(0);
  box(px, py, pz);
  popMatrix();

  for(PVector v : vertices){
    pushMatrix();
    translate(v.x, v.y, v.z);
    sphere(2);
    popMatrix();
  }

  //loop through the worm points and add the sphere and lines to the vertices.
  for(int i = 1; i < wormVertices.size(); i++){
    /* pushMatrix(); */
    PVector thisPoint = wormVertices.get(i);
    PVector lastPoint = wormVertices.get(i-1);

    /* translate(thisPoint.x, thisPoint.y, thisPoint.z); */
    stroke(0, 255, 0);
    strokeWeight(wormDiameter); 
    line(thisPoint.x, thisPoint.y, thisPoint.z, lastPoint.x, lastPoint.y, lastPoint.z); 
    /* sphere(4); */
     
    /* popMatrix(); */
  }

}

//output the worm cordinates in something that grasshopper can read.
void writeCoords() {
  //loop through vertices, add vectors to the coords list
  String fileName = projectName + version + ".txt"; //name for the file
  String [] coordArray = coords.toArray(new String[coords.size()]); //save strings needs and array of text, not an arrayList
  saveStrings (fileName, coordArray);
}

void keyPressed(){
  if(key == 'w'){
    println("writing");
    writeCoords();
  }
}
