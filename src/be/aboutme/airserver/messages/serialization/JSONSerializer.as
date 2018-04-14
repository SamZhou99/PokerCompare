package be.aboutme.airserver.messages.serialization
{
	import be.aboutme.airserver.messages.Message;
	import com.hexagonstar.util.debug.Debug;
	
	//import by.blooddy.crypto.serialization.JSON;
	
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	public class JSONSerializer implements IMessageSerializer
	{
		
		private var encodeMethod:Function;
		private var decodeMethod:Function;
		
		protected var messageDelimiter:String;

		public function JSONSerializer(messageDelimiter:String = "\n")
		{
			this.messageDelimiter = messageDelimiter;
			//check if native JSON is supported
			//if(ApplicationDomain.currentDomain.hasDefinition("JSON"))
			//{
				encodeMethod = getDefinitionByName("JSON").stringify;
				decodeMethod = getDefinitionByName("JSON").parse;
			//}
			//else
			//{
				//encodeMethod = by.blooddy.crypto.serialization.JSON.encode;
				//decodeMethod = by.blooddy.crypto.serialization.JSON.decode;
			//}
		}
		
		public function serialize(message:Message):*
		{
			return encodeMethod(message);
		}
		
		public function deserialize(serialized:*):Vector.<Message>
		{
			var split:Array = serialized.split(messageDelimiter);
			var messages:Vector.<Message> = new Vector.<Message>();
			for each(var input:String in split)
			{
				if(input.length > 0)
				{
					var message:Message = new Message();
					try{
						var decoded:Object = decodeMethod(input);
						if(decoded.hasOwnProperty("senderId")) message.senderId = decoded.senderId;
						if(decoded.hasOwnProperty("command")) message.command = decoded.command;
						if(decoded.hasOwnProperty("data")) message.data = decoded.data;
						else message.data = decoded;
						messages.push(message);
					}catch (e:*){
						Debug.trace("JSON ERROR Start	=============");
						Debug.trace(input);
						Debug.trace("JSON ERROR End		=============");
					}
				}
			}
			return messages;
		}
	}
}