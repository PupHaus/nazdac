import processing.serial.*;
Serial port1, port2, port3;

void setup() {
  // Configure Image
  size(192, 32);
  frameRate(15);
  noSmooth();
  
  // Configure Serial Ports
  port1 = new Serial(this, "COM4", 2000000);
  port2 = new Serial(this, "COM5", 2000000);
  port3 = new Serial(this, "COM6", 2000000);
  
  // Init Gamma Table
  populateGammaTable(2.5);
}


void draw() {
  background(0);
  
  // Output to Displays
  outputScreenToSerial(port1, 0, 0, 64, 32);
  outputScreenToSerial(port2, 64, 0, 64, 32);
  outputScreenToSerial(port3, 128, 0, 64, 32);
}
