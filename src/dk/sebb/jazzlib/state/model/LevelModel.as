package dk.sebb.jazzlib.state.model
{
	import dk.sebb.jazzlib.obj.Mob;

	public dynamic class LevelModel
	{
		public var mobs:Vector.<Mob> = new Vector.<Mob>();
		
		public function LevelModel()
		{
		}
		
		public function removeMob():Boolean {
			return false;
		}
		
		public function addMob(mob:Mob):Boolean {
			return false;
		}
	}
}