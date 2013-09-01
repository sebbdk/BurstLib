/**
 * remove Vec2 references, mobs should have a view attribute like done on the states?
 */
package dk.sebb.jazzlib.model
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import dk.sebb.jazzlib.util.JSONLoader;
	import dk.sebb.tiled.TMXLoader;
	import dk.sebb.tiled.layers.Layer;
	import dk.sebb.tiled.layers.ObjectLayer;
	import dk.sebb.tiled.layers.TMXObject;

	public dynamic class TMXLevelModel extends LevelModel
	{
		private var levelPath:String;
		
		public var tmxLoader:TMXLoader;
		public var dataLoader:JSONLoader;
		
		public var parallaxLayers:Array = [];
		public var collisionLayer:Layer;
		
		public var spawns:Array = [];
		
		public function TMXLevelModel(levelPath:String)
		{
			super();
			this.levelPath = levelPath;
			
			tmxLoader = new TMXLoader(levelPath + "level.tmx");
			tmxLoader.addEventListener(Event.COMPLETE, onTMXLoaded);
		}
		
		public function onTMXLoaded(evt:Event):void {
			tmxLoader.removeEventListener(Event.COMPLETE, onTMXLoaded);
			//get object layers
			for each(var layer:Layer in tmxLoader.layers) {
				if(layer.parallax) {
					parallaxLayers.push(layer);
				}
				
				switch(getQualifiedClassName(layer)) {
					case 'dk.sebb.tiled.layers::ObjectLayer':
						setupObjectLayer(layer as ObjectLayer);
						break;
					case 'dk.sebb.tiled.layers::Layer':
						setupLayer(layer);
						break;
				}
			}
			
			if(tmxLoader.data) {
				dataLoader = new JSONLoader(levelPath + tmxLoader.data);
				dataLoader.addEventListener(Event.COMPLETE, onDataLoaded);
				dataLoader.load();
			} else {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function onDataLoaded(evt:Event):void {
			dataLoader.removeEventListener(Event.COMPLETE, onDataLoaded);
			
			for(var attr:String in dataLoader.data) {
				this[attr] = dataLoader.data[attr];
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Loop's through the obejct layers to set up spawn points, detectors etc
		 * */
		public function setupObjectLayer(layer:ObjectLayer):void {
			if(layer.display === "false") {
				layer.displayObject.visible = false;
			}			
			
			for each(var object:TMXObject in layer.objects) {
				if(object.type) {
					switch(object.type) {
						case 'playerspawn':
							spawns.push(new Point(object.x + (object.width/2), object.y + (object.height/2)));
							break;
						default:
							trace("unknow  object type (" + object.type + ") found in level!");
							break;
					}
				}
			}
		}
		
		/**
		 * handles collision layers or other tiles with settings on them
		 * */
		public function setupLayer(layer:Layer):void {
			if(layer.display === "false") {
				layer.displayObject.visible = false;
			}
			
			if(layer.name === 'function') {
				collisionLayer = layer;
			}
			
			/**
			if(layer.functional && layer.functional === "true") { //create phys objects for the tiles in functinal layers(physics),
				for (var spriteForX:int = 0; spriteForX < tmxLoader.mapWidth; spriteForX++) {
					for (var spriteForY:int = 0; spriteForY < tmxLoader.mapHeight; spriteForY++) {
						var tileGid:int = int(layer.map[spriteForX][spriteForY]);
						if(TileSet.tiles[tileGid]) {
							var tileMob:PhysMob = new TileMob(BodyType.STATIC);
							tileMob.body.position.x = 32 * spriteForX + 16;
							tileMob.body.position.y = 32 * spriteForY + 16;
							tileMob.hasPerspective = layer.perspective && layer.perspective === "true";
							addMob(tileMob);
						}
					}
				}
			} else if(layer.perspective && layer.perspective === "true") {//create objects for tiles in perspective layers
				
				for each(var object:TMXObject in layer.objects) {
					var mob:Mob = new Mob();
					mob.x = object.x;
					mob.y = object.y;
					object.x = 0;
					object.y = -64;
					mob.addChild(object);
					mob.hasPerspective = true;
					addMob(mob);
				}
			}
			 * **/
		}
		
	}
}