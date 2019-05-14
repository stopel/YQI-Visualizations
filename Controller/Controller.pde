// Access the values of a MIDI Controller to use as variable
//Help from jeremydouglass' comment on https://forum.processing.org/two/discussion/26537/new-library-control-and-tweak-your-sketches-using-midi-controller-novation-launch-control

import themidibus.*;
MidiBus myBus;

int midiDevice = 0, A;

void setup() {
 // List all our MIDI devices
MidiBus.list();

// Connect to input, output
myBus = new MidiBus(this, midiDevice, 1);

  size(500, 500);
  background(255);
}
 
void draw() {

}

 
// Called by TheMidiBus library each time a knob, slider or button
// changes on the MIDI controller.
void controllerChange(int channel, int number, int value) {
  println(channel, number, value);
  if(number == 16) {  // korg nanoKontrol2  knob 1
    // do something with value
A = value; //A prints the value of Knob 1
println(A);
  }
  if(number == 33) {  // korg nanoKontrol scene 1, button 1 bottom
    // do something with value

  }
  if(number == 2) {   // korg nanoKontrol scene 1, slider 1
    // do something with value
  }
}
