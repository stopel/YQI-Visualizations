import ddf.minim.*;
Minim minim;
AudioInput in;

/*
 * Daniel Gorelick
 * Processing Installation – Tell Me Everything Show @ Pop Allston
 */
Word quantum, sound, spencer, topel, kyle, serniak, luke, burkhart, florian, carle;
float scale = 40;
int mode;
int shifting = -1;
int resetting = 0;
int count = 0;
boolean reposition = true, title = false, name1=false, name2=false, name3=false, name4=false;
float start_x = width/2;
float start_y = height/2 + scale*3;

float sum;
boolean circles = true;
color c = color(255, 80);  // Define color 'c'

void setup() {
  fullScreen(1);
  //noSmooth();
  randomize();
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, 1024);
  
  quantum = new Word("quantum", start_x, start_y, scale);
  sound = new Word("sound", start_x, start_y +  scale*3, scale);
  spencer = new Word("spencer", start_x, start_y, scale);
  topel = new Word("topel", start_x, start_y +  scale*3, scale);
  kyle = new Word("kyle", start_x, start_y, scale);
  serniak = new Word("serniak", start_x, start_y +  scale*3, scale);
  luke = new Word("luke", start_x, start_y, scale);
  burkhart = new Word("burkhart", start_x, start_y +  scale*3, scale);
  florian = new Word("florian", start_x, start_y, scale);
  carle = new Word("carle", start_x, start_y +  scale*3, scale);
}

void draw() {
  // main loop logic 
  resetting++;
  count++;
  if (count == 600) {
    mode = floor(random(1,5));
    shifting = 1;
    resetting = 0;
  } else if (count == 660) {
    shifting = 0;
    reposition = true;
    mode = 0;
    count = 0;
  } else if (count % 60 == 0 && resetting > 200) {
    mode = floor(random(10)); 
    if (mode > 4) {
      mode = 0;
    }
  } else if (count % 10 == 0 && resetting > 200) {
    if (random(100) > 90) {
      mode = floor(random(1,5));
    }
  }
  sum = 0;
  last_radius_one = radius_one;
  last_radius_two = radius_two;
  radius_one = 0;
  radius_two = 0;
  for (int i = 0; i < in.bufferSize() - 1; i++) {
    sum += abs(in.left.get(i));
    if (i < in.bufferSize()/2) {
      radius_one += abs(in.left.get(i));
    } else {
      radius_two += abs(in.left.get(i));
    }
  }
  radius_one = radius_one_start + radius_one*3;
  radius_two = radius_two_start + radius_two*3;
  radius_one = lerp(last_radius_one, radius_one, 0.2);
  radius_two = lerp(last_radius_two, radius_two, 0.2);
  sum = sum/log(sum);
  
  // CIRLCES
  if (circles) {
    colorMode(HSB, 360, 255, 255, 255);
    blendMode(BLEND);
    if (frameCount % 600 == 0) {
      background(0);
      randomize();
    }
    radian_one += speed_one;
    radian_two += speed_two;
    hue_one += color_cycle_speed;
    hue_two += color_cycle_speed;
    if (hue_one > 360) hue_one = hue_one%360;
    if (hue_two > 360) hue_two = hue_two%360;

    fill(frameCount%360, 255, 30, decay_rate);
    strokeCap(SQUARE);
    noStroke();
    rect(0, 0, width, height);
    noFill();
   // strokeWeight(radius_two/15);

    // create lines using sin and cosine
    stroke(hue_one, color_saturation, color_value, 100);
    line(width/2 + sin(radian_one)*radius_one + sum, height/2 + cos(radian_one)*radius_one, width/2+ sin(radian_two)*radius_two + sum, height/2 + cos(radian_two)*radius_two);
    stroke(hue_two, color_saturation, color_value, 100);
    line(width/2 + sin(radian_one + PI)*radius_one - sum, height/2 + cos(radian_one + PI)*radius_one, width/2+  sin(radian_two + PI)*radius_two  - sum, height/2 + cos(radian_two + PI)*radius_two);

    // draw guiding circles
    strokeWeight(0.5);
    ellipse(width/2, height/2, radius_two*2, radius_two*2);
    stroke(hue_one, color_saturation, color_value, 100);
    ellipse(width/2, height/2, radius_one*2, radius_one*2);
  }

  // LINES
  //if (images) {
  //  stroke(255, 0, 0);
  //  strokeWeight(1);
  //  h_steps = width/lines_h.length;
  //  for (int i = 0; i < lines_h.length; i++) {
  //    line(h_steps*i + random(10), 0, h_steps*i  + random(10), height);
  //    line(0, h_steps*i  + random(10), width, h_steps*i  + random(10));
  //  }
  //}
  //// LETTERS
  colorMode(RGB);
  blendMode(ADD);
  strokeCap(ROUND);
  strokeWeight(scale/4);
  if (reposition) {
    start_x = random(width/2);
    start_y = random(height/2 + scale*5);
  }
    if (title == true){
  quantum.update(sum, mode, shifting, start_x, start_y);
  sound.update(sum, mode, shifting, start_x, start_y + scale*3);
    }
    else if (name1 == true) {
  spencer.update(sum, mode, shifting, start_x, start_y);
  topel.update(sum, mode, shifting, start_x, start_y + scale*3);
    }
    else if (name2 == true) {
  kyle.update(sum, mode, shifting, start_x, start_y);
  serniak.update(sum, mode, shifting, start_x, start_y + scale*3);
    }
   else if (name3 == true) {
  luke.update(sum, mode, shifting, start_x, start_y);
  burkhart.update(sum, mode, shifting, start_x, start_y + scale*3);
    }
   else if (name4 == true) {
  florian.update(sum, mode, shifting, start_x, start_y);
  carle.update(sum, mode, shifting, start_x, start_y + scale*3);
    }
    else {
    }
  shifting = 2;
  reposition = false;
}

//CIRCLES PROJECT
float hue_one, hue_two, speed_one, speed_two, radius_one, radius_two, radian_one, radian_two, line_width, color_saturation, color_value, color_cycle_speed, decay_rate, last_radius_one, last_radius_two, radius_one_start, radius_two_start;
int tempX, tempY, offset;
int control_width = 170/2;
float speed_limit = 0.01;

void randomize() {
  hue_one = random(360);
  hue_two = random(360);
  radius_one_start = random(40, 100);
  radius_two_start = random(100, 200);
  speed_one = random(-speed_limit/2, speed_limit/2);
  speed_two = random(-speed_limit/2, speed_limit/2);
  line_width = random(1, 25);
  color_saturation = random(150, 225);
  color_value = 150;
  color_cycle_speed = random(0, 6);
  color_cycle_speed = (color_cycle_speed > 3) ? 0: color_cycle_speed;
  decay_rate = 25;
}

void keyPressed() 
{
  switch(key) 
    {
// toggle nothing
    case '1':
    title = false;
    name1 = false;
    name2 = false;
    name3 = false;
    name4 = false;    
    break;   
// toggle title
    case '2':
    title = true;
    name1 = false;
    name2 = false;
    name3 = false;
    break; 
// toggle Spencer
    case '3':
    title = false;
    name1 = true;
    name2 = false;
    name3 = false;
    break; 
// toggle Kyle
    case '4':
    title = false;
    name1 = false;
    name2 = true;
    name3 = false;
    name4 = false;    
    break; 
// toggle Luke
    case '5':
    title = false;
    name1 = false;
    name2 = false;
    name3 = true;
    name4 = false;
    break; 
// toggle Florian
    case '6':
    title = false;
    name1 = false;
    name2 = false;
    name3 = false;
    name4 = true;    
    break;         
    }
}
