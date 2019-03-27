// Sistema de vision
// Detección de HIGOS

import processing.video.*;
import controlP5.*;
Capture video;  // Variable para captura de webcam
color trackColor; // variable para guardar color seleccionado
ControlP5 cp5;
float threshold = 25;

void setup() {
  size(320, 240);
  video = new Capture(this, width, height);
  video.start();
  cp5 = new ControlP5(this);
  
  cp5.addSlider("Threshold")
    .setRange(0, 100)
      .setValue(0)
        .setPosition(0, 0)
          .setSize(100, 10);
          
  // Prueba, sigue color rojo
  trackColor = color(0, 0, 0); //inicia detectando color Rojo 255,0,0
}

void captureEvent(Capture video) {

  video.read();    // Lee imagen de la wecam
}

void draw() {
  video.loadPixels();
  image(video, 0, 0);
  
  threshold = cp5.getController("Threshold").getValue();
  //threshold = map(mouseX, 0, width, 0, 100); //threshold con el mouse
  
  // porcentaje de coordenadas XY del color 
  float avgX = 0;
  float avgY = 0;

  int count = 0;
  
// Inicia bucle a traves de cada pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      color currentColor = video.pixels[loc];  // color actual es
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);
// Uso de distancia euclodiana para comparar distancia en colores
      float d = dist(r1, g1, b1, r2, g2, b2); 
      
      if (d < threshold) {
        stroke(255);
        strokeWeight(1);
        point(x,y);
        avgX += x;
        avgY += y;
        count++;
           
      }
    }
  }
  
  if (count > 0) { 
    avgX = avgX / count;
    avgY = avgY / count;
    
    // Dibuja circulo
    fill(trackColor);
    strokeWeight(2.0);
    stroke(0);
    ellipse(avgX, avgY, avgX/2, avgY/2);
    println(avgX,avgY);
   }
}
/*
void mousePressed() {    // Guarda color seleccionado por el mouse
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}
*/