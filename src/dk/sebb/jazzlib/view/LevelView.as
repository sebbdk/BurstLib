package dk.sebb.jazzlib.view
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	import dk.sebb.jazzlib.model.TMXLevelModel;
	import dk.sebb.jazzlib.view.mobs.PlayerView;
	import dk.sebb.tiled.layers.Layer;
	
	public class LevelView extends MovieClip
	{
		public var model:TMXLevelModel;
		public var player:PlayerView;
		
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
			
			//setup player
			player = player ? player:new PlayerView();
			if(model.spawns[0]) {
				model.player.body.position = data.spawns[0];
				data.addMob(player);
			}
			player.health = 4;
		}
		
		public function unload():void {
			removeChildren();
		}
	}
}