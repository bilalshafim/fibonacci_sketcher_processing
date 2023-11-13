/**
 * A fast method for getting an arbitrary number of equidistant points on a sphere.
 * Draws a fibonacci spiral down from the pole, which maintains uniform surface area.
 *
 * Click to toggle point adding.
 *
 * Jim Bumgardner 10/6/2011
 */
 // import processing.opengl.*;
 
import java.lang.Thread;  
import java.io.*;
 
float R = 277;
 
float rotationX = 0;
float rotationY = 0;
float velocityX = 0;
float velocityY = 0;
float pushBack = 0;
 
float phi = (sqrt(5)+1)/2 - 1; // golden ratio
float ga = phi*2*PI;           // golden angle
 
int kMaxPoints = 39;
 
int nbrPoints = 1;
 
// To add: Give each point a heading and velocity, adjust based on distance/heading to nearby points.
//
class SpherePoint {
  float  lat,lon;
  SpherePoint(float lat, float lon)
  {
    this.lat = lat;
    this.lon = lon;
  }
};
 
SpherePoint[] pts = new SpherePoint[kMaxPoints];
 
boolean addPoints = true;
 
void initSphere()
{
  for (int i = 1; i < min(nbrPoints,pts.length); ++i) {
    float lon = ga*i;
    lon /= 2*PI; lon -= floor(lon); lon *= 2*PI;
    if (lon > PI)  lon -= 2*PI;
 
    // Convert dome height (which is proportional to surface area) to latitude
    float lat = asin(-1 + 2*i/(float)nbrPoints);
 
    pts[i] = new SpherePoint(lat, lon);
  }
}
 
void setup()
{
  // size(1024, 768, P3D); 
  size(600, 600, P3D); 
  R = .8 * height/2;
   
  initSphere();
   
  colorMode(HSB, 1);
  background(0);
 
 
}
 
void draw()
{   
  if (addPoints) {
    nbrPoints += 1;
    nbrPoints = min(nbrPoints, kMaxPoints);
    initSphere();
  }
 
  background(0);           
  smooth();
 
  renderGlobe();
  //try{Thread.sleep(500);}catch(InterruptedException e){System.out.println(e);}
  //exportPoints();
 
  //rotationX += velocityX;
  //rotationY += velocityY;
  //velocityX *= 0.95;
  //velocityY *= 0.95;
   
  //// Implements mouse control (interaction will be inverse when sphere is  upside down)
  //if(mousePressed){
  //  velocityX += (mouseY-pmouseY) * 0.01;
  //  velocityY -= (mouseX-pmouseX) * 0.01;
  //}
}
 
 
void renderGlobe()
{
  pushMatrix();
  translate(width/2.0, height/2.0, pushBack);
   
  float xRot = radians(-rotationX);
  float yRot = radians(270 - rotationY - millis()*.01);
  //rotateX( xRot ); 
  //rotateY( yRot );
  
 
  strokeWeight(3);
   
  float elapsed = millis()*.001;
  float secs = floor(elapsed);
   
  for (int i = 1; i < min(nbrPoints,pts.length); ++i)
  {
      float lat = pts[i].lat;
      float lon = pts[i].lon;
 
      pushMatrix();
      rotateY( lon);
      rotateZ( -lat);
      float lum = (cos(pts[i].lon+PI*.33+yRot)+1)/2;
      stroke(.5,.5*lum,.2+lum*.8);
       
      point(R,0,0);
       
      popMatrix();
  }
 
  popMatrix();
   
}
 
void mouseClicked()
{
  exportPoints();
  //addPoints = !addPoints;
}

void exportPoints() {
  String filePath = "points.txt"; // Change the file path and name as desired
  PrintWriter writer = createWriter(filePath);
  
  for (int i = 1; i < min(nbrPoints, pts.length); ++i) {
    float lat = acos(1 - (2 * i / (float)nbrPoints));
    float lon = ga * i;
    
    float r = R; // Replace with the desired radius of the sphere
    
    float x = r * sin(lat) * cos(lon);
    float y = r * sin(lat) * sin(lon);
    float z = r * cos(lat);
    
    writer.println(x + "," + y + "," + z);
    println(x + "," + y + "," + z);

  }
  
  writer.flush();
  writer.close();
  
  println("Points exported to: " + filePath);
} //<>//

float calculateZ(float lat, float lon) {
  // Replace with your calculation logic to determine the Z coordinate based on lat and lon
  // You can use any formula or algorithm based on your specific requirements
  // For example, you can use noise, heightmaps, or any other function to generate the Z coordinate
  
  // This is a placeholder example using a simple sine function
  float z = sin(lat * 2 * PI) * cos(lon * 2 * PI);
  
  return z;
}
