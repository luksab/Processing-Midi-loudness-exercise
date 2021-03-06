class Note 
{
  int time;
  int vel;
  float interval;

  Note(int time, int vel) {
    this.time = time;
    this.vel = vel;
  }

  Note(int time, int vel, float interval) {
    this.time = time;
    this.vel = vel;
    this.interval = interval;
  }

  void display() {   
    ellipse(width-(((millis()-time)/(interval*12))*width), map(vel,0,255,height-10,10), 10, 10);
  }
}
