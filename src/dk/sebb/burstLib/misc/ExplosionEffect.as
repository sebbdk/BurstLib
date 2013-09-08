package dk.sebb.burstLib.misc
{
	import flash.display.MovieClip;
	
	import Anim.Explosion;
	
	import dk.sebb.burstLib.model.TMXLevelModel;
	import dk.sebb.burstLib.model.event.ModelEvent;
	import dk.sebb.burstLib.obj.creatures.Creature;
	import dk.sebb.burstLib.obj.Projectile;
	
	import nape.geom.Vec2;
	
	public class ExplosionEffect extends MovieClip
	{
		public var animator:MovieClip;
		
		public function ExplosionEffect()
		{
			animator = new Anim.Explosion();
			animator.visible = false;
			addChild(animator);
		}
		
		public function blow(model:TMXLevelModel, dist:int=32):void {
			animator.gotoAndPlay(0);
			animator.visible = true;
			
			//kill creatures
			var victims:Array = [];
			var pos:Vec2 = Vec2.get(x, y);
			for each(var creature:Creature in model.creatures) {
				if(Vec2.distance(creature.body.position, pos) <= dist) {
					victims.push(creature);
				}
			}
			
			for each(var victim:Creature in victims) {
				victim.damage(20, model)
			}
			
			//bullet destruction
			for each(var projectile:Projectile in Projectile.pool) {
				if(Vec2.distance(projectile.body.position, pos) <= dist) {
					projectile.unload();
				}
			}
			
			model.dispatchEvent(new ModelEvent(ModelEvent.STOMP));
		}
	}
}