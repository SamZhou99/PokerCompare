package data.ws 
{
	import com.hexagonstar.util.debug.Debug;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 * ...
	 * @author SamZhou
	 */
	public class AirSocketServer 
	{
		private var HOST:String;
		private var PORT:int;
		
		private var server:ServerSocket;
		private var client:Socket;
		
		private var buffer:ByteArray = new ByteArray();//粘包 拆包 处理
		private var bufferPosition:int = 0;
		private var bufferSize:int = 0;
		
		
		public function AirSocketServer(HOST:String, PORT:int) 
		{
			this.HOST = HOST;
			this.PORT = PORT;
		}
		
		public function initServer():void{
			server = new ServerSocket();
			server.addEventListener(ServerSocketConnectEvent.CONNECT, onCONNECT_Server);
			server.addEventListener(Event.CLOSE, onCLOSE_Server);
			server.bind(PORT, HOST);
			server.listen();
			Out("ServerSocket : "+ HOST + ":" + PORT);
		}
		
		private function onCONNECT_Server(e:ServerSocketConnectEvent):void{
			Out("new client add");
			buffer.endian = Endian.LITTLE_ENDIAN;
			client = e.socket;
			client.addEventListener(ProgressEvent.SOCKET_DATA, onSOCKET_DATA);
			client.addEventListener(Event.CLOSE, onCLOST_Client);
		}
		private function onCLOSE_Server(e:Event):void{
			Out("onCLOSE_Server");
		}
		
		
		private function onSOCKET_DATA(e:ProgressEvent):void{
			Out("client.bytesAvailable : " + client.bytesAvailable);
			client.readBytes(buffer, bufferPosition + bufferSize, client.bytesAvailable);
			
			while (0 < buffer.bytesAvailable)
			{
				Out("bufferPosition + bufferSize : "+bufferPosition + bufferSize);
				if (4 > buffer.bytesAvailable){
					Out("buffer 长度不够");
					break;
				}
				
				Out("buffer.bytesAvailable : " + buffer.bytesAvailable);
				
				var len:int = buffer.readInt();
				Out("len : " + len);
				
				if (buffer.bytesAvailable < len){
					Out("剩下的数据不够");
					buffer.position -= 4;
					break;
				}
				
				var imgBuff:ByteArray = new ByteArray();
				imgBuff.endian = buffer.endian;
				buffer.readBytes(imgBuff, 0, len);
				Out("imgBuff : " + imgBuff.length);
				
				//var loader:Loader = new Loader();
				//loader.loadBytes(imgBuff);
				//addChild(loader);
				MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SOCKET_IMG_EVENT, {buffer: imgBuff}));
			}
			
			if (buffer.position < buffer.length){
				bufferPosition = buffer.position;
				bufferSize = buffer.bytesAvailable;
				Out("!!! 拆包 !!!");
				Out("bufferPosition : " + bufferPosition);
				Out("bufferSize : " + bufferSize);
			}else{
				Out("!!! 重置 !!!");
				buffer.clear();
				bufferPosition = 0;
				bufferSize = 0;
			}
			
		}
		private function onCLOST_Client(e:Event):void{
			Out("new client remove");
		}
		
		
		private function Out(str:String):void{
			//Debug.trace(str);
		}
		
		
		
		
		
		
		
	}

}