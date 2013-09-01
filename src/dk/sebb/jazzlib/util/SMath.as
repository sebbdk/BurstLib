/**
 * Generic math class, does calculations to you do not have to think too much.
 * 
 * #TODO Change to use Points instead of Vec2
 */
package dk.sebb.jazzlib.util
{
	import nape.geom.Vec2;

	public class SMath
	{

/**
 * This class cannot be instantiated.
 * @return void
 */
		public function SMath()
		{
			throw new Error('The SMAth Class is not supposed to be instatiated!');
		}

/**
 * Pads a number with zero's and returns a string
 * @param  number int
 * @param  width
 * @return String
 */
		public static function zeroPad(number:int, width:int):String {
			var ret:String = ""+number;
			while( ret.length < width )
				ret="0" + ret;
			return ret;
		}

/**
 * Returns a ramdom point on a circle given a radious and a position
 * @param  radius number
 * @param  vec    [description]
 * @return        [description]
 */
		public static function randomRadiusPoint(radius:Number, vec:Vec2 = null):Vec2
		{
			var randomAngle:Number = Math.random() * (Math.PI * 2);
			return CPAngle(randomAngle, radius, vec);
		}

/**
 * Eh .. i forgot.. me no math normally, hence this class...
 * @param angle
 * @param radius
 * @param vec
 */
		public static function CPAngle(angle:Number, radius:Number, vec:Vec2 = null):Vec2 {
			var newX:Number = radius*Math.cos(angle);
			var newY:Number = radius*Math.sin(angle);
			
			if(vec) {
				vec.setxy(newX, newY);
				return vec;
			}
			
			return Vec2.get(newX, newY);
		}

/**
 * Retuns the angle between two points in radians
 * @param  x1
 * @param  y1
 * @param  x2
 * @param  y2
 * @return Number
 */
		public static function getAngle(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.atan2(dy,dx);
		}
	}
}