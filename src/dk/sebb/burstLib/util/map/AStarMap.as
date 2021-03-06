/**
 * Barebone A* pathfinding algorythm class..
 */
package dk.sebb.burstLib.util.map
{
	public class AStarMap
	{
		public var map:Array = new Array();
		public var maxItterations:int = 2000;
		
		private var originCell:Cell;
		private var destinationCell:Cell;
		private var currentCell:Cell;
		
		private var openList:Array;
		private var closedList:Array;
		
		public function AStarMap() {}
		
		public var tileSize:int = 32;
		
		public function getCellFromCoords(x:Number, y:Number, cellSize:int):Cell {
			return getCell(Math.floor(x/cellSize), Math.floor(y/cellSize));
		}

/**
 * Sets a cell at the give position in the map
 * @param c Cell
 * @return void
 */
		public function setCell(c:Cell):void {
			map[c.x] = (map[c.x]) ? map[c.x]:new Array();
			map[c.x][c.y] = c;
		}

/**
 * Returns the given cell or null
 * Please use this to avoid instead of getting cells directly from the map array
 * @param  x
 * @param  y
 * @return Cell
 */
		public function getCell(x:int, y:int):Cell {
			if(map[x] != null && map[x][y] != null) {
				return map[x][y];
			}
			
			var ec:Cell = new Cell();
			ec.x = x;
			ec.y = y;
			setCell(ec)
			return ec;
		}

/**
 * Resets the map inbetween each path search
 * @return void
 */
		private function reset():void {
			openList = new Array();
			closedList = new Array();
			
			currentCell = originCell;
			closedList.push(originCell);
		}

/**
 * Finds a path on the map and returns a array of points
 * @param  fromX
 * @param  fromY
 * @param  toX
 * @param  toY
 * @return Array
 */
		public function findPath(fromX:int, fromY:int, toX:int, toY:int, scale:Boolean = true):Array {
			reset();
			
			currentCell = getCell(fromX, fromY);
			Cell(currentCell).parentCell = getCell(fromX, fromY);
			originCell = getCell(fromX, fromY);
			destinationCell = getCell(toX, toY);
			
			//run until we either reach max iterations or we have solved the path
			var c:int = 0;
			var solved:Boolean = false;
			while(!solved && c < maxItterations) {
				solved = nextStep();
				c++;
			}
			
			if(c === maxItterations) {
				trace('Max map search itterations hit! is this intentional?');//hmm
			}
			
			var solutionPath:Array = new Array();
			var count:int = 0;
			var cellPointer:Object = closedList[closedList.length - 1];
			while(cellPointer != originCell) {
				if(count++ > 800) {//prevent a hang in case something goes awry.....????..
					//nope.. this is done when the origin cell is not found within 800 steps, 
					//do some testing, this should NEVER happen, aka not seen when i used it the last time
					
					//this happens if we have a path longer than 800 steps
					trace("i am hanging!");
					return null
				};
				
				if(scale) {
					solutionPath.push([cellPointer.x*tileSize+tileSize/2, cellPointer.y*tileSize+tileSize/2]);
				} else {
					solutionPath.push([cellPointer.x, cellPointer.y]);
				}
				
				cellPointer = cellPointer.parentCell;					
			}
			
			solutionPath.reverse();
			
			////////////make a way to debug the path that is human readable
			/*
			trace('Solution path:');
			for each(var cell:Cell in solutionPath) {
			trace(cell.x, cell.y);
			}
			*/
			
			return solutionPath;
		}

/**
 * Attempts to find the next step
 * @return Boolean
 */
		private function nextStep():Boolean {
			if(currentCell == destinationCell) {
				closedList.push(destinationCell);
				return true;
			}
			
			//place current cell into openList
			openList.push(currentCell);	
			
			//adjacent tiles
			var adjacentCells:Array = new Array();
			var checkCells:Array = [
				getCell(currentCell.x+1, currentCell.y),
				getCell(currentCell.x-1, currentCell.y),
				getCell(currentCell.x, currentCell.y+1),
				getCell(currentCell.x, currentCell.y-1)
			];
			
			for each(var checkCell:Cell in checkCells) {
				if(checkCell.cellType != Cell.CELL_FILLED && closedList.indexOf(checkCell) == -1) {
					adjacentCells.push(checkCell);
				}
			}
			
			/*
			var arryPtr:Cell;
			
			//get the adjacent tiles
			for(var xx:int = -1; xx <= 1; xx++) {				
				for(var yy:int = -1; yy <= 1; yy++) {
					if(!(xx == 0 && yy == 0)) {	
						arryPtr = getCell(currentCell.x + xx, currentCell.y + yy);
						if(arryPtr.cellType != Cell.CELL_FILLED && closedList.indexOf(arryPtr) == -1) {
							adjacentCells.push(arryPtr);
						}
					}
				}						
			}*/
			
			var g:int;
			var h:int;
			
			//choose the tile with the lowest F score
			for each(var cell:Cell in adjacentCells) {
				g = currentCell.g + 1;
				h = Math.abs(cell.x - destinationCell.x) + Math.abs(cell.y - destinationCell.y);
				
				if(openList.indexOf(cell) == -1) { //is cell already on the open list? - no									
					
					cell.f = g + h;
					cell.parentCell = currentCell;
					cell.g = g;					
					openList.push(cell);
					
				} else { //is cell already on the open list? - yes
					
					if(cell.g < currentCell.parentCell.g) {
						
						currentCell.parentCell = cell;
						currentCell.f = cell.g + h;
						
					}
				}
			}
			
			//Remove current cell from openList and add to closedList.
			var indexOfCurrent:int = openList.indexOf(currentCell);
			closedList.push(currentCell);
			openList.splice(indexOfCurrent, 1);
			
			//Take the lowest scoring openList cell and make it the current cell.
			openList.sortOn("f", Array.NUMERIC | Array.DESCENDING);	
			
			if(openList.length == 0) return true;
			
			currentCell = openList.pop();
			
			//trace(currentCell.x, currentCell.y);
			
			return false;
		}
	}
}