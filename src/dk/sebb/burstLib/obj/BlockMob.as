package dk.sebb.burstLib.obj
{
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	
	public class BlockMob extends Mob
	{
		public function BlockMob(width:Number, height:Number, type:BodyType = null)
		{
			poly = new Polygon(Polygon.box(width,height));
			super(type, poly);
		}
	}
}