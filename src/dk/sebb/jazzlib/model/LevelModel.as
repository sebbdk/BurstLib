/**
 * Contains data of the loaded level, all level data should go here so it can be properly unloaded/loaded.
 */
package dk.sebb.jazzlib.model
{
	import flash.events.EventDispatcher;
	
	import dk.sebb.jazzlib.obj.Mob;

	public dynamic class LevelModel extends EventDispatcher
	{
		public var mobs:Vector.<Mob> = new Vector.<Mob>();
		
		public function LevelModel() {}
		
/**
 * Removed the given mob from the vector/list of mobs
 * Returns true on success
 * @param  mob Mob
 * @return boolean
 */
		public function removeMob(mob:Mob):Boolean {
			return false;
		}

/**
 * Adds a mob to the list
 * Runs through the list first to prevent douples in the list throws a warning in that case
 * @param mob Mob
 * @return boolean
 */
		public function addMob(mob:Mob):Boolean {
			return false;
		}
	}
}