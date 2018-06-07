import themidibus.*; //Import Midi library
import processing.sound.*;
float bpm = 80;
float minute = 60000;
float interval = minute / bpm;
int time;
int beats = 0;
MidiBus drums;

AudioDevice audioServer;
SoundFile file;

int snarePitch = 10;
int basePitch = 11;
int highHatPitch = 12;
int rightPitch = 13;
ArrayList<Note> snare = new ArrayList<Note>();
ArrayList<Note> base = new ArrayList<Note>();
ArrayList<Note> highHat = new ArrayList<Note>();
ArrayList<Note> right = new ArrayList<Note>();

void setup() {
  size (700, 500);
  background(0);
  //This is a different way of listing the available Midi devices.
  println("Available MIDI Devices:"); 
  String[] available_inputs = MidiBus.availableInputs(); //Returns an array of available input devices
  for (int i = 0; i < available_inputs.length; i++) System.out.println("["+i+"] \""+available_inputs[i]+"\"");
  drums = new MidiBus(this, 0, -1);

  audioServer = new AudioDevice(this, 44100, 128);
  file = new SoundFile(this, "sample.wav");
  time = millis();
}

void draw() {
  background(0);
  if (millis() - time > interval ) {
    file.play();
    ellipse(width/2, height/2, 50, 50);
    beats ++;
    time = millis();
  }
  //Draw Notes
  for (Note note : base) {
    note.display();
  } 
  for (Note note : snare) {
    note.display();
  } 
  for (Note note : base) {
    note.display();
  } 
  for (Note note : base) {
    note.display();
  } 
  text("bpm: "+bpm, 10, 70);
}


void keyPressed() {
  if (key == ' ') {
    println("added");
    base.add(new Note(millis(), 50,interval));
  }
}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
  if(pitch == snarePitch)
  snare.add(new Note(millis(), velocity,interval));
  else if(pitch == basePitch)
  base.add(new Note(millis(), velocity,interval));
  else if(pitch == highHatPitch)
  highHat.add(new Note(millis(), velocity,interval));
  else if(pitch == rightPitch)
  right.add(new Note(millis(), velocity,interval));
}
