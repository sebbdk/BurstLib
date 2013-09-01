package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import dk.sebb.jazzlib.controller.TMXLevelController;
	import dk.sebb.jazzlib.model.TMXLevelModel;
	import dk.sebb.jazzlib.view.LevelView;
	
	[SWF(backgroundColor="#999999", frameRate="60", height="600", width="800", quality="HIGH")]
	public class TMXLevelDemo extends Sprite
	{
		public var controller:TMXLevelController;
		public var view:LevelView;
		
		public function TMXLevelDemo()
		{
			controller = new TMXLevelController(stage);
			controller.addEventListener(Event.COMPLETE, setViewModel);
			
			view = new LevelView();
			addChild(view);
			
			controller.load('../levels/demo_001_basic/');
		}
		
		private function setViewModel(evt:Event):void {
			view.setModel(controller.model as TMXLevelModel);
		}
	}
}