package dk.sebb.jazzlib.state
{
	import flash.display.Stage;
	
	public class TMXLevel extends LevelState
	{
		public function TMXLevel(stage:Stage, fps:int=60)
		{
			super(stage, fps);
		}
		
		//move to a util class instead, this seems generic.
		public function createCollisionMapFromTMX():Array {
			return null;
		}
	}
}