package sp.check 
{
	import assets.ConfigData;
	import assets.PicData;
	import com.hexagonstar.util.debug.Debug;
	import com.zt.utils.MySprite;
	import data.AreaData;
	import poker.FormatResult;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author SamZhou
	 */
	public class CheckPicItem extends MySprite 
	{
		private var bd:BitmapData;
		private var tempBmp:Bitmap;
		
		public function CheckPicItem() 
		{
			super();
		}
		
		override public function init(b:Boolean):void 
		{
			if (b){
				this.buttonMode = true;
				this.addEventListener(MouseEvent.CLICK, onClick);
			}
			else{
				this.buttonMode = false;
				this.removeEventListener(MouseEvent.CLICK, onClick);
			}
		}
		private function onClick(e:MouseEvent):void{
			checkNum();
		}
		
		
		
		/**
		 * 设置数据
		 * @param	sourceBD
		 * @param	p
		 * @param	w
		 * @param	h
		 */
		public function setData(sourceBD:BitmapData, p:Point, w:int, h:int):void{
			var rect:Rectangle = new Rectangle(p.x, p.y, w, h);
			var bytes:ByteArray = sourceBD.getPixels(rect);
			bytes.position = 0;
			bd = new BitmapData(w, h, false, 0xFF0000);
			var b:Bitmap = new Bitmap(bd);
			b.bitmapData.setPixels(new Rectangle(0, 0, w, h), bytes); 
			addChild(b);
		}
		
		/**
		 * 检查 牌面数字
		 */
		public function checkNum():void{
			var len:int = ConfigData.Data.load.pic.length;
			var wLen:int = bd.width;
			var hLen:int = bd.height;
			//wLen = 10;
			//hLen = 14;
			
			//数字区域
			tempBmp = new Bitmap();
			//tempBmp.bitmapData = new BitmapData(wLen, hLen);
			//tempBmp.bitmapData.copyPixels(bd, new Rectangle(0, 0, wLen, hLen), new Point(0,0));
			//tempBmp.y -= bd.height;
			//addChild(tempBmp);
			
			var tempData:FormatResult = new FormatResult();
			var startTime:Date = new Date();
			for (var i:int = 0; i < len; i++ ){
				for (var y:int = 0; y < hLen; y++ ){
					for (var x:int = 0; x < wLen; x++ ){
						tempBmp.bitmapData = new BitmapData(wLen, hLen);
						tempBmp.bitmapData.copyPixels(bd, new Rectangle(0, 0, wLen, hLen), new Point(0,0));
						
						var areaObj:FormatResult = AreaData.GetPkAreaNum(tempBmp.bitmapData, new Point(x, y), PicData.Arr[i]);
						if (tempData.pct < areaObj.pct){
							tempData = areaObj;
						}
					}
				}
			}
			var endTime:Date = new Date();
			var time:Number = endTime.time - startTime.time;
			Debug.trace(["计算完？" , tempData.pct, tempData.pctReverse, tempData.name, "耗时:" + time].toString());
		}
		
		
		
		
		
		
	}

}