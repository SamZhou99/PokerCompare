package sp.cam 
{
	import com.hexagonstar.util.debug.Debug;
	import com.zt.utils.MySprite;
	import com.zt.utils.TimerRun;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import sp.areadrag.AreaDrag;
	
	/**
	 * ...
	 * @author SamZhou
	 */
	public class ImageSocketSp extends MySprite 
	{
		public var callback:Function;
		
		private var so:SharedObject;
		private var leftArea:AreaDrag;
		private var rightArea:AreaDrag;
		private var loader:Loader;
		
		
		
		public function ImageSocketSp(width:uint = 480, height:uint = 360) 
		{
			super();
			var g:Graphics = this.graphics;
			g.beginFill(0x333333);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
		
		override public function init(b:Boolean):void 
		{
			if (b){
				// SharedObject 本地记录 左右区域大小与位置
				so = SharedObject.getLocal("SamZ_PK_SO_V1_20170916");
				
				loader = new Loader();
				addChild(loader);
				
				showAreaLeft();
				showAreaRight();
				
				MainEvent.DIS.addEventListener(MainEvent.SOCKET_IMG_EVENT, onSOCKET_IMG_EVENT);
				
				var tr:TimerRun = new TimerRun(onTimerEvent);
				tr.start(1000, 1);
			}
			else{
				removeChild(loader);
				loader = null;
				
				removeChild(leftArea);
				leftArea = null;
				removeChild(rightArea);
				rightArea = null;
				
				MainEvent.DIS.removeEventListener(MainEvent.SOCKET_IMG_EVENT, onSOCKET_IMG_EVENT);
			}
		}
		/**
		 * 获取左右边区域 BitmapData
		 * @return
		 */
		public function getLeftAreaBD():BitmapData{
			var target:DisplayObject = loader;
			var rect:Rectangle = leftArea.getRectangle();
			var bd:BitmapData = new BitmapData(target.width, target.height);
			bd.draw(target);
			var temp:BitmapData = new BitmapData(rect.width, rect.height, false, 0xFF0000);
			temp.copyPixels(bd, rect, new Point());
			saveOS();
			return temp;
		}
		public function getRightAreaBD():BitmapData{
			var target:DisplayObject = loader;
			var rect:Rectangle = rightArea.getRectangle();
			var bd:BitmapData = new BitmapData(target.width, target.height);
			bd.draw(target);
			var temp:BitmapData = new BitmapData(rect.width, rect.height, false, 0xFF0000);
			temp.copyPixels(bd, rect, new Point());
			return temp;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function onTimerEvent():void{
			if (callback != null) callback();
		}
		
		private function onSOCKET_IMG_EVENT(e:MainEvent):void{
			var imgBuff:ByteArray = e.parms.buffer;
			loader.loadBytes(imgBuff);
			
			var tr:TimerRun = new TimerRun(onImgBuffTimerEvent);
			tr.start(100,1);
		}
		private function onImgBuffTimerEvent():void{
			 MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SCREENSHOT_MATCHING_EVENT, {}));
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function showAreaLeft():void{
			if (leftArea == null){
				var rect:Rectangle = new Rectangle(0, 0, 100, 100);
				if (so.data.rect != null && so.data.rect.left != null){
					rect.x = so.data.rect.left.x;
					rect.y = so.data.rect.left.y;
					rect.width = so.data.rect.left.width;
					rect.height = so.data.rect.left.height;
				}
				leftArea = new AreaDrag(rect.x, rect.y, rect.width, rect.height, 0xFF0000, "Banker");
				addChild(leftArea);
				return;
			}
			removeChild(leftArea);
			leftArea = null;
		}
		
		private function showAreaRight():void{
			if (rightArea == null){
				var rect:Rectangle = new Rectangle(120, 0, 100, 100);
				if (so.data.rect != null && so.data.rect.right != null){
					rect.x = so.data.rect.right.x;
					rect.y = so.data.rect.right.y;
					rect.width = so.data.rect.right.width;
					rect.height = so.data.rect.right.height;
				}
				rightArea = new AreaDrag(rect.x, rect.y, rect.width, rect.height, 0x0066FF, "Player");
				addChild(rightArea);
				return;
			}
			removeChild(rightArea);
			rightArea = null;
		}
		
		/**
		 * 保存 os
		 */
		private function saveOS():void{
			var leftRect:Rectangle = leftArea.getRectangle();
			var rightRect:Rectangle = rightArea.getRectangle();
			
			var rectData:Object = {
				left:{
					x:leftRect.x,
					y:leftRect.y,
					width:leftRect.width,
					height:leftRect.height
				},
				right:{
					x:rightRect.x,
					y:rightRect.y,
					width:rightRect.width,
					height:rightRect.height
				}
			};
			so.setProperty("rect", rectData); 
			so.flush();
		}
		
		
		
		
		
		
		
		
		
		
		
	}

}