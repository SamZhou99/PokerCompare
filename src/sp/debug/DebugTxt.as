package sp.debug 
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import com.zt.utils.MySprite;
	
	/**
	 * ...
	 * @author SamZhou
	 */
	public class DebugTxt extends MySprite 
	{
		private var tf:TextFormat;
		private var txt:TextField;
		
		public function DebugTxt() 
		{
			super();
			initTF();
			initTxt();
		}
		public function text(s:String):void{
			txt.appendText(s+"\n");
			txt.setTextFormat(tf);
			txt.scrollV = txt.maxScrollV;
		}
		
		
		
		override public function init(b:Boolean):void 
		{
			if (b){
				onResize();
				stage.addEventListener(Event.RESIZE, onResize);
			}
			else{
				stage.removeEventListener(Event.RESIZE, onResize);
			}
		}
		private function onResize(e:Event=null):void{
			this.x = stage.stageWidth - this.width;
			this.y = stage.stageHeight - this.height;
		}
		
		private function initTxt():void{
			txt = new TextField();
			txt.type = TextFieldType.INPUT;
			txt.width = 300;
			txt.height = 80;
			txt.background = true;
			txt.border = true;
			addChild(txt);
		}
		private function initTF():void{
			tf = new TextFormat();
			tf.size = 14;
			tf.font = "Courier New";
		}
		
		
		
		
		
		
		
		
		
	}

}