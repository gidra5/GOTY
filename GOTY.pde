import java.lang.Thread;

final color FRIENDLY=color(0,255,0);
final color NEUTRAL=color(150);
final color ENEMY=color(255,0,0);
final color PLAYER=color(0,0,255);
final int mapWidth=10000, mapHeight=10000;
boolean showMap;
Button switchShowMap; 
float scale;

Thread mouseListiner, movePlayer, mapRender;

volatile Player p=new Player();
volatile Mob[] mobs=new Mob[100];
volatile Unit[] units=new Unit[200];
volatile UnitBoss[] bosses=new UnitBoss[24];
volatile City[] cities=new City[25];
volatile Kingdom kingdom=new Kingdom();
Mob[] allMobs=new Mob[350];

volatile PGraphics map, unitsMap; 

void setup()
{
  //Use OpenGL
  fullScreen();
  frameRate(300);
  //Thread.currentThread().setPriority(Thread.MAX_PRIORITY);
  
  switchShowMap=new Button(width-125,25,100,40,15,color(50,70,90),"Map",15);
  
  map=createGraphics(height,height);
  unitsMap=createGraphics(height-11,height-11);
  scale=map(1,0,10000,0,height-11);
  
  for(int i=0;i<100;i++)
    allMobs[i]=mobs[i] =new Mob();
  for(int i=0;i<200;i++)
    allMobs[i+100]=units[i]=new Unit();
  for(int i=0;i<24;i++)
    allMobs[i+300]=bosses[i]=new UnitBoss();
  for(int i=0;i<25;i++)
    allMobs[i+324]=cities[i]=new City();
  allMobs[349]=p;
  
  for(int a=0;a<2;a++)
  {
    //mouse[a]=new MouseTouch();
  }
  
  bulletParticles.start();
  
  mapRender=new Thread(new Runnable()
  {
    public void run()
    {
      map.beginDraw();
      map.fill(255);
      map.rect(1,1,map.width-2,map.height-2);
      map.rect(5,5,map.width-10,map.height-10);
      map.endDraw();
      unitsMap.beginDraw();
      unitsMap.background(255);
      unitsMap.noSmooth();
      unitsMap.noStroke();
      unitsMap.ellipseMode(CENTER);
      for(int i=0;i<350;i++)
      {
        Mob m=allMobs[i];
        if(m.regard==Regard.LOW_FRIENDLY || m.regard==Regard.FRIENDLY || m.regard==Regard.HIGH_FRIENDLY)
          unitsMap.fill(FRIENDLY);
        else if(m.regard==Regard.NEUTRAL)
          unitsMap.fill(NEUTRAL);
        else if(m.regard==Regard.ENEMY)
          unitsMap.fill(ENEMY);
        else
          unitsMap.fill(PLAYER);
        unitsMap.ellipse( m.x*scale, m.y*scale, m.r/2, m.r/2);
      } 
      while(true)
      { 
        for(int i=0;i<350;i++)
        {     
          Mob m=allMobs[i];
          if(dist(m.x,m.y,m.px,m.py)>12.5f || i!=349 && dist(m.x,m.y,p.x,p.y)<(m.r/2+p.r/2)/scale)
          {
            unitsMap.fill(255);
            unitsMap.ellipse(m.px*scale,m.py*scale,m.r/2,m.r/2);
            if(m.regard==Regard.LOW_FRIENDLY || m.regard==Regard.FRIENDLY || m.regard==Regard.HIGH_FRIENDLY)
              unitsMap.fill(FRIENDLY);
            else if(m.regard==Regard.NEUTRAL)
              unitsMap.fill(NEUTRAL);
            else if(m.regard==Regard.ENEMY)
              unitsMap.fill(ENEMY);
            else
              unitsMap.fill(PLAYER);
            unitsMap.ellipse( m.x*scale, m.y*scale, m.r/2, m.r/2);
            m.px=m.x;
            m.py=m.y;
          }
        }
        //map.set(5,5,unitsMap);
      }
    }
  });
  mapRender.setPriority(Thread.MIN_PRIORITY);
  mapRender.start();
  /*movePlayer=new Thread(new Runnable()
  {
    public void run()
    {
      long lastTime=millis();
      float x,y;
      while(true)
      {
        for(int i=0;i<2;i++)
        {
          if(switchShowMap.pressed(mouse[i]) && doing[i])
          {
            showMap=!showMap;
            doing[i]=false;
          }
          dist= dist( mouse[i].px, mouse[i].py, mouse[i].x, mouse[i].y);
          if(mouse[i].pressed && dist>20 && mouse[i].px>width/2 )
            p.direction.set( (mouse[i].x- mouse[i]. px)/dist
                           , (mouse[i].y- mouse[i]. py)/dist);
          if(!mouse[0].pressed && !mouse[1].pressed)
            p.direction.set(0,0);
          if(!mouse[i].pressed)
            doing[i]=true;
        }
        x=p.x;
        y=p.y;
        if(x>=mapWidth && p.direction.x>0 )
        {
          p.direction.x=0;
          p.x=mapWidth;
        }
        else if(x<=0 && p.direction.x<0)
        {
          p.direction.x=0;
          p.x=0;
        }
        if(y>=mapHeight && p.direction.y>0)
        {
          p.direction.y=0;
          p.y=mapHeight;
        }
        else if(y<=0 && p.direction.y<0) 
        {
          p.direction.y=0;
          p.y=0;
        }
        p.x+=p.direction.x* p.v*(millis()-lastTime)/1000*2;
        p.y+=p.direction.y* p.v*(millis()-lastTime)/1000;
        if(p.x!=p.x || p.y!=p.y)
        {
          p.x=x;
          p.y=y;
        }
        lastTime=millis();
      }
    }
  });*/
 // movePlayer.setPriority(2);
  // movePlayer.start();
}
void draw()
{
  background(255);
  text(frameRate,10,10);
  fill(PLAYER);
  ellipse(width/2,height/2,10,10);
  fill(0);
  noStroke();
  text(int(p.x)+" "+int(p.y),100,140);
  // for(int a=0; a<2;a++)
  //   if(mouse[a].pressed && mouse[a].px>width/2)
  //     ellipse( mouse[a].px, mouse[a].py,4,4);
  stroke(1);
  translate(width/2-p.x,height/2-p.y);
  for(int i=0;i<349;i++)
  {
    Mob m=allMobs[i];
    if( m.x>p.x-width/2-m.r && m.x<p.x+width/2+m.r && m.y>p.y-height/2-m.r && m.y<p.y+height/2+m.r)
    {
      if(m.regard==Regard.LOW_FRIENDLY || m.regard==Regard.FRIENDLY || m.regard==Regard.HIGH_FRIENDLY)
      {
        fill(FRIENDLY);
      }
      if(m.regard==Regard.NEUTRAL)
      {
        fill(NEUTRAL);
      }
      if(m.regard==Regard.ENEMY)
      {
        fill(ENEMY);
      }
      ellipse(m.x,m.y,m.r,m.r);
    }
  }
  for (int i=bulletParticles.particles.size()-1;i>0;i--) 
  {
    PVector pos=bulletParticles.particles.get(i).pos,v=bulletParticles.particles.get(i).vel;
    if( pos.x>p.x-width/2 && pos.x<p.x+width/2 && pos.y>p.y-height/2 && pos.y<p.y+height/2)
      line(pos.x, pos.y, pos.x+v.x/50, pos.y+v.y/50);
    println(p.x,p.y, pos.x, pos.y, pos.x+v.x/50, pos.y+v.y/50);
  }
  if(showMap)
    set((width-height)/2,0,map);
  switchShowMap.display();
}