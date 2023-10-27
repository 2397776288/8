PFont font;
Particle[] particles;

void setup() {
  size(1000, 900);
  background(255);
  smooth();
  
  // 加载字体
  font = createFont("Arial", 200);
  textFont(font);
  
  // 设置文本大小
  textSize(200);
  
  // 获取字体轮廓中的所有点
  PGraphics tempGraphics = createGraphics((int)textWidth("hello"), (int)(textAscent() + textDescent())); // 创建临时PGraphics对象并设置尺寸为文本大小
  tempGraphics.beginDraw();
  tempGraphics.textFont(font);
  tempGraphics.textSize(100); // 将文本大小调整为100
  tempGraphics.text("hello", 0, tempGraphics.height); // 在临时PGraphics对象上绘制文本
  tempGraphics.endDraw();
  
  tempGraphics.loadPixels(); // 加载像素数组
  
  // 创建形状并添加顶点
  PShape shape = createShape();
  shape.beginShape();
  shape.noStroke();
  shape.fill(0);
  
  int numPoints = 0;
  for (int i = 0; i < tempGraphics.pixels.length; i++) {
    if (tempGraphics.pixels[i] != color(255)) { // 如果像素不是白色，则将其作为顶点添加到形状中
      int x = i % tempGraphics.width;
      int y = i / tempGraphics.width;
      shape.vertex(x * 4 + width/2 - textWidth("hello")*2, y * 4 + height/2 - textAscent()*2); // 将顶点的位置乘以4来放大形状
      numPoints++;
    }
  }
  
  shape.endShape();

  particles = new Particle[numPoints];
  
  // 将每个顶点转换为一个粒子
  for (int i = 0; i < numPoints; i++) {
    PVector pos = shape.getVertex(i);
    particles[i] = new Particle(pos.x, pos.y);
  }
}

void draw() {
  background(255);
  
  // 更新并绘制每个粒子
  for (Particle p : particles) {
    p.applyGravity();
    p.update();
    p.display();
  }
}

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  
  Particle(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0);
    lifespan = 255;
  }
  
  void applyGravity() {
    acceleration.add(0, 0.1); // 重力加速度
  }
  
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 2;
  }
  
  void display() {
    noStroke();
    fill(0, lifespan);
    ellipse(position.x, position.y, 4, 4);
  }
}
