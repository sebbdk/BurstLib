/**
 * Contains data of the loaded level, all level data should go here so it can be properly unloaded/loaded.
 */
package dk.sebb.burstLib.model
{
	import flash.events.EventDispatcher;
	
	import dk.sebb.burstLib.model.event.ModelEvent;
	import dk.sebb.burstLib.obj.creatures.Creature;
	import dk.sebb.burstLib.obj.Mob;
	import dk.sebb.burstLib.obj.creatures.Player;
	
	import nape.geom.Vec2;
	import nape.space.Space;

	public dynamic class LevelModel extends EventDispatcher
	{
		public var mobs:Vector.<Mob> = new Vector.<Mob>();
		public var creatures:Vector.<Creature> = new Vector.<Creature>();
		public var player:Player;
		public var space:Space;
		
		public function LevelModel() {
			space = new Space(new Vec2(0,0));
		}
		
/**
 * Removed the given mob from the vector/list of mobs
 * @param  mob Mob
 * @return void
 */
		public function removeMob(mob:Mob):void {
			mobs.splice(mobs.indexOf(mob), 1);
			if(mob is Creature) {
				creatures.splice(creatures.indexOf(mob as Creature), 1);
			}
			mob.unload();
			dispatchEvent(new ModelEvent(ModelEvent.REMOVE_MOB, mob));
		}

/**
 * Adds a mob to the list
 * Runs through the list first to prevent douples in the list throws a warning in that case
 * @param mob Mob
 * @return boolean
 */
		public function addMob(mob:Mob):void {
			mob.body.space = space;
			mob.init(this as TMXLevelModel);
			mobs.push(mob);
			
			//add it to the creature array aswell if needed
			if(mob is Creature) {
				creatures.push(mob);
			}
			
			dispatchEvent(new ModelEvent(ModelEvent.ADD_MOB, mob));
		}
		
		public function unload():void {
			space.clear();
		}
	}
}