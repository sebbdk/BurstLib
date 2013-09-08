package dk.sebb.burstLib.obj
{
	import nape.callbacks.CbType;
	import nape.dynamics.InteractionGroup;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	
	public class BlockMob extends Mob
	{
		public static var collisionGroup:InteractionGroup = new InteractionGroup();
		public static var collitionType:CbType = new CbType();
		
		public function BlockMob(width:Number, height:Number, type:BodyType = null)
		{
			poly = new Polygon(Polygon.box(width,height));
			super(type, poly);
			body.group = BlockMob.collisionGroup;
			body.cbTypes.add(BlockMob.collitionType);
		}
	}
}