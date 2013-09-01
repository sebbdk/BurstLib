/**
 * This is a static used to manage which keys are currently pressed
 * To make this class work please call the static method Key.init with stage as a arguement to allot it to bind events to the keyboard
 */
package dk.sebb.jazzlib.util
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	public class Key
	{
		private static var heldKeys:Array = [];
		private static var keyUpRecord:Array = [];
		private static var keyDownRecord:Array = [];
		
		private static var keyMap:Array = [];
		
		public static var stage:Stage;

/**
 * This class cannot be instantiated.
 * @return void
 */
		public static function get instance():Key {
			throw new Error('The Key Class is not supposed to be instatiated!');
		}

/**
 * Registre stage to allow binding events to the keyboard
 * Only does so on the first call
 * @param  _stage Stage
 * @return Void
 */
		public static function init(_stage:Stage):void {
			if(!_stage) {
				stage = _stage;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
		}

/**
 * Return a boolean describing if a key is currently held down
 * Used in conjunction with the Flash Keyboard class like this: Key.isDown(Keyboard.W);
 * @param  keyCode int
 * @return Boolean
 */
		public static function isDown(keyCode:int):Boolean {
			return heldKeys[keyCode] === true;
		}

/**
 * Regitreres a key as down
 * @param  evt KeyboardEvent
 * @return void
 */
		private static function onKeyDown(evt:KeyboardEvent):void {
			heldKeys[evt.keyCode] = true;
			var myDate:Date = new Date();
			var currentTime:int = Math.round(myDate.getTime());
			keyDownRecord[currentTime] = evt.keyCode;
		}

/**
 * Removes a key as being registrered as down
 * @param  evt KeyboardEvent
 * @return void
 */
		private static function onKeyUp(evt:KeyboardEvent):void {
			heldKeys[evt.keyCode] = false;
			var myDate:Date = new Date();
			var currentTime:int = Math.round(myDate.getTime());
			keyUpRecord[currentTime] = evt.keyCode;
		}
	}
}