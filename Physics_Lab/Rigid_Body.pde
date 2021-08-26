//固定碰撞体
class StaticBody {
  float x;
  float y;  //全局位置坐标
  float w;
  float h;  //大小
  
  Body body;  //碰撞体
  
  PImage img;  //贴图
  PImage texture;  //纹理
  
  StaticBody(float x,float y, float w, float h, float a, PImage img, PImage texture) {  //实例（x坐标，y坐标，长，宽，倾角，贴图，纹理）
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.img = img;
    this.texture = texture;
    
    PolygonShape sd = new PolygonShape();
    
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    
    sd.setAsBox(box2dW, box2dH);
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.angle = a;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    body = box2d.createBody(bd);
    
    body.createFixture(sd, 1);
  }
  
  void display(int mode) {  //显示（mode = 1 贴图 / mode = 2 轮廓 / mode = 3 纹理）
    float a;
    switch(mode) {
      case 1:
        imageMode(CENTER);
        a = body.getAngle();
        pushMatrix();
        translate(x, y);
        rotate(-a);
        image(img, 0, 0);
        popMatrix();
        break;
      case 2:
        fill(200);
        stroke(0);
        strokeWeight(1);
        rectMode(CENTER);
        a = body.getAngle();
        pushMatrix();
        translate(x, y);
        rotate(-a);
        rect(0, 0, w, h);
        popMatrix();
        break;
      case 3:
        noFill();
        noStroke();
        rectMode(CENTER);
        a = body.getAngle();
        pushMatrix();
        translate(x, y);
        rotate(-a);
        beginShape();
        texture(texture);
        vertex(-w/2, -h/2);
        vertex(w/2, -h/2);
        vertex(w/2, h/2);
        vertex(-w/2, h/2);
        endShape(CLOSE);
        popMatrix();
      default:
        break;
    }
  }
}

//非固定碰撞体
class DynamicBody {
  float x;
  float y;  //全局位置坐标
  float w;
  float h;  //大小
  
  float LV;  //线速度
  float AV;  //角速度
  
  Body body;  //碰撞体
  
  PImage img;  //贴图
  PImage texture;  //纹理
  
  Vec2[] vertices;  //轮廓
  
  DynamicBody(float x, float y, PImage img, PImage texture, Vec2[] vertices) {  //实例（x坐标，y坐标，贴图，纹理，边缘）
    _makeBody(x, y, img, texture, vertices);
  }
  
  void killBody() {  //销毁碰撞体
    box2d.destroyBody(body);
  }
  
  void display(int mode) {  //显示（mode = 1 贴图 / mode = 2 轮廓 / mode = 3 纹理）
    Vec2 pos;
    Fixture f;
    PolygonShape ps;
    switch(mode) {
      case 1:
        pos = box2d.getBodyPixelCoord(body);
        float a = body.getAngle();
        f = body.getFixtureList();
        ps = (PolygonShape) f.getShape();
        imageMode(CENTER);
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(-a);
        image(img, 0, 0);
        popMatrix();
        break;
      case 2:
        pos = box2d.getBodyPixelCoord(body);
        a = body.getAngle();
        f = body.getFixtureList();
        ps = (PolygonShape) f.getShape();
        rectMode(CENTER);
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(-a);
        fill(200);
        stroke(0);
        strokeWeight(1);
        beginShape();
        for (int i = 0; i < ps.getVertexCount(); i++) {
          Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
          vertex(v.x, v.y);
        }
        endShape(CLOSE);
        popMatrix();
        break;
      case 3:
        pos = box2d.getBodyPixelCoord(body);
        a = body.getAngle();
        f = body.getFixtureList();
        ps = (PolygonShape) f.getShape();
        rectMode(CENTER);
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(-a);
        noFill();
        noStroke();
        beginShape();
        texture(texture);
        for (int i = 0; i < ps.getVertexCount(); i++) {
          Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
          vertex(v.x, v.y);
        }
        endShape(CLOSE);
        popMatrix();
        break;
      default:
        break;
    }
  }
  
  void _makeBody(float x, float y, PImage img, PImage texture, Vec2[] vertices) {  //新建碰撞体
    Vec2 center = new Vec2(x, y);
    this.x = x;
    this.y = y;
    this.img = img;
    this.texture = texture;
    PolygonShape sd = new PolygonShape();
    
    sd.set(vertices, vertices.length);
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);
    
    body.createFixture(sd, 1);
  }
  
  Vec2 _getPos() {  //获取全局坐标
    Vec2 pos = box2d.getBodyPixelCoord(body);
    this.x = pos.x;
    this.y = pos.y;
    return pos;
  }
  
  void setLV(float x, float y) {  //设置线速度
    Vec2 LV = new Vec2(x, y);
    body.setLinearVelocity(LV);
  }
  
  void setAV(float AV) {  //设置角速度
    body.setAngularVelocity(AV);
  }
}
