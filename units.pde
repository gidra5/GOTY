import java.lang.Math;
ParticleSystem bulletParticles=new ParticleSystem();  // система частиц в которой храняться все частицы

enum Regard //отношение к чему либо
{
  ENEMY,LOW_FRIENDLY,FRIENDLY,HIGH_FRIENDLY,NEUTRAL,GENIUS; //low_friendly - ты не пойдешь на смерь ради этого; 
}                                                           //high_friendly - готов положить жизнь ради этого;
enum AIState  //состояние ИИ                                //GENIUS - это ты
{
  SEARCH_TARGET,TARGET_FOUND, ATTACK, USING_ITEMS;
}
enum AITarget  //цель ИИ
{
  FIND_NEW_BOSS, TREAD_BOSS, SURVIVE, FIND_MOB, FIND_UNIT, DEFEND_BOSS, TRADE ;
}
enum ID //список айди для материалов
{
  
}
enum Recipe // рецепты для крафтов
{
  
}
class Mob
{
  int r;
  AIState state;
  AITarget target;
  Unit targetToAttack;
  Regard regard; //отношение к игрокe, у мобов всегда враждебное
  PVector direction;
  float distToPlayer;
  float x,y,px,py; //x,y - позиция ; px,py - позиция котрую надо закрасить для рендера карты
  float v0=150f, hp0=100f, def, dmg0=10f,range0=400f,atkSpeed=20f; //параметры моба
  float v=v0, hp=hp0, dmg=dmg0, range=range0,currentHP=hp;
  int lvl=1,expNow=0, expNext=200;
  Armor armor;
  Weapon weapon;
  Boots boots;
  Backpack backpack;
  Mob()
  {
    direction=new PVector(0,0);
    armor=new Armor(this);
    weapon=new Weapon(this); 
    boots=new Boots(this);
    backpack=new Backpack(this);
    r=4;
    regard=Regard.ENEMY;
    state=AIState.SEARCH_TARGET;
    target=AITarget.FIND_UNIT;
    px=x=random(mapWidth);
    py=y=random(mapHeight);
  }
  void dead(Mob u)
  {
    u.addExp((int)Math.round(40*Math.exp(u.lvl-lvl)));
    direction.set(0,0);
    armor=new Armor(this);
    weapon=new Weapon(this); 
    boots=new Boots(this);
    backpack=new Backpack(this);
    lvl=1;
    expNow=0;
    expNext=200; 
    atkSpeed=20f;
    v0=10f;
    hp0=100f;
    def=0f;
    dmg0=10f;
    range0=400f;
    while( x>p.x-width/2-r && x<p.x+width/2+r && y>p.y-height/2-r && y<p.y+height/2+r )
    {
      x=random(mapWidth);
      y=random(mapHeight);
    }
    dropItems();
  }
  void addExp(int exp)
  {
    expNow+=exp;
    if(expNow>expNext)
    {
      lvl++;
      atkSpeed*=1.5;
      def=lvl/2;
      dmg0*=1.1;
      hp0*=1.25;
      def*=1.05;
      v0*=1.2;
      range0*=1.05;
      expNow-=expNext;
      expNext*=2;
    }
  }
  void damaged(Mob u)
  {
    currentHP-=u.dmg+u.weapon.dmg;
    if(currentHP<=0)
      dead(u);
  }
  private void think()
  {
    
  }
  void move()
  {
    this.think();
  }
  void attack()
  {
    
  }
  void dropItems()
  {
    new Thread(new Runnable()
    {
      public void run()
      {
        ArrayList<Item> items=new ArrayList<Item>();
        items.add(armor);
        items.add(weapon);
        items.add(boots);
        items.add(backpack);/*
        while(true)
        {
          for(Mob m : allMobs)
          {
            
          }
        }*/
      }
    }).start();
  }
}

class Unit extends Mob implements Recruitable
{     
  String name="";
  color c=NEUTRAL;
  //float forging,       //атрибуты типа удачи, меткости и тд
  ArrayList<Item> inventory=new ArrayList<Item>(104);
  UnitBoss master;
  Unit()
  {
    r=6;
    regard=Regard.NEUTRAL;
  }
  void recruited(UnitBoss boss)
  {
    master=boss;
  }
  void unrecruited()
  {
    master=null;
    println("sad");
  }
  void refused(UnitBoss boss)
  {
    println("sad, boss"+boss.name+"refused");
  }
  void requestJoin(UnitBoss boss)
  {
    boss.recieveRequests(this);
  }
  private void think()
  {
    
  }
}
class Player extends UnitBoss
{ 
  Player()
  {
    super();
    regard=Regard.GENIUS;
    weapon=new Gun(this);
  }
  void attack(/*MouseTouch m*/)
  {
    //println("wtf");
    // if(weapon.TYPE == Weapon.GUN && m.px<width/2)
    // {
    //   ((Gun)weapon).atkDirection.set((m.x-m.px)/dist(m.x,m.y,m.px,m.py),
    //                                  (m.y-m.py)/dist(m.x,m.y,m.px,m.py));
    //   ((Gun)weapon).shoot();
    // }
    // else
    // {
        
    // }
  }
}
class UnitBoss extends Unit implements Recruiter
{
  ArrayList<Unit> units=new ArrayList<Unit>();
  UnitBoss()
  {
    super();
    r=10;
  }
  private void think()
  {
    
  }
  void recruit(Unit u)
  {
    units.add(u);
    u.recruited(this);
  }
  void unrecruit(Unit u)
  {
    u.unrecruited();
    units.remove(u);
  }
  void recieveRequests(Unit u)
  {
    if(true)
      recruit(u);
    else
      u.refused(this);
  }
  void leaved(Unit u)
  {
    units.remove(u);
    println("sad");
  }
  void leave()
  {
    master.leaved(this);
    master=null;
  }
}
class City extends UnitBoss
{
  int materialsPerSecond=10;
  City()
  {
    r=14;
  }
  private void think()
  {
    
  }
  @Override 
  void move()
  {
    this.think();
    
  }
}
class Kingdom extends City
{
  Kingdom()
  {
    super();
  }
  private void think()
  {
    
  }
}
interface Recruiter
{
  void recruit(Unit u);
  void recieveRequests(Unit u);
  void unrecruit(Unit u);
  void leave();
  void leaved(Unit u);
}
interface Recruitable
{
  void requestJoin(UnitBoss boss);
  void recruited(UnitBoss boss);
  void refused(UnitBoss boss);
 // void leave();
  void unrecruited();
}
class Item
{
  Mob owner;
  boolean dropped;
  float droppedX,droppedY;
  String name;
  short amount;
  int price;
  Item(Mob owner)
  {
    this.owner=owner;
    amount=1;
  }
  void dropped()
  {
    dropped=true;
    droppedX=owner.x;
    droppedY=owner.y;
   // owner=null;
  }
  void taken(Mob m)
  {
    owner=m;
    dropped=false;
    droppedX=0;
    droppedY=0;
  }
}
class Material extends Item
{
  private ID id;
  Material (Mob owner)
  {
    super(owner);
  }
  void setID(ID id)
  {
    this.id=id;
  }
  ID getID()
  {
    return this.id;
  }
}
class Money extends Item
{
  Money(Mob owner)
  {
    super(owner);
    price=100;
  }
}
class Ammunition extends Item
{
  int bonus;
  Ammunition (Mob owner)
  {
    super(owner);
  }
}
class Weapon extends Ammunition
{
  int cooldown; //ms
  float dmg;
  static final int SWORD=1, GUN=2;
  int TYPE;
  Weapon (Mob owner)
  {
    super(owner);
    dmg=5;
  }
}
class Armor extends Ammunition
{
  Armor (Mob owner)
  {
    super(owner);
  }
}
class Backpack extends Ammunition
{
  Backpack (Mob owner)
  {
    super(owner);
  }
}
class Boots extends Ammunition
{
  Boots (Mob owner)
  {
    super(owner);
  }
}
class Sword extends Weapon
{
  Sword (Mob owner)
  {
    super(owner);
    TYPE=Weapon.SWORD;
  }
}
class Gun extends Weapon
{
  PVector atkDirection;
  int acc; //точность
  Gun(Mob owner)
  {
    super(owner); 
    TYPE=Weapon.GUN;
    atkDirection=new PVector(0,0);
  }
  void shoot()
  {
    bulletParticles.addParticle(owner, atkDirection);
  }
}