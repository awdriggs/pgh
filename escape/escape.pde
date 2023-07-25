boolean debug = true;
 
Fly test;
Wall border; //single wall ;) later make it a box
PVector mouseTest = new PVector(0,0);
ArrayList<Wall> walls = new ArrayList<Wall>();

ArrayList<PVector> locations = new ArrayList<PVector>();

void setup(){
  background(255);
  stroke(0);
  size(500, 500);

  border = new Wall(100, 50, 300, 50);
  //call the build cell with a pvect for the center of the box
  buildCell(new PVector(width/2, height/2));
  test = new Fly(new PVector(width/2,height/2), 20);
}

void draw(){
  /* mouseTest.x = mouseX; */
  /* mouseTest.y = mouseY; */

  background(255);
  test.go();
  /* border.render(); */

  //loop through the items in the wall array
  //call render on each item
  // The second is using an enhanced loop:
  for (Wall wall : walls) {
    wall.render();
  }
}

void buildCell(PVector center){
  //center is the center of the box
  //h, the height of the box
  float h = 200;
  //w, the width of the box
  float w = 200;
  //stroke, withe thickness of the walls
  float stroke = 10;

  //vertical offset
  //horizontal offset

  //base
  walls.add(new Wall(center.x - w/2, center.y + h/2, w, stroke));
  //top
  walls.add(new Wall(center.x - w/2, center.y - h/2, w, stroke));
  //left side
  walls.add(new Wall(center.x - w/2, center.y - h/2, stroke, h));
  //right side
  walls.add(new Wall(center.x + w/2 - stroke, center.y - h/2, stroke, h * 0.45));
  walls.add(new Wall(center.x + w/2 - stroke, center.y + h/2 - h * 0.45, stroke, h * 0.45));
}

void mousePressed(){
  noLoop();
  println(locations.size());
  for(int i = 1; i < locations.size(); i++){
    PVector prev = locations.get(i-1);
    println(locations.get(i));
    PVector cur = locations.get(i);
    stroke(0);
    line(prev.x, prev.y, cur.x, cur.y);
  }

}
