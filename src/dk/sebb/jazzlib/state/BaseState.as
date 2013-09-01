package dk.sebb.jazzlib.state
{
	import flash.display.MovieClip;
	import flash.display.Stage;

	public class BaseState
	{
		protected var _view:MovieClip = new MovieClip();
		protected var stage:Stage;
		
		public function BaseState(stage:Stage) {}
		
		public function  get view():MovieClip {
			return view;
		}
	}
}