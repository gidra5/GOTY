class ParticleSystem extends Thread {
  volatile ArrayList<Particle> particles;

  ParticleSystem() 
  {
    particles = new ArrayList<Particle>();
  }

  void addParticle(Mob owner, PVector d) //кто и в какую сторону выстрелил
  {
    ArrayList<Mob> toTest=new ArrayList<Mob>();
    for(Mob m : allMobs) // определяем на будущее каких мобов проверять на факт попадания
    {
      if(m.regard==Regard.ENEMY)  //попасть можем только в врагов
      {
        if(m.x<=mapWidth/2 && d.x<=0 && m.y<=mapHeight/2 && d.y<=0 ||
           m.x>=mapWidth/2 && d.x>=0 && m.y>=mapHeight/2 && d.y>=0 ||
           m.x<=mapWidth/2 && d.x<=0 && m.y>=mapHeight/2 && d.y>=0 ||
           m.x>=mapWidth/2 && d.x>=0 && m.y<=mapHeight/2 && d.y<=0 ) // мы попадем в моба ток если он в тойже четверти карты что и вектор направления
        {
          toTest.add(m);
        }
      }
    }
    particles.add(new Particle(owner,d,toTest));
  }

  public void run() //в отдельном потоке проверяем на факт попадания
  {
    while(true)
    {
      for (int i=particles.size()-1;i>0;i--) 
      {
        Particle particle=particles.get(i);
        particle.update();
        if ( particle.hit() || particle.pos.x>mapWidth || particle.pos.x<0 || particle.pos.y>mapHeight || particle.pos.y<0) 
        {
          particles.remove(i);  //если попали или вышли за карту-удаляем обьект
        }
      }
    }
  }
}


// A simple Particle class

class Particle 
{
  PVector pos, vel, pPos;
  ArrayList<Mob> test;
  Mob owner;
  long lastTime=millis();

  Particle(Mob owner, PVector dir, ArrayList<Mob> toTest) 
  {
    test=toTest;
    this.owner=owner;
    vel=new PVector(dir.x*600,dir.y*600);
    pos= new PVector(owner.x,owner.y);
  }

  // Method to update position
  void update() //executeTime нужен что бы пуля проходила 400 пикселей в секунду а не в кадр
  {
    long executeTime=millis()-lastTime;
    //println(executeTime);
    pPos=pos;
    pos.x+=vel.x*executeTime/1000;
    pos.y+=vel.y*executeTime/1000;
    lastTime=millis();
  }
  boolean hit()
  {
    for(Mob m : test)
    {
      if(abs((m.x+pos.x)*vel.y+(m.y-pos.y)*vel.x)/400<m.r+2)  //если расстояние от центра моба до прямой AB, где
      {                                                       //А(pos) и В(pos-vel)(надо изменить на В(pPos), более "радиуса моба"+2 (в формуле мог накосячить)
        m.damaged(owner);                                     //то попадание засчитываеться и наноситься урон от имени выстрелившего
        return true;
      }
    }
    return false;
  }
}