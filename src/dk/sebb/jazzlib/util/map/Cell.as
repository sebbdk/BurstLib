/**
 * This class is used for pathfinding and represents a cell/point in a map and whatever is on it
 */
package dk.sebb.jazzlib.util.map
{
	import flash.geom.Point;

	public class Cell
	{
		public static var CELL_FREE:uint = 0;
		public static var CELL_FILLED:uint = 1;
		public static var CELL_EDGE:uint = 14;
		public static var CELL_ORIGIN:uint = 2;
		public static var CELL_DESTINATION:uint = 3;
		public static var CELL_CREATURE:uint = 4;
		
		public var cellType:uint = CELL_FREE;	
		public var parentCell:Object = null;
		public var g:int = 0;
		public var f:int = 0;
		public var x:int = 0;
		public var y:int = 0;
		
		public var name:String;
		
		public var isPath:Boolean;
		
		public function Cell(_cellType:uint = 0, _x:int = 0, _y:int = 0) {
			cellType = _cellType;
			x = _x;
			y = _y;
			super();
		}
	}
}