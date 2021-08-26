import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing box2d;

ArrayList<StaticBody> s;
ArrayList<DynamicBody> d;

Vec2[] vertices;

void setup() {
  size(1600,900);
  surface.setTitle("Physics_Lab");
  cursor(CROSS);
  frameRate(120);
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  vertices = new Vec2[4];
  vertices[0] = box2d.vectorPixelsToWorld(new Vec2(-15, 15));
  vertices[1] = box2d.vectorPixelsToWorld(new Vec2(15, 15));
  vertices[2] = box2d.vectorPixelsToWorld(new Vec2(15, -15));
  vertices[3] = box2d.vectorPixelsToWorld(new Vec2(-15, -15));
  
  box2d.setGravity(0, -40);
   
  d = new ArrayList<DynamicBody>();
  s = new ArrayList<StaticBody>();
  
  s.add(new StaticBody(width/2, height-40, width-40, 40, 0, null, null));
}

void draw() {
  background(255);
  
  box2d.step();
  
  for (StaticBody _s: s) {
    _s.display(2);
  }
  
  for (DynamicBody _d: d) {
    _d.display(2);
  }
}

void mousePressed() {
  DynamicBody _d = new DynamicBody(mouseX, mouseY, null, null, vertices);
  d.add(_d);
}
void keyPressed() {
  if(keyCode != 32) return;
  int i = d.size()-1;
  if(i >= 0)
  {
    DynamicBody _d = d.get(i);
    _d.killBody();
    d.remove(i);
  }
}
