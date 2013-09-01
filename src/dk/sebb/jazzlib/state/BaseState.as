/**
 * Basestate functions as a consistant view
 * so you should not be creating multiple instances of these classes when you need a "new"
 * isntead unload and reuse them to avoid memory leaks etc
 */
package dk.sebb.jazzlib.state
{
	import flash.display.MovieClip;
	import flash.display.Stage;

	public class BaseState
	{
		protected var _view:MovieClip = new MovieClip();
		protected var stage:Stage;

/**
 * needs a Stage reference to bind event listerners like Event.EnterFrame
 * @param stage Stage
 */
		public function BaseState(stage:Stage) {}
		
/**
 * returns a instance of the view
 * @return IView
 */
		public function  get view():MovieClip {
			return view;
		}
	}
}