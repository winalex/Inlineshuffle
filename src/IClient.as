package  
{
	
	/**
	 * ...
	 * @author winxalex
	 */
	public interface IClient 
	{
		function setConnectCallback(f:Function):void;
		function setRoomListUpdate(f:Function):void;
		function setObjectReceivedCallback(f:Function):void;
		function connect(...args):void;
		function sendObject(data:Object):void;
		
		function setJoinRoomCallback(onObjectReceived:Function):void;
		
		function setLeaveRoomCallback(onObjectReceived:Function):void;
		
		function getUserName():void;
		
		function getUserId():void;
		
		
		
	}
	
}