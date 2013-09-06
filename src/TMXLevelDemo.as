package
{
	import flash.display.Sprite;
	
	import dk.sebb.burstLib.state.TMXLevelState;
	import dk.sebb.burstLib.util.Key;
	
	[SWF(backgroundColor="#999999", frameRate="60", height="600", width="800", quality="HIGH")]
	public class TMXLevelDemo extends Sprite
	{
		public var levelState:TMXLevelState;
		
		public function TMXLevelDemo()
		{
			Key.init(stage);
			
			levelState = new TMXLevelState(stage);
			levelState.load('../levels/level02/');
			addChild(levelState);
		}
	}
}