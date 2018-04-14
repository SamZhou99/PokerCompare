package sp.cam 
{
	import com.hexagonstar.util.debug.Debug;
	import com.zt.utils.MySprite;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import sp.areadrag.AreaDrag;
	
	/**
	 * 主类
	 * @author SamZhou
	 */
	public class CamVideo extends MySprite 
	{
		public var callback:Function;			//回调
		public var vWidth:uint;					//视频宽高
		public var vHeihgt:uint;
		
		private var camSelect:CamSelect;		//视频驱动选择
		private var video:VideoSp;				//视频容器
		private var gr:Graphics;
		
		private var so:SharedObject;
		private var leftArea:AreaDrag;
		private var rightArea:AreaDrag;
		
		
		
		/**
		 * 摄像头与视频
		 * @param	width
		 * @param	height
		 */
		public function CamVideo(width:uint=320, height:uint=240)
		{
			super();
			vWidth = width;
			vHeihgt = height;
			
			so = SharedObject.getLocal("SamZ_PK_SO_V1_20170916");
			
			gr = this.graphics;
			showBg(width, height);
			showCamSelect();
		}
		
		
		/**
		 * 初始化
		 * @param	b
		 */
		override public function init(b:Boolean):void 
		{
			if (b){
			}
			else{
			}
		}
		
		/**
		 * 获取左右边区域 BitmapData
		 * @return
		 */
		public function getLeftAreaBD():BitmapData{
			var rect:Rectangle = leftArea.getRectangle();
			var bd:BitmapData = new BitmapData(video.width, video.height);
			bd.draw(video);
			var temp:BitmapData = new BitmapData(rect.width, rect.height, false, 0xFF0000);
			temp.copyPixels(bd, rect, new Point());
			saveOS();
			return temp;
		}
		public function getRightAreaBD():BitmapData{
			var rect:Rectangle = rightArea.getRectangle();
			var bd:BitmapData = new BitmapData(video.width, video.height);
			bd.draw(video);
			var temp:BitmapData = new BitmapData(rect.width, rect.height, false, 0xFF0000);
			temp.copyPixels(bd, rect, new Point());
			return temp;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 已选择 摄像头
		 * @param	data
		 */
		private function onCamSelectEvent(data:FormatResultCam):void{
			removeChild(camSelect);
			showVideo(data);
			
			showAreaLeft();
			showAreaRight();
			
			if (callback != null){
				callback();
			}
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
				rightArea = new AreaDrag(rect.x, rect.y, rect.width, rect.height, 0x00FF00, "Player");
				addChild(rightArea);
				return;
			}
			removeChild(rightArea);
			rightArea = null;
		}
		
		/**
		 * 显示背景
		 * @param	w
		 * @param	h
		 */
		private function showBg(w:uint, h:uint):void{
			gr.beginFill(0x333333);
			gr.drawRect(0, 0, w, h);
			gr.endFill();
		}
		
		/**
		 * 显示选择ITEM
		 */
		private function showCamSelect():void{
			camSelect = new CamSelect;
			camSelect.callback = onCamSelectEvent;
			addChild(camSelect);
		}
		
		/**
		 * 显示视频容器
		 * @param	data
		 */
		private function showVideo(data:FormatResultCam):void{
			video = new VideoSp(data, vWidth, vHeihgt);
			addChild(video);
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