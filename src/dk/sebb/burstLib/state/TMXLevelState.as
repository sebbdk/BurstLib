/**
 * Consider moving this code somewhere else at some point
 */
package dk.sebb.burstLib.state
{
	import dk.sebb.burstLib.model.TMXLevelModel;
	import dk.sebb.burstLib.model.event.ModelEvent;
	import dk.sebb.burstLib.obj.Mob;
	import dk.sebb.tiled.layers.Layer;
	
	import flash.display.Stage;
	import flash.events.Event;
	
	import nape.util.ShapeDebug;
	
	public class TMXLevelState extends LevelState
	{
		public function TMXLevelState(stage:Stage,  fps:int=60)
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
			model.addEventListener(ModelEvent.STOMP, onStomp);
			TMXLevelModel(model).tmxLoader.load();
		}
		
		public function onModelLoaded(evt:Event):void {
			unload();
			
			for each(var layer:Layer in model.tmxLoader.layers) {
				addChild(layer.displayObject);
			}
			
			for each(var mob:Mob in model.mobs) {
				addChild(mob);
			}
			
			if(debug) {
				physDebug = physDebug ? physDebug:new ShapeDebug(width ? width:2048, height ? height:2048);
				addChild(physDebug.display);
			}
			
			addChild(lightMask);
			
			start();
		}
		
		private function onStomp(evt:ModelEvent):void {
			screenShake.start(5,5, 10);
		}
		
		public override function run(evt:Event):void {
			super.run(evt);
			lightMask.x = model.player.body.position.x;
			lightMask.y = model.player.body.position.y;
			if(debug) {
				physDebug.clear();
				physDebug.draw(model.space);
			}
		}
	}
}