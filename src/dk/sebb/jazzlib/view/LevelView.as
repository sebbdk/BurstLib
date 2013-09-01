package dk.sebb.jazzlib.view
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	import dk.sebb.jazzlib.model.TMXLevelModel;
	import dk.sebb.tiled.layers.Layer;
	
	public class LevelView extends MovieClip
	{
		public var model:TMXLevelModel;
		
		public function LevelView()
		{
			super();
		}
		
		public function setModel(model:TMXLevelModel):void {
			if(this.model != model) {
				this.model = model;
				this.load();
			}
		}
		
		public function load():void {
			unload();
			
			for each(var layer:Layer in model.tmxLoader.layers) {
				addChild(new Bitmap(layer.bitmapData));
			}
		}
		
		public function unload():void {
			removeChildren();
		}
	}
}