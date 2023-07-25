class Worm {
  //properties
  ArrayList<PVector> vertices;
  color bodyColor;
  int numSegments;
  float probCone = PI/6; //variablity, 30 degrees
  float theta;
  int d = 2; //length of the unit vector, = to radius?

  Worm(ArrayList<PVector> inheritedVertices, int s, float t){
    vertices = inheritedVertices;

    if(vertices.size() == 0){
      vertices.add(new PVector(0, 0, 100));
    }

    numSegments = s;
    bodyColor = color(random(255), random(255), random(255));
    theta = t;
  }

  void grow(ArrayList<Worm> others){
    //calc heading, plus/minus the code
    //generate next point using the heading as direction
    //continue until the segments have reached the desired length
    //each point gets added as a vertices of the worm

outer: //named loop
    for(int i = 1; i < numSegments; i++){
      theta = theta + random(-probCone, probCone);
      PVector u = PVector.fromAngle(theta);
      u.mult(d);

      //get last location
      //add new location to last vector location
      PVector newLocation = vertices.get(i - 1).copy().add(u);

      //if i is greater than 5, or maybe 1/3 of size
      if(i > numSegments / 4){
        //for loop over other worms vertices
        for(Worm o : others){
          //test
          if(o != this){
            //if last is close to another vert, snap to other worm
            for(PVector v : o.vertices){
              if(newLocation.dist(v) < d){
                newLocation = v.copy(); //replaces the newLocation with a point on another worm
                vertices.add(newLocation); //snap to the close point
                break outer; //ending the growth
              }
            }
          }
        }
      }

      vertices.add(newLocation);
    }
  }
}
