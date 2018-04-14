package sp.cam 
{
	import com.zt.utils.MySprite;
	import flash.events.Event;
	import flash.media.Camera;
	
	/**
	 * ...
	 * @author SamZhou
	 */
	public class CamSelect extends MySprite 
	{
		public var callback:Function;
		
		public function CamSelect() 
		{
			super();
		}
		
		override public function init(b:Boolean):void 
		{
			if (b){
				if (!checkSupported()) return;
				showItem();
				onResize();
				stage.addEventListener(Event.RESIZE, onResize);
			}
			else{
				stage.removeEventListener(Event.RESIZE, onResize);
			}
		}
		
		private function onResize(e:Event = null):void{
			//this.x = stage.stageWidth - this.width;
		}
		
		
		
		
		/**
		 * 检查 设备是否支持
		 */
		private function checkSupported():Boolean{
			var b:Boolean = Camera.isSupported;
			if (!b){
				var item:CamSelectItem = new CamSelectItem;
				item.setText("不支持 摄像头 设备");
				addChild(item);
			}
			return b;
		}
		
		/**
		 * 显示 设备选项
		 */
		private function showItem():void{
			var a:Array = Camera.names;
			var len:int = a.length;
			
			if (len <= 0){
				var item:CamSelectItem = new CamSelectItem;
				item.setText("没有找到 摄像头 设备");
				addChild(item);
				return;
			}
			
			for (var i:int = 0; i < len; i++ ){
				var item2:CamSelectItem = new CamSelectItem;
				item2.camIndex = i;
				item2.camName = a[i];
				item2.setText((i + 1) + " : " + a[i]);
				item2.y = item2.height * i;
				item2.callback = onCamSelectItem;
				addChild(item2);
			}
			
			
		}
		
		/**
		 * resultData data{camIndex,camName}
		 * @param	data
		 */
		private function onCamSelectItem(data:FormatResultCam):void{
			if (callback != null){
				callback(data);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}

}