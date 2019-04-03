//Global variables
PImage im;
PImage depth;
int crudeness = 5;
float parallaxSpeed = 0.1; //set this between 1 and 0. the closer to 1 the faster the parallax

PVector []worldPoints;

//Primitive setup
int primitiveRadius = 3;
boolean redraw = true;

color getColorAt(PImage image, int x, int y){
  return (image.pixels[(y*image.width) + x]);
}

float colorToDepth(PImage _depth, int x, int y){
  color c = getColorAt(_depth, x, y);
  //return (pow(brightness(c)/254, 5));
  return (brightness(c));
}

void setPositionsAt(PVector p, int x, int y){
  worldPoints[(y*im.width) + x] = p;
}

PVector pixelToWorldPoint(int x, int y){
  return worldPoints[(y*im.width) + x];
}

void setupWorldPoints(int offset){
  worldPoints = new PVector[im.height * im.width];
  
  for (int x = 0; x < im.width; x++){
    for (int y = 0; y < im.height; y++){
      worldPoints[(y*im.width) + x] = new PVector(x - (width/2) + offset, y - (height/2) + offset);
    }
  }
}

void setup(){ 
  
  size(1300, 600, P3D);
  //colorMode(HSB);
  background(60);
  readImages();
}

void readImages(){
  im = loadImage("i1.png");
  depth = loadImage("d1.jpg");
  im.loadPixels();
  depth.loadPixels();
  
  setupWorldPoints(0);
}

void drawPointCloud(){ //Pass it the image, depth map, offset
//This will be called every frame
//first we reconstruct from the arrays that contain our images by displaying each pixel as an ellipse
//then each pixel will shifted by parametrized by the offset(i.e. the mosue position) and the depth it exists at 
  
  //calculate offset
  float offsetx, offsety;
  offsetx = ((float(mouseX)/float(width)) * 2) - 1;
  offsety = ((float(mouseY)/float(height)) * 2) - 1;
  
  color c;
  PVector pos;
  float z;
  
  //Loop over image, create ellipses with required position
  for (int y = 0; y < im.height; y += crudeness){
    for (int x = 0; x < im.width; x += crudeness){
      //set color
      c = getColorAt(im, x, y);
      stroke(c);
      fill(c);
      
      //here we set the depth of this particular vertex/primitive
      pos = pixelToWorldPoint(x, y);
      z = colorToDepth(depth, x, y); //currently just returning brightness of the current pixel in the depth map
      
      //update pos based on offset and initial depth. Offset should be between -2 and 2 for example with multiplicative factor of the depth, update positions in the positions array 
      pos.x += offsetx * z * parallaxSpeed;
      pos.y += offsety * z * parallaxSpeed;
      setPositionsAt(pos, x, y);
        
      //draw vertex
      translate(0, 0, z);
      ellipse(pos.x, pos.y, primitiveRadius, primitiveRadius);
      translate(0, 0, -z);
    }
  }
}

void mouseMoved(){
   redraw = true;
}

void draw(){
   if(redraw){
    //noLoop();
    //return;
    background(0);
    translate(width/2, height/2, 0);
    //rotateY(rotVal);
    //rotVal += 0.01;
    
    drawPointCloud(); 
    redraw = false;
  }
}