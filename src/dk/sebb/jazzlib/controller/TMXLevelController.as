/**
 * Consider moving this code somewhere else at some point
 */
package dk.sebb.jazzlib.controller
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import dk.sebb.jazzlib.model.TMXLevelModel;
	
	public class TMXLevelController extends LevelController
	{	
		public function TMXLevelController(stage:Stage,  fps:int=60)
		{
			super(stage, fps);
		}
		
		
/**
 * Loads the model
 * @return void
 */
		public function load(levelPath:String):void {
			model = new TMXLevelModel(levelPath);
			model.addEventListener(Event.COMPLETE, onModelLoaded);
			TMXLevelModel(model).tmxLoader.load();
		}
		
		public function onModelLoaded(evt:Event):void {
			dispatchEvent(evt);
		}
	}
}