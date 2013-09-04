/**
 * remove Vec2 references, mobs should have a view attribute like done on the states?
 */
package dk.sebb.burstLib.model
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import dk.sebb.burstLib.obj.BlockMob;
	import dk.sebb.burstLib.obj.NPC;
	import dk.sebb.burstLib.obj.Player;
	import dk.sebb.burstLib.util.JSONLoader;
	import dk.sebb.burstLib.util.map.AStarMap;
	import dk.sebb.burstLib.util.map.Cell;
	import dk.sebb.tiled.TMXLoader;
	import dk.sebb.tiled.TileSet;
	import dk.sebb.tiled.layers.Layer;
	import dk.sebb.tiled.layers.ObjectLayer;
	import dk.sebb.tiled.layers.TMXObject;
	
	import nape.geom.Vec2;

	public dynamic class TMXLevelModel extends LevelModel
	{
		private var levelPath:String;
		
		public var tmxLoader:TMXLoader;
		public var dataLoader:JSONLoader;
		
		public var parallaxLayers:Array = [];
		public var functionLayer:Layer;
		
		public var spawns:Array = [];
		
		public var map:AStarMap = new AStarMap();
		
		public function TMXLevelModel(levelPath:String)
		{
			super();
			this.levelPath = levelPath;
			
			tmxLoader = new TMXLoader(levelPath + "level.tmx");
			tmxLoader.addEventListener(Event.COMPLETE, onTMXLoaded);
		}
		
		public function onTMXLoaded(evt:Event):void {
			unload();
			
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
			
			//setup player
			player = player ? player:new Player();
			if(spawns[0]) {
				player.body.position = Vec2.fromPoint(spawns[0]);
				addMob(player);
			}
			
			//parse the map used for path finding
			parseMap();
			
			//loads extra dat
			if(tmxLoader.data) {
				dataLoader = new JSONLoader(levelPath + tmxLoader.data);
				dataLoader.addEventListener(Event.COMPLETE, onDataLoaded);
				dataLoader.load();
			} else {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function parseMap():void {
			var rowX:int = 0;
			for each(var row:Array in functionLayer.map) {
				var colY:int = 0;
				for each(var col:Array in functionLayer.map) {
					map.setCell(new Cell(Cell.CELL_FILLED, rowX, colY));
					colY++;
				}
				rowX++;
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
						case 'npc':
							var npc:NPC = new NPC();
							npc.body.position.x = object.x + (object.width/2);
							npc.body.position.y = object.y + (object.height/2);
							addMob(npc);
							break;
						case 'obj':
							var obj:BlockMob = new BlockMob(object.width, object.height);
							obj.body.position.x = object.x + (object.width/2);
							obj.body.position.y = object.y + (object.height/2);
							addMob(obj);
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
				functionLayer = layer;
			}
		
			if(layer.functional && layer.functional === "true") { //create phys objects for the tiles in functinal layers(physics),
				for (var spriteForX:int = 0; spriteForX < tmxLoader.mapWidth; spriteForX++) {
					for (var spriteForY:int = 0; spriteForY < tmxLoader.mapHeight; spriteForY++) {
						var tileGid:int = int(layer.map[spriteForX][spriteForY]);
						if(TileSet.tiles[tileGid]) {
							var tileMob:BlockMob = new BlockMob(tmxLoader.tileWidth, tmxLoader.tileHeight);
							tileMob.body.position.x = tmxLoader.tileWidth * spriteForX + tmxLoader.tileWidth/2;
							tileMob.body.position.y = tmxLoader.tileHeight * spriteForY + tmxLoader.tileHeight/2;
							addMob(tileMob);
						}
					}
				}
			}/* else if(layer.perspective && layer.perspective === "true") {//create objects for tiles in perspective layers
				
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
			}*/
		}
		
	}
}