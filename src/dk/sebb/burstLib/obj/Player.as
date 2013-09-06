package dk.sebb.burstLib.obj
{
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	
	import Anim.Twirl;
	
	import dk.sebb.burstLib.model.TMXLevelModel;
	import dk.sebb.burstLib.util.Key;
	
	import nape.geom.Vec2;

	public class Player extends Creature
	{
		public var currentAnimation:String = "down";
		public var direction:Vec2 = new Vec2();
		
		public function Player()
		{
			animator = new Twirl()
			addChild(animator);
			super();
		}
		
		public override function update(model:TMXLevelModel):void {
			super.update(model);
			updateKinematics(model);
		}
		
		private function updateKinematics(model:TMXLevelModel):void {
			var kx:int = 0;
			var ky:int = 0;
			
			var vel:int = 120;
			
			if(Key.isDown(Keyboard.D)) {
				kx += vel;
			}
			
			if(Key.isDown(Keyboard.A)) {
				kx += -vel;
			}
			
			if(Key.isDown(Keyboard.W)) {
				ky += -vel;
			}
			
			if(Key.isDown(Keyboard.S)) {
				ky += vel;
			}
			
			var vec:Vec2 = body.localVectorToWorld(new Vec2(kx, ky));
			body.force = vec;
			body.velocity = vec;
			body.kinematicVel= new Vec2(-kx*3, -ky*3);
			
			var isMoving:Boolean = (ky !== 0 || kx !== 0);
			
			if(!isMoving && currentAnimation != "") {
				animator.gotoAndStop(currentAnimation);
				MovieClip(animator.getChildAt(0)).gotoAndStop(0);
				currentAnimation = "";
			}
			
			//set graphics scale
			if(isMoving && kx < 0) {
				this.scaleX = 1;
			} else if(isMoving) {
				this.scaleX = -1;
			}
			
			if(isMoving){
				//set direction
				if(vec.x != 0) {
					direction.x = vec.x > 0 ? 1:-1;
				} else {
					direction.x = 0 
				}
				if(vec.y != 0) {
					direction.y = vec.y > 0 ? 1:-1;
				} else {
					direction.y = 0 
				}
				
				//set animation
				MovieClip(animator.getChildAt(0)).play(); 
				
				if(vec.x != 0 && currentAnimation != 'sideways') {
					animator.gotoAndStop('sideways');
					currentAnimation = 'sideways';
				} else if(vec.x === 0 && vec.y > 0 && currentAnimation != 'down'){
					animator.gotoAndStop('down');
					currentAnimation = 'down';
				} else if(vec.x === 0 && vec.y < 0 && currentAnimation != 'up') {
					animator.gotoAndStop('up');
					currentAnimation = 'up';
				}
			}
		}
	}
}