package dk.sebb.burstLib.obj
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Anim.PlayerBullet;
	
	import dk.sebb.burstLib.model.TMXLevelModel;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import dk.sebb.burstLib.obj.creatures.Creature;
	
	public class Projectile extends Mob
	{
		public var targetCollision:CbType;
		public var target:Creature;
		public var vel:Vec2;
		public var collisionType:CbType = new CbType();
		public static var publicCollisionType:CbType = new CbType();
		public var onCollisionListener:InteractionListener;
		
		public var directionX:int = 0;
		public var directionY:int = 0;
		public var speed:Number = 0;
		public var lifeSpan:int = 2500;
		
		public var lifeTimer:Timer
		
		public static var pool:Array = [];
		public static var poolLimit:int = 20;
		
		public function Projectile()
		{
			//set up graphic
			animator = new PlayerBullet();
			addChild(animator);
			
			//setup physics body
			poly = new Polygon(Polygon.box(5, 5));
			super(BodyType.DYNAMIC, poly);
			body.shapes.add(poly);
			body.allowRotation = false;
			body.cbTypes.add(collisionType);
			body.cbTypes.add(publicCollisionType);
			
			//prepare lifespan timer
			lifeTimer = new Timer(lifeSpan, 1);
			lifeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onLifeSpanOver);
		}
		
		public override function init(model:TMXLevelModel):void {
			super.init(model);
			
			//setup interaction listener
			onCollisionListener = new InteractionListener(CbEvent.ONGOING, 
				InteractionType.ANY,
				collisionType,
				BlockMob.collitionType,
				onCollision);
			
			model.space.listeners.add(onCollisionListener);
		}
		
		/**
		 * Fires the bullet in a direction and speed!
		 * @param  directionX Int
		 * @param  directionY Int
		 * @param  speed      Number
		 * @return void
		 */
		public function fire(target:Vec2, creature:Creature, model:TMXLevelModel, speed:Number = 50):void {
			this.target = creature;
			this.speed = speed;
			
			vel = body.localVectorToWorld(new Vec2(0, 0));
			vel = target.sub(body.position);
			vel.length = speed;
			
			//setup interaction listener
			onCollisionListener = new InteractionListener(CbEvent.ONGOING, 
				InteractionType.ANY,
				collisionType,
				creature.collisionType,
				onCollision);
			
			model.space.listeners.add(onCollisionListener);
			
			/////////////body.rotation = Math.atan2(directionY*-1, directionX*-1);
			
			lifeTimer.reset();
			lifeTimer.delay = lifeSpan;
			lifeTimer.start();
		}
		
/**
 * Returns a bullet from the pool or instantiates a new on request
 * This is done to main tain a maximum amount of bullets on screen
 * @return Bullet
 */
		public static function getNew():Projectile {
			if(pool.length < poolLimit) {
				pool.push(new Projectile());
				return Projectile(pool[pool.length-1]);
			} else {
				pool.push(pool.shift());
				Projectile(pool[pool.length-1]).unload();
				return Projectile(pool[pool.length-1]);
			}
			
			return null;
		}
		
		
/**
* Maintain a speed
* @return void
*/
		public override function update(model:TMXLevelModel):void {
			body.velocity = vel
			body.force = vel
			super.update(model);
		}
		
		public override function unload():void {
			lifeTimer.stop();
			super.unload();
		}
		
/**
 * Reduce enemy health and unload it self!
 * @param  collision InteractionCallback
 * @return void
 */
		private function onCollision(collision:InteractionCallback):void {
			//trace("Bullet haz collision!!");
			unload();
		}
		
/**
 * Remove the bullet after some time
 * @param  evt TimerEvent
 * @return void
 */
		public function onLifeSpanOver(evt:TimerEvent):void {
			//trace('bullet life over!');
			unload();
		}
		
	}
}