import themidibus.*; //Import Midi library
import processing.sound.*;
import java.util.*;
float bpm = 80;
float minute = 60000;
float interval = minute / bpm;
int time;
boolean metronome = true;
boolean demo = false;
int demoVel = 15;
boolean demoUp = true;
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
Note snareHit;
Note baseHit;
Note highHatHit;
Note rightHit;

boolean debug = false;

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
  String[] lines = loadStrings("config.cfg");
  try {
    print("there are " + lines.length + " lines in the config.");
    if (lines.length == 4) {
      println(" this is good.");
      println("Your config:");
      println("snare: "+lines[0]);
      println("base: "+lines[1]);
      println("highHat: "+lines[2]);
      println("right: "+lines[3]);
      snarePitch = Integer.parseInt(lines[0]);
      basePitch = Integer.parseInt(lines[1]);
      highHatPitch = Integer.parseInt(lines[2]);
      rightPitch = Integer.parseInt(lines[3]);
    } else
      println(" this is bad!");
  }
  catch(Exception e) {
    println("The error above means that no config file was found. Will generate one for you.");
    String words = "10 11 12 13";
    String[] list = split(words, ' ');
    saveStrings("config.cfg", list);
  }
}

void draw() {
  background(0);
  if (millis() - time > interval ) {
    if (metronome) {
      file.play();
      ellipse(width/2, height/2, 50, 50);
    }
    if (demo) {
      snare.add(new Note(millis(), 20+(int)random(-5, 5), interval));
      delay(2);
      base.add(new Note(millis(), 22+(int)random(-5, 5), interval));
      if (demoUp)
        demoVel += random(20);
      else demoVel -= random(20);
      if (demoVel > 235) {
        demoUp = false;
        println("false");
      }
      if (demoVel < 15) {
        demoUp = true;
        println("true");
      }
      highHat.add(new Note(millis(), demoVel, interval));
      delay(2);
      right.add(new Note(millis(), 22+(int)random(-5, 5), interval));
    }
    time = millis();
  }
  //Draw Notes
  fill(25, 25, 112);
  for (Iterator<Note> it = base.iterator(); it.hasNext(); ) {
    Note note = it.next();
    note.display();
    if ((note.time+(interval*12))<time) {
      it.remove();
    }
  } 
  fill(255, 150, 0);
  for (Iterator<Note> it = snare.iterator(); it.hasNext(); ) {
    Note note = it.next();
    note.display();
    if ((note.time+(interval*12))<time) {
      it.remove();
    }
  } 
  fill(124, 252, 0);
  for (Iterator<Note> it = highHat.iterator(); it.hasNext(); ) {
    Note note = it.next();
    note.display();
    if ((note.time+(interval*12))<time) {
      it.remove();
    }
  } 
  fill(147, 112, 219);
  for (Iterator<Note> it = right.iterator(); it.hasNext(); ) {
    Note note = it.next();
    note.display();
    if ((note.time+(interval*12))<time) {
      it.remove();
    }
  } 
  fill(255);
  if (metronome)
    text("bpm: "+bpm, 10, 70);

  //Add hitsnow to avoid concurrency issues
  if (!(snareHit == null)) {
    snare.add(snareHit);
    snareHit = null;
  }
  if (!(baseHit == null)) {
    base.add(baseHit);
    baseHit = null;
  }
  if (!(highHatHit == null)) {
    highHat.add(highHatHit);
    highHatHit = null;
  }
  if (!(rightHit == null)) {
    right.add(rightHit);
    rightHit = null;
  }
}


void keyPressed() {
  if (key == ' ') {
    if (!demo) 
      println("start demoMode");
    else
      println("stop demoMode");
    demo = !demo;
  } else if (key == 'd')
    debug = !debug;
  else if (key == 'm')
    metronome = !metronome;
  else if (key == '+') {
    bpm += 1;
    minute = 60000;
    interval = minute / bpm;
  } else if (key == '-') {
    bpm -= 1;
    minute = 60000;
    interval = minute / bpm;
  }
}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  if (debug) {
    println();
    println("Note On:");
    println("--------");
    println("Channel:"+channel);
    println("Pitch:"+pitch);
    println("Velocity:"+velocity);
  }
  if (pitch == snarePitch)
    //snare.add(new Note(millis(), velocity, interval));
    snareHit = new Note(millis(), velocity, interval);
  else if (pitch == basePitch)
    //base.add(new Note(millis(), velocity, interval));
    baseHit = new Note(millis(), velocity, interval);
  else if (pitch == highHatPitch)
    //highHat.add(new Note(millis(), velocity, interval));
    highHatHit = new Note(millis(), velocity, interval);
  else if (pitch == rightPitch)
    //right.add(new Note(millis(), velocity, interval));
    rightHit = new Note(millis(), velocity, interval);
}
