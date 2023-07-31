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
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(1);
  cam.setMaximumDistance(2000);

  originX = width/2;
  originY = height/2;
  originZ = 0;
  //drawing setup
  background(0);
  lights();
  fill(100); //maybe set each one to random later on?

  println("happy birthday");
  //make some coordinates
  for(int i = 0; i < 200; i++){
    //coords.add(str(random(0, width)) + ", " + str(random(0, width)) + ", " + str(random(0, width)));
    float x = random(-px/2, px/2);
    float y = random(-py/2, py/2);
    float z = random(0, pz);

    PVector p = new PVector(x, y, z);
    vertices.add(p);
  }
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


  //draw spheres at random locations
  /* for( */

}

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
