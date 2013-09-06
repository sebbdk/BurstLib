package dk.sebb.burstLib.obj
{
	import Anim.BlueGuy;
	
	import dk.sebb.burstLib.model.TMXLevelModel;

	public class NPC extends Creature
	{
		public function NPC()
		{
			animator = new BlueGuy();
			addChild(animator);
			super();
		}
		
		public function doBehavior(model:TMXLevelModel):void {
			if(!path || path.length === 0) {
				path = getPathTo(model.player, model.map);
			}
			
			gotoCoords();
		}
		
		public override function update(model:TMXLevelModel):void {
			doBehavior(model);
			super.update(model);
		}
	}
}