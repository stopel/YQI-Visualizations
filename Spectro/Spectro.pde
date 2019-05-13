//3D Spectrogram with Microphone Input
//Modified by kylejanzen 2011 - https://kylejanzen.wordpress.com
//Based on script wwritten by John Locke 2011 - http://gracefulspoon.com

//Output .DXF file at any time by pressing "r" on the keyboard

import processing.dxf.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
import peasy.*; //3D rotation camera

FFT fftLin;
FFT fftLog;

Waveform audio3D;

Minim minim;
AudioInput microphone;

boolean record;
color c = color(255, 80);  // Define color 'c'

PFont font;

float camzoom;
float maxX = 90;float maxY = 90;float maxZ = 90;
float minX = 0;float minY = 0;float minZ = 0;

//Camera motion
float sval = 1.0;
float nmx, nmy;
PeasyCam cam;

void setup()
{
  //Screen Resolution
  size(1250,750,P3D); //screen proportions
  //fullScreen(P3D); // Or full screen
  
  noStroke();
  minim = new Minim(this);
  microphone = minim.getLineIn(Minim.STEREO, 4096); //repeat the song

  background(255);

  fftLog = new FFT(microphone.bufferSize(),microphone.sampleRate());
  fftLog.logAverages(1,2);  //adjust numbers to adjust spacing - orignal (1,2)
  float w = float (width/fftLog.avgSize());
  float x = w;
  float y = 0;
  float z = 50;
  float radius = 10;
  audio3D = new Waveform(x,y,z,radius);
}
void draw()
{
  background(0);
  directionalLight(126,126,126,sin(radians(frameCount)),cos(radians(frameCount)),1);
  ambientLight(102,102,102);
  
  //rotateX(-.5);
  //rotateY(-.5); 
  //cam = new PeasyCam(this, 100);
  //cam.setMinimumDistance(50);
  //cam.setMaximumDistance(500);
  

  if (frameCount>200)
  {
    for(int i = 0; i < fftLog.avgSize(); i++){
      float zoom = 1;
      float jitter = (fftLog.getAvg(i)*2);
      //println(jitter);
      PVector foc = new PVector(audio3D.x+jitter, audio3D.y+jitter, 0);
      PVector cam = new PVector(zoom, zoom, -zoom);
      camera(foc.x+cam.x+50,foc.y+cam.y+50,foc.z+cam.z,foc.x,foc.y,foc.z,1,1,0);  

    }

}
  //play the song
  fftLog.forward(microphone.mix);

  audio3D.update();
  audio3D.textdraw();

  if(record)
  {
    beginRaw(DXF, "output.dxf");
  }
  audio3D.plotTrace();

  if(record)
  {
    endRaw();
    record = false;
    println("Reccorded!");
  }
}
void stop()
{
  // always close Minim audio classes when you finish with them
  microphone.close();
  // always stop Minim before exiting
  minim.stop();
  super.stop();
}
class Waveform
{
  float x,y,z;
  float radius;

  PVector[] pts = new PVector[fftLog.avgSize()];

  PVector[] trace = new PVector[0];

  Waveform(float incomingX, float incomingY, float incomingZ, float incomingRadius)
  {
    x = incomingX;
    y = incomingY;
    z = incomingZ;
    radius = incomingRadius;
  }
  void update()
  {
    plot();
  }
  void plot()
  {
    for(int i = 0; i < fftLog.avgSize(); i++)
    {
      int w = int(width/fftLog.avgSize());

      x = i*w;
      y = frameCount*5;
      z = height/4-fftLog.getAvg(i)*15; //change multiplier to reduces height default '10'

      stroke(0);
      point(x, y, z);
      pts[i] = new PVector(x, y, z);
      //increase size of array trace by length+1
      trace = (PVector[]) expand(trace, trace.length+1);
      //always get the next to last
      trace[trace.length-1] = new PVector(pts[i].x, pts[i].y, pts[i].z);
    }
  }
  void textdraw()
  {
    for(int i =0; i<fftLog.avgSize(); i++){
      pushMatrix();
      translate(pts[i].x, pts[i].y, pts[i].z);
      rotateY(PI/2);
      rotateZ(PI/2);

      fill(255,200);
      // Display value on graph
      //text(round(fftLog.getAvg(i)*100),0,0,0);
      popMatrix();
    }
  }
  void plotTrace()
  {
    stroke(c); //draw lines between triangles, c is color input from key
    int inc = fftLog.avgSize();

    for(int i=1; i<trace.length-inc; i++)
    {
      if(i%inc != 0)
      {
        beginShape(TRIANGLE_STRIP);

        float value = (trace[i].z*100);
        float m = map(value, -500, 20000, 0, 255);
        fill(m*2, 125, -m*2, 140);
        vertex(trace[i].x, trace[i].y, trace[i].z);
        vertex(trace[i-1].x, trace[i-1].y, trace[i-1].z);
        vertex(trace[i+inc].x, trace[i+inc].y, trace[i+inc].z);
        vertex(trace[i-1+inc].x, trace[i-1+inc].y, trace[i-1+inc].z);
        endShape(CLOSE);
      }
    }
  }
}
void keyPressed()
{
  if (key == 'r') record = true;
  if (key == '1') c = color(1, 1); // no lines
  if (key == '2') c = color(255, 80); // orignal
}
