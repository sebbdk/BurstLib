/**
 * Basestate functions as a consistant view
 * so you should not be creating multiple instances of these classes when you need a "new"
 * instead unload and reuse them to avoid memory leaks etc
 */
package dk.sebb.jazzlib.controller
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;

	public class Controller extends EventDispatcher
	{
		protected var stage:Stage;

/**
 * needs a Stage reference to bind event listerners like Event.EnterFrame
 * @param stage Stage
 */
		public function Controller(stage:Stage) {}
	}
}