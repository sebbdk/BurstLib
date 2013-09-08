/**
 * remove Vec2 references, mobs should have a view attribute like done on the states?
 */
package dk.sebb.burstLib.model
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import dk.sebb.burstLib.misc.InfoBox;
	import dk.sebb.burstLib.misc.LuaInterface;
	import dk.sebb.burstLib.obj.BlockMob;
	import dk.sebb.burstLib.obj.Mob;
	import dk.sebb.burstLib.obj.Sensor;
	import dk.sebb.burstLib.obj.creatures.Confused;
	import dk.sebb.burstLib.obj.creatures.Creature;
	import dk.sebb.burstLib.obj.creatures.Dummy;
	import dk.sebb.burstLib.obj.creatures.GuardNPC;
	import dk.sebb.burstLib.obj.creatures.MonsterPlayer;
	import dk.sebb.burstLib.obj.creatures.NPC;
	import dk.sebb.burstLib.obj.creatures.TwitchNPC;
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
		
		public static var infoBox:InfoBox = new InfoBox();
		
		public var map:AStarMap = new AStarMap();
		
		public var canTeleport:Boolean;
		
		public static var lua:LuaInterface = new LuaInterface();
		public static var instance:TMXLevelModel;
		
		public function TMXLevelModel(levelPath:String)
		{
			super();
			
			this.levelPath = levelPath;
			instance = this;
			tmxLoader = new TMXLoader(levelPath + "level.tmx");
			tmxLoader.addEventListener(Event.COMPLETE, onTMXLoaded);
		}
		
		public function update():void {
			canTeleport = true;
			for each(var creature:Creature in creatures) {
				if(creature.path !== null) {
					canTeleport = false;
				}
			}
		}
		
		public function teleportPlayerTo(id:String):void {
			if(canTeleport && player.lastTeleport + player.teleportCoolDown < getTimer()) {
				for each(var mob:Mob in mobs) {
					if(mob is Sensor && (Sensor(mob).object.id) === id) {
						player.body.position = mob.body.position;
						player.body.position.x;						
						player.body.position.y;
						player.lastTeleport = getTimer();
						break;
					}
				}
			}
		}
		
		public function onTMXLoaded(evt:Event):void {
			unload();
			
			tmxLoader.removeEventListener(Event.COMPLETE, onTMXLoaded);
			player = player ? player:new MonsterPlayer();
			
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

			//parse the map used for path finding
			parseMap();
			
			//setup player
			
			if(spawns[0]) {
				player.body.position = Vec2.fromPoint(spawns[0]);
				addMob(player);
			}
			
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
			map.tileSize = tmxLoader.tileWidth;
			
			var rowX:int = 0;
			for each(var row:Array in functionLayer.map) {
				var colY:int = 0;
				for each(var col:Array in functionLayer.map) {
					var tileGid:int = int(functionLayer.map[rowX][colY]);
					if(TileSet.tiles[tileGid]) {
						map.setCell(new Cell(Cell.CELL_FILLED, rowX, colY));
					}
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
			if(layer.display !== "true") {
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
						case 'dummy':
							var dummy:NPC = new Dummy();
							dummy.body.position.x = object.x + (object.width/2);
							dummy.body.position.y = object.y + (object.height/2);
							addMob(dummy);
							break;
						case 'twitch':
							var twitch:TwitchNPC = new TwitchNPC();
							twitch.body.position.x = object.x + (object.width/2);
							twitch.body.position.y = object.y + (object.height/2);
							addMob(twitch);
							break;
						case 'confused':
							var confused:Confused = new Confused();
							confused.body.position.x = object.x + (object.width/2);
							confused.body.position.y = object.y + (object.height/2);
							addMob(confused);
							break;
						case 'guard':
							var guard:NPC = new GuardNPC();
							guard.body.position.x = object.x + (object.width/2);
							guard.body.position.y = object.y + (object.height/2);
							addMob(guard);
							break;
						case 'obj':
							var obj:BlockMob = new BlockMob(object.width, object.height);
							obj.body.position.x = object.x + (object.width/2);
							obj.body.position.y = object.y + (object.height/2);
							addMob(obj);
							break;
						case 'sensor':
							var sensor:Sensor = new Sensor(object);
							sensor.body.position.x = object.x + (object.width/2);
							sensor.body.position.y = object.y + (object.height/2);
							addMob(sensor);
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
				layer.displayObject.visible = false;
			}
		
			if(layer.functional && layer.functional === "true") { //create phys objects for the tiles in functinal layers(physics),
				for (var spriteForX:int = 0; spriteForX < tmxLoader.mapWidth; spriteForX++) {
					for (var spriteForY:int = 0; spriteForY < tmxLoader.mapHeight; spriteForY++) {
						var tileGid:int = int(layer.map[spriteForX][spriteForY]);
						if(TileSet.tiles[tileGid] && TileSet.tiles[tileGid].type === "physic") {
							var tileMob:BlockMob = new BlockMob(tmxLoader.tileWidth, tmxLoader.tileHeight);
							tileMob.body.position.x = tmxLoader.tileWidth * spriteForX + tmxLoader.tileWidth/2;
							tileMob.body.position.y = tmxLoader.tileHeight * spriteForY + tmxLoader.tileHeight/2;
							addMob(tileMob);
						}
					}
				}
			} else if(layer.perspective && layer.perspective === "true") {//create objects for tiles in perspective layers
				for each(var object:TMXObject in layer.objects) {
					var mob:Mob = new Mob(null, null, true);
					mob.body.position.x = object.x;
					mob.body.position.y = object.y + 32;
					object.x = 0;
					object.y = 0;
					mob.addChild(object);
					addMob(mob);
				}
			}
		}
		
	}
}