/**
 * Consider moving this code somewhere else at some point
 */
package dk.sebb.burstLib.state
{
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.Event;
	
	import dk.sebb.burstLib.model.TMXLevelModel;
	import dk.sebb.burstLib.obj.Mob;
	import dk.sebb.tiled.layers.Layer;
	
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
			TMXLevelModel(model).tmxLoader.load();
		}
		
		public function onModelLoaded(evt:Event):void {
			unload();
			
			for each(var layer:Layer in model.tmxLoader.layers) {
				addChild(new Bitmap(layer.bitmapData));
			}
			
			for each(var mob:Mob in model.mobs) {
				addChild(mob);
			}
			
			if(debug) {
				physDebug = physDebug ? physDebug:new ShapeDebug(width, height);
				addChild(physDebug.display);
			}
			
			start();
		}
		
		public override function run(evt:Event):void {
			super.run(evt);

			if(debug) {
				physDebug.clear();
				physDebug.draw(model.space);
			}
		}
	}
}