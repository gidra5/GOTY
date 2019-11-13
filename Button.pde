class Button
{
  private int x,y,w,h;
  private PGraphics button;
  Button(int x,int y,int w,int h,float r, color c, String text,float textSize)
  {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    button=createGraphics(w+1,h+1);
    button.beginDraw();
    button.fill(c);
    button.rect(1,1,w,h,r);
    button.fill(0);
    button.textAlign(CENTER,CENTER);
    button.textSize(textSize);
    button.text(text,w/2+1,1+h/2);
    button.textAlign(TOP,LEFT);
    button.endDraw();
  }
  boolean pressed(/*MouseTouch mouse*/)
  {
    return false; //(mouse.px>x && mouse.px<x+w && mouse.py>y && mouse.py<y+h && mouse.pressed);
  }
  void display()
  {
    set(x,y,button);
  }
}