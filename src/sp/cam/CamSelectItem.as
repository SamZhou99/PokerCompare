package sp.cam 
{
	import com.zt.utils.MySprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author SamZhou
	 */
	public class CamSelectItem extends MySprite 
	{
		public var camName:String;
		public var camIndex:int;
		public var callback:Function;
		public var data:FormatResultCam;
		
		private var txtFt:TextFormat;
		private var txt:TextField;
		
		
		public function CamSelectItem() 
		{
			super();
			txtFt = fontFT();
			
			txt = initText();
			txt.text = "-";
			txt.mouseEnabled = false;
			addChild(txt);
		}
		
		
		override public function init(b:Boolean):void 
		{
			if (b){
				this.buttonMode = true;
				this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
				this.addEventListener(MouseEvent.CLICK, onClick);
			}
			else{
				this.buttonMode = false;
				this.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
				this.removeEventListener(MouseEvent.CLICK, onClick);
			}
		}
		
		/**
		 * 鼠标 移进
		 * @param	e
		 */
		private function onRollOver(e:MouseEvent):void{
			txt.textColor = 0x3366FF;
		}
		
		/**
		 * 鼠标 移出
		 * @param	e
		 */
		private function onRollOut(e:MouseEvent):void{
			txt.textColor = 0x000000;
		}
		
		/**
		 * 点击
		 * @param	e
		 */
		private function onClick(e:MouseEvent=null):void{
			data = new FormatResultCam();
			data.camName = camName;
			data.camIndex = camIndex;
			if (callback != null){
				callback(data);
			}
		}
		
		/**
		 * 设置文字
		 * @param	s
		 */
		public function setText(s:String):void{
			txt.text = s;
			txt.setTextFormat(txtFt);
		}
		
		/**
		 * 初始化 文本容器
		 * @return
		 */
		private function initText():TextField{
			var t:TextField = new TextField;
			t.width = 320;
			t.height = 32;
			t.background = true;
			t.border = true;
			return t;
		}
		
		/**
		 * 字体样式
		 * @return
		 */
		private function fontFT():TextFormat{
			var ft:TextFormat = new TextFormat();
			ft.size = 22;
			return ft;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}

}