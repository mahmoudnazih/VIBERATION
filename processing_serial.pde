/**
  
 * Read data from the serial port 
 
 */


import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port

int x= height/3;
int y= width/3;

void setup() 
{
  fullScreen(P3D);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw()
{
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
  }

	//Rest of code should go here
	
//fill(255, 0, 0);
  noFill();
  translate(100,100);   // this part not complete yet
  rotateY(radians(35));
  drawBarElement(130, 80, 30);
 
}


//Draw Element of the bar

void drawBarElement(int xpos, int ypos, int zplane) {

  beginShape();
  vertex(xpos, ypos, zplane); 
  vertex(xpos, 2*ypos, zplane); 
  vertex(xpos+zplane, 2*ypos, zplane); 
  vertex(xpos+zplane, ypos, zplane); 
  vertex(xpos,ypos,zplane);
  vertex(xpos+15,ypos+30,2*zplane);
  endShape();
}

