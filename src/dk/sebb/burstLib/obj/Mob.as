/**
 * The Mob class represents moving objects or objects that are updated at each frame
 * This could be a NPC or a bullet, anything active really
 */
package dk.sebb.burstLib.obj
{
	import dk.sebb.burstLib.model.TMXLevelModel;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;

	public class Mob extends Gob
	{
		public var body:Body;
		public var poly:Polygon;
		
		public function Mob(type:BodyType = null, poly:Polygon = null, static:Boolean = false) {
			
			body = new Body(type || BodyType.STATIC, new Vec2(50, 50));

			if(animator) {
				poly = poly ? poly:new Polygon(Polygon.box(animator.width, animator.height/3));
				animator.y = (animator.height/3)/2;
				body.shapes.add(poly);
			} else {
				if(!static) {
					poly = poly ? poly:new Polygon(Polygon.box(10,10));
					body.shapes.add(poly);
				}
			}
		}
		
		public function init(model:TMXLevelModel):void {}
		
		public function update(model:TMXLevelModel):void {
			x = body.position.x;
			y = body.position.y - height;
			rotation = body.rotation * 180 / Math.PI;
		} 
		
		public function unload():void {
			body.space = null;
			if(parent) {
				parent.removeChild(this);
			}
		}
	}
}