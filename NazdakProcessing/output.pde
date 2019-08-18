byte[] gammatable = new byte[256];

short colorTo565(color c) {
  short c565;
  int r = (c >> (16+3)) & 0x1F;
  int g = (c >> (8+2)) & 0x3F;
  int b = (c >> 3) & 0x1F;
  c565 = (short)((r << 11) | (g << 5) | b);
  return c565;
}

short colorTo565Gamma(color c) {
  short c565;
  
  int cr = (c >> (16)) & 0xFF;
  int cg = (c >> (8)) & 0xFF;
  int cb = c & 0xFF;
  
  int r = (gammatable[(int)cr] >> 3) & 0x1F;
  int g = (gammatable[(int)cg] >> 2) & 0x3F;
  int b = (gammatable[(int)cb] >> 3) & 0x1F;
  
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
      short c565 = colorTo565Gamma(pixels[p]);
      screenBuffer[bufIdx++] = (byte)((c565 >> 8) & 0xFF);
      screenBuffer[bufIdx++] = (byte)(c565 & 0xFF);
    }
  }
  port.write(screenBuffer);
}

void populateGammaTable(float g) {
  //populate gamma table
  for (int i=0; i<256; i++) {
  float x = i;
    x /= 255;
    x = pow(x, g);
    x *= 255;
    gammatable[i] = (byte)x;
    //println(gammatable[i]);
  }
}
