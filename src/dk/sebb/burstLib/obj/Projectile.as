package dk.sebb.burstLib.obj
{
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	
	public class Projectile extends Mob
	{
		public function Projectile(type:BodyType=null, poly:Polygon=null)
		{
			super(type, poly);
		}
	}
}