/**
 * The LevelState has the common functionality of a gamelevel extend and override as needed
 */
package dk.sebb.jazzlib.controller
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import dk.sebb.jazzlib.model.LevelModel;

	public class LevelController extends Controller
	{
		protected var lastFrameTime:int = 0;
		protected var fps:int = 60;
		protected var isPaused:Boolean = false;
		public var model:LevelModel;
		
		public function LevelController(stage:Stage, fps:int = 60, viewClass:Class = null)
		{
			this.fps = fps;
			super(stage);
		}

/**
 * Pauses the run function until the play method is called.
 * @return void
 */
		public function pause():void {}

/**
 * Starts/resumes the run method
 * @return void
 */
		public function play():void {}

/**
 * Resets the current level and reloads the model
 * @return void
 */
		public function reset():void {}
		
/**
 * unloads all the model and removes everything from the view
 * @return void
 */
		public function unload():void {}

/**
 * Updates all mobs, physics if you have any etc
 * also updates the fps delta
 * @param  evt Event
 * @return void
 */
		public function run(evt:Event):void {
			var deltaTime:Number = (getTimer() - lastFrameTime) / (1000/30);
			if(!isPaused && deltaTime > 1) {
				lastFrameTime = getTimer();
			}
		}
	}
}