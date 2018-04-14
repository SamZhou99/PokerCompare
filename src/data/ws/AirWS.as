package data.ws 
{
	import be.aboutme.airserver.AIRServer;
	import be.aboutme.airserver.endpoints.socket.SocketEndPoint;
	import be.aboutme.airserver.endpoints.socket.handlers.websocket.WebSocketClientHandlerFactory;
	import be.aboutme.airserver.events.AIRServerEvent;
	import be.aboutme.airserver.events.MessageReceivedEvent;
	import be.aboutme.airserver.messages.Message;
	import be.aboutme.airserver.messages.serialization.JSONSerializer;
	import com.hexagonstar.util.debug.Debug;
	
	
	/**
	 * WebSocket
	 * @author SamZhou
	 */
	public class AirWS 
	{
		
		private var port:uint;
		private var server:AIRServer;
		
		
		public function AirWS(port:uint) 
		{
			this.port = port;
		}
		
		
		/**
		 * 初始化服务
		 */
		public function initServer():void{
			server = new AIRServer;
			server.addEndPoint(new SocketEndPoint(port, new WebSocketClientHandlerFactory(new JSONSerializer())));
			server.addEventListener(AIRServerEvent.CLIENT_ADDED, onClientAddedHandler);
			server.addEventListener(AIRServerEvent.CLIENT_REMOVED, onClientRemovedHandler);
			server.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED, onMessageReceivedHandler);
			server.start();
		}
		
		/**
		 * 发送消息
		 * @param	text
		 * @return
		 */
		public function sendMsg(text:String = ""):Boolean{
			if (server == null) return false;
			var msg:Message = new Message();
			msg.command = "MESSAGE";
			msg.data = text;
			server.sendMessageToAllClients(msg);
			return true;
		}
		
		
		
		
		
		private function onClientAddedHandler(e:AIRServerEvent):void{
			Debug.trace("clientAddedHandler:" + e.toString());
		}
		private function onClientRemovedHandler(e:AIRServerEvent):void{
			Debug.trace("clientRemovedHandler:" + e.toString());
		}
		private function onMessageReceivedHandler(e:MessageReceivedEvent):void{
			Debug.trace("messageReceivedHandler:" + e.toString());
		}
		
		
		
		
		
		
		
		
		
	}

}