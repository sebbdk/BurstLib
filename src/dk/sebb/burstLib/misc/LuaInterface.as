package dk.sebb.burstLib.misc
{
	import dk.sebb.burstLib.model.TMXLevelModel;
	
	import luaAlchemy.LuaAlchemy;
	
	public class LuaInterface extends LuaAlchemy
	{
		public function LuaInterface() {
			var stack:Array = doString( (<![CDATA[
				function teleport(a)
					as3.class.dk.sebb.burstLib.misc.LuaInterface.teleport(a);
				end
				
				function say(a)
					as3.class.dk.sebb.burstLib.misc.LuaInterface.say(a);
				end

				function dialog(a)
					as3.class.dk.sebb.burstLib.misc.LuaInterface.dialog(a);
				end
			]]>).toString() );
		}

		public static function teleport(id:String):void {
			TMXLevelModel.instance.teleportPlayerTo(id);
		}
		
		public static function say(str:String):void {
			TMXLevelModel.instance.player.write(str);
		}
		
		public static function dialog(str:String):void {
			TMXLevelModel.infoBox.visible = true;
			TMXLevelModel.infoBox.write(str);
		}
	}
}