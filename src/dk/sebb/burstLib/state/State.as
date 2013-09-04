/**
 * Basestate functions as a consistant view
 * so you should not be creating multiple instances of these classes when you need a "new"
 * instead unload and reuse them to avoid memory leaks etc
 */
package dk.sebb.burstLib.state
{
	import flash.display.MovieClip;
	import flash.display.Stage;

	public class State extends MovieClip
	{
		protected var stage:Stage;

/**
 * needs a Stage reference to bind event listerners like Event.EnterFrame
 * @param stage Stage
 */
		public function State(stage:Stage) {}
	}
}