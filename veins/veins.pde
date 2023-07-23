import peasy.*;
PeasyCam cam;

int pr = 280;

int wormSize = 150;
//create an array of worms

Worm w;

//for writing
int trial = 1;
String title = "veins";
Boolean DEBUG = true;

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

  //make a single worm
  w = new Worm(new PVector(0,0,0), 10);

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
  ellipse(0,0,pr,pr); //round bat

  //loop to draw whatever
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

void keyPressed() {
  if(key == 'w'){
    writeSpecimen(title, trial);
    trial++;
  } else if(key == 'x'){
    exit();
  } else if(key == 'r'){
    w = new Worm(new PVector(0,0,0), 10);
  }
}

//generate geometry for open scad
void writeSpecimen(String title, int id){
  //create writer
  PrintWriter coordinates;
  coordinates = createWriter(title + id + ".txt");
  coordinates.println("WormList["); //opening line

  //loop over all the wroms
    //for each worm, add a point at each location
    //for loop, write coordinates of each point in the array list to the file
    //[x, y, z],

    coordinates.println("["); //open single worm
    for(PVector current : w.vertices) {
      coordinates.println("[" + current.x + ", " + current.y + ", " + current.z + "],");
    }
    coordinates.println("],"); //close single worm

  coordinates.println("];"); //closing line
  coordinates.flush();
  coordinates.close();
}
