
import processing.serial.*;

Serial port1, port2, port3;

Flock flock;

void setup() {
  size(192, 32);
  frameRate(8);
  colorMode(RGB, 255);
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 25; i++) {
    flock.addBoid(new Boid(width*2/3,height/2));
  }
  for (int i = 0; i < 25; i++) {
    flock.addBoid(new Boid(width/3,height/2));
  }  
  port1 = new Serial(this, "/dev/tty.usbmodem14113201", 2000000);
  port2 = new Serial(this, "/dev/tty.usbmodem14113301", 2000000);
  port3 = new Serial(this, "/dev/tty.usbmodem14113401", 2000000);
}

void draw() {
  background(0);
  flock.run();
  outputScreenToSerial(port1, 0, 0, 64, 32);
  outputScreenToSerial(port2, 64, 0, 64, 32);
  outputScreenToSerial(port3, 128, 0, 64, 32);
}

short colorTo565(color c) {
  short c565;
  int r = (c >> (16+3)) & 0x1F;
  int g = (c >> (8+2)) & 0x3F;
  int b = (c >> 3) & 0x1F;
  c565 = (short)((r << 11) | (g << 5) | b);
  return c565;
}

void outputScreenToSerial(Serial port, int x, int y, int w, int h) {
  byte[] screenBuffer = new byte[w*h*2];
  int bufIdx = 0;
  loadPixels();
  for(int py = y; py < (y+h); py++) {
    for(int px = x; px < (x+w); px++) {
      int p = px + py * width;
      short c565 = colorTo565(pixels[p]);
      screenBuffer[bufIdx++] = (byte)((c565 >> 8) & 0xFF);
      screenBuffer[bufIdx++] = (byte)(c565 & 0xFF);
    }
  }
  port.write(screenBuffer);
}
