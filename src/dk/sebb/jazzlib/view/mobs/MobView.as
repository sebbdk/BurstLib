package dk.sebb.jazzlib.view.mobs
{
	import flash.display.MovieClip;
	
	import dk.sebb.jazzlib.obj.Mob;
	
	public class MobView extends MovieClip
	{
		public var mob:Mob;
		
		public function MobView(mob:Mob)
		{
			this.mob = mob;
			super();
		}
	}
}