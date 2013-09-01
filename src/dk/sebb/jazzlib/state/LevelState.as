package dk.sebb.jazzlib.state
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import dk.sebb.jazzlib.state.model.LevelModel;

	public class LevelState extends BaseState
	{
		protected var lastFrameTime:int = 0;
		protected var isPaused:Boolean = false;
		protected var model:LevelModel;
		
		public function LevelState(stage:Stage)
		{
			super(stage);
		}
		
		public function pause():void {}
		public function play():void {}
		public function reset():void {}
		
		public function unload():void {}
		public function load():void {}
		
		public function run(evt:Event):void {
			var deltaTime:Number = (getTimer() - lastFrameTime) / (1000/30);
			if(!isPaused && deltaTime > 1) {
				lastFrameTime = getTimer();
			}
		}
	}
}