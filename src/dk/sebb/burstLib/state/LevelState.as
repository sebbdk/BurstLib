/**
 * The LevelState has the common functionality of a gamelevel extend and override as needed
 */
package dk.sebb.burstLib.state
{
	import dk.sebb.burstLib.model.TMXLevelModel;
	import dk.sebb.burstLib.obj.Mob;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import nape.util.ShapeDebug;

	public class LevelState extends State
	{
		protected var lastFrameTime:int = 0;
		protected var fps:int = 60;
		protected var isPaused:Boolean = false;
		
		public var physDebug:ShapeDebug;
		
		public var model:TMXLevelModel;
		public var debug:Boolean = true;
		
		
		public function LevelState(stage:Stage, fps:int = 60)
		{
			this.fps = fps;
			scaleX = 2;
			scaleY = 2;
			super(stage);
		}

/**
 * Pauses the run function until the play method is called.
 * @return void
 */
		public function pause():void {
			removeEventListener(Event.ENTER_FRAME, run);
		}

/**
 * Starts/resumes the run method
 * @return void
 */
		public function start():void {
			addEventListener(Event.ENTER_FRAME, run);
		}

/**
 * Resets the current level and reloads the model
 * @return void
 */
		public function reset():void {
		}
		
/**
 * unloads all the model and removes everything from the view
 * @return void
 */
		public function unload():void {}
		
		public function updateCamera():void {
			x = (-(model.player.body.position.x * scaleX) + stage.stageWidth/2);
			y = (-(model.player.body.position.y * scaleY) + stage.stageHeight/2);
		}

/**
 * Updates all mobs, physics if you have any etc
 * also updates the fps delta
 * @param  evt Event
 * @return void
 */
		public function run(evt:Event):void {
			var deltaTime:Number = (getTimer() - lastFrameTime) / (1000/30);
			if(!isPaused && deltaTime > 1) {
				//increment the physics
				deltaTime = 1;//hacks!!
				model.space.step((1/30) * deltaTime, 10, 10);
				
				for each(var mob:Mob in model.mobs) {
					mob.update(model);
				}
				
				updateCamera();
				
				lastFrameTime = getTimer();
			}
		}
	}
}