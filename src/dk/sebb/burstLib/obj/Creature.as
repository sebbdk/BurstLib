package dk.sebb.burstLib.obj
{
	import flash.utils.getTimer;
	
	import dk.sebb.burstLib.util.map.AStarMap;
	import dk.sebb.burstLib.util.map.Cell;
	
	import nape.geom.Vec2;
	import nape.phys.BodyType;

	public class Creature extends Mob
	{
		public var health:int = 1;
		public var path:Array;
		public var lastPathFind:int = 0;
		public var pathFindCooldown:int = 200;
		
		public function Creature()
		{
			super(BodyType.DYNAMIC, poly);
			body.allowRotation = false;
		}
		
		public function getCell(map:AStarMap):Cell {
			return map.getCellFromCoords(body.position.x, body.position.y, map.tileSize);
		}
		
		public function gotoCoords():void {
			var vec:Vec2 = body.localVectorToWorld(new Vec2(0, 0));
			
			if(path && path.length > 0) {
				if(Vec2.distance(body.position,  Vec2.get(path[0][0], path[0][1], true)) < 8) {
					path.shift();
				} else {
					vec = Vec2.get(path[0][0], path[0][1], true).sub(body.position);
					vec.length = 50;
				}
			}
			
			
			body.velocity = vec;
			var isMoving:Boolean = (body.velocity.x !== 0 || body.velocity.x !== 0);
			
			if(body.velocity.x < 0) {
				this.scaleX = 1;
			} else if(isMoving) {
				this.scaleX = -1;
			}
		}
		
		public function getPathTo(creature:Creature, map:AStarMap):Array {
			if(lastPathFind + pathFindCooldown < getTimer()) {
				var fromCell:Cell = getCell(map);
				var toCell:Cell = creature.getCell(map);
				lastPathFind = getTimer();
				return map.findPath(fromCell.x, fromCell.y, toCell.x, toCell.y);
			}
			
			return null;
		}
	}
}