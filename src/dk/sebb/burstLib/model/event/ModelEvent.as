package dk.sebb.burstLib.model.event
{
	import flash.events.Event;
	
	import dk.sebb.burstLib.obj.Mob;
	
	public class ModelEvent extends Event
	{
		public static const ADD_MOB:String = "added_mob";
		public static const REMOVE_MOB:String = "remove_mob";
		
		public var subject:Mob;
		
		public function ModelEvent(type:String, subject:Mob, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.subject = subject;
			super(type, bubbles, cancelable);
		}
	}
}