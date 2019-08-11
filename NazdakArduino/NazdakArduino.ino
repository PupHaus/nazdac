#include <RGBmatrixPanel.h>

#define CLK  13
#define OE   1  // TX
#define LAT  0  // RX
#define A   A5
#define B   A4
#define C   A3
#define D   A2

// the RGB data pins on featherwing, must be on same PORT as CLK
uint8_t rgbpins[] = { 6,5,9,11,10,12 };
RGBmatrixPanel Matrix(A, B, C, D, CLK, LAT, OE, false, 64, rgbpins);

// serial buffer 
bool debug = false;

byte colorBuffer[4097];
int colorBufferIdx = 0;

bool autoOff = true;
int autoOffTimeout = 5000;

int rxTimeout = 20;
long lastRun = 0;
long lastDraw = 0;
bool lastActionWrite = false;
bool lastActionBlank = false;

void setup() {
  Serial.begin(2000000);
  
  Matrix.begin();
  //Matrix.setRotation(0);

}

void loop() {
  // if millis overflows reset
  if (lastRun > millis()) {lastRun = millis();}
  if (lastDraw > millis()) {lastDraw = millis();}
  
  if (Serial.available() > 0) {
    lastActionWrite = false;
    lastActionBlank = false;
    lastRun = millis();
    
    byte inByte = (byte)Serial.read();
    colorBuffer[colorBufferIdx++] = inByte;
  }
  else if (lastActionWrite == false) {
    if ( lastRun + rxTimeout < millis() ) {
      lastActionWrite = true;
      lastDraw = millis();
      
      ProcessBuffer();
    }
  }
  else if (lastActionBlank == false && autoOff) {
    if ( lastDraw + autoOffTimeout < millis() ) {
      lastActionBlank = true;
      
      for (int i = 0; i <= 4098; i++) {
        colorBuffer[i] = 0;
      }
      ProcessBuffer();
    }
    
  }
}

void ProcessBuffer() {
  for (int i = 0; i <= 2048; i++) {
    int idx = i * 2;

    uint16_t color;
    color = (uint16_t) colorBuffer[idx] << 8;
    color |= (uint16_t) colorBuffer[idx+1];
    
    int x = i % 64;
    int y = i / 64;
    
    Matrix.drawPixel(x, y, color);

  }
  colorBufferIdx = 0;
}
