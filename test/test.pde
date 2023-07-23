ArrayList<String> coords = new ArrayList<String>();;
String projectName = "test";
String version = "v1";

void setup() {
  size(200, 200);
  println("happy birthday");
  noLoop();
}

void draw() {
  for(int i = 0; i < 200; i++){
    coords.add(str(random(0, width)) + ", " + str(random(0, width)) + ", " + str(random(0, width)));
  }
  
  writeCoords();
}

void writeCoords() {
  String fileName = projectName + version + ".txt"; //name for the file
  String [] coordArray = coords.toArray(new String[coords.size()]); //save strings needs and array of text, not an arrayList
  saveStrings (fileName, coordArray);
}
