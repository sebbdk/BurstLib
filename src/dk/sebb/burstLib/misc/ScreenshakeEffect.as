/**
 * A screenshake class changes a random x and y value for a specified amount of time
 * simply create instance start it and update a view with the x/y coords on enterframe
 *
 * Hmm could be done simpler?
 * maybe loop over a effect array after each frame?
 * Take into consideration other possible effects like colorfilter changes
 */
package dk.sebb.burstLib.misc
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class ScreenshakeEffect
	{
		private var coordX:Number = 0;  
		private var coordY:Number = 0;
		private var timer:Timer = new Timer(10);
		
		public var offSetX:int = 0;
		public var offSetY:int = 0;
		
		public var magnitude:Number = 5;
		
		public function ScreenshakeEffect() {
			timer.addEventListener(TimerEvent.TIMER, shakeImage);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, stop);
		}
		
		public function start(magnitude:int = 5, delay:int = 5, repeatCount:int = 20):void{
			offSetX = 0;
			offSetY = 0;
			
			this.magnitude = magnitude;
			
			timer.delay = delay;
			timer.repeatCount= repeatCount;
			timer.reset();
			timer.start();
		}
		
		public function stop(evt:Event = null):void{
			timer.stop();
		}
		
		private function shakeImage(event:Event):void {  
			offSetX = coordX+ getMinusOrPlus()*(Math.random()*magnitude);  
			offSetY = coordY+ getMinusOrPlus()*(Math.random()*magnitude); 
		}
		
		private function getMinusOrPlus():int{
			var rand : Number = Math.random()*2;
			if (rand<1) return -1
			else return 1;
		}   
	}
}