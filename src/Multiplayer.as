/**
* ...
* @author Default
* @version 0.1
*/

package  {
	
		
		import com.demonsters.debugger.MonsterDebugger;
		import flash.events.Event;
		import flash.events.IOErrorEvent;
		import flash.events.SecurityErrorEvent;
		import flash.events.TimerEvent;
		import flash.system.Security;
		import flash.system.SecurityPanel;
		import flash.text.TextField;
	


		import flash.net.navigateToURL;
		import flash.net.URLRequest;
		import flash.net.URLVariables;
		import flash.net.URLLoader;
		import flash.net.URLRequestMethod;


	public class Multiplayer{
		
	
		public static var readyCallback:Function;
		public static var clientPlayer:Player;
		public static var connectionLost:Boolean;
		static private var _client:IClient;
		
		
			
		public static function init(player:Player,callback:Function,client:IClient) :void
		{
			readyCallback = callback;
			clientPlayer = player;
			_client = client;
			
			
			_client.setConnectCallback(onConnection);
			_client.setRoomListUpdate(onRoomListUpdate);
			_client.setJoinRoomCallback(onObjectReceived);
			_client.setLeaveRoomCallback(onObjectReceived);
			_client.setObjectReceivedCallback(onObjectReceived);
			
			
			_client.connect();
			
		}
		
		static public function onRoomListUpdate():void 
		{
			
		}
		
		static public function onConnection():void 
		{
			
		}
		
	
		/**
		 * Handle successfull join
		 */
		private static function onJoinRoom(e:Event):void
		{	
			
		}
		
		
		
		/**
		 * Handle left Room
		 */
		public static function onLeaveRoom(e:Event):void
		{
			
		}
			
			
			
			
		/**
		 * Handle Object Received
		 */
		public static function onObjectReceived(...args):void
		{
			
			var userid:String = args[0];
			var objReceived:Object = args[1];
			
			
			//
			MonsterDebugger.trace(Multiplayer.onObjectReceived,"onObjectReceived:"+" for:"+userid);
			
			//if(_client.session.myUser.id == userid)
			switch (objReceived.type)
			{
				case GameStatus.MOVE: 
					MonsterDebugger.trace(Multiplayer.onObjectReceived,"MULTIPLAYER -> remote command MOVE");
					
				   //TODO make tween for smooth
				   InlineShuffle.shooter.x = objReceived.x;
				   InlineShuffle.shooter.z = objReceived.z;
				  
				break;
				
				case GameStatus.SHOOT:
				   MonsterDebugger.trace(Multiplayer.onObjectReceived,"MULTIPLAYER -> remote command SHOOT to:"+_client.getUserName()+" id:"+_client.getUserId());
				   InlineShuffle.shooter.shoot();
				 
				break;
				
				case GameStatus.SHOOTTIMECOMPLETE:
				  //InlineShuffle.shooter.unload(); 
				  MonsterDebugger.trace(Multiplayer.onObjectReceived,"MULTIPLAYER -> remote command SHOOTTIMECOMPLETE");
				  InlineShuffle.shootTimer.dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
				 
				break;
				
				case GameStatus.WON:
					MonsterDebugger.trace(Multiplayer.onObjectReceived,"MULTIPLAYER -> remote command WIN");
					InlineShuffle.showMsgWindow("You Won");
					Game.isStarted = false;
					//Multiplayer.client.disconnect();
					
				break;
				
				case GameStatus.LOSE:
					MonsterDebugger.trace(Multiplayer.onObjectReceived,"MULTIPLAYER -> remote command LOSE");
					InlineShuffle.showMsgWindow("You Lose");
					Game.isStarted = false;
					//Multiplayer.client.disconnect();
				break;
				 
				 
				 
				
			}
			
			
		}


		public static function sendObject(data:Object):void
		{
			
			_client.sendObject(data);
		}
		
		static public function reportMatch():void 
		{
			
		}
	



	}
	
}
