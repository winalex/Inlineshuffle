/**
* ...
* @author Default
* @version 0.1
*/

package  {

	public class Game {
		
		//Game type
		public static const MULTI:uint = 0;
		public static const Single:uint = 1;
		public static const HotSeat:uint = 2;
		
		public static const EXPERT_MODE:uint = 1;
		public static const NORMAL_MODE:uint = 0;
		
		//public static const SERVER_URL:String = "rtmfp://p2p.rtmfp.net/650c369e2ecb85e41d3d3aa5-3e7ab35fe6bd/";
	
		
		public static const SERVER_URL:String = "rtmfp://p2p.rtmfp.net/2237f854c6a521b2abdbe8ef-14778a1f3679";
		
		///////////////////////////////////////
		public static var enabeld:Boolean = false;
		
		//Game name and id
		private static var _name:String = "game1";
		private static var _mode:uint = 0;
		public static var id:uint;
		
		
		
		public static var type:uint;
		public static var zone:String = "zone1";
		public static var isStarted:Boolean = false;
		public static var debug:Boolean = false;
		
		public static function set name(name:String):void
		{
			if(name!="" && name!=null)
			Game._name = name;
		}
		
		public static function get name():String
		{
			trace("GAME -> room name:"+Game._name);
			return Game._name;
		}
		
		static public function get mode():uint 
		{
			return _mode;
		}
		
		static public function set mode(value:uint):void 
		{
			_mode = value;
		}
		
		
		
	}
	
}
