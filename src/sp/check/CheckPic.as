package sp.check 
{
	
	import assets.PicData;
	import com.hexagonstar.util.debug.Debug;
	import com.zt.effect.FiterEffect;
	import com.zt.utils.MySprite;
	import com.zt.utils.TimerRun;
	import data.AreaData;
	import poker.FormatResult;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author SamZhou
	 */
	public class CheckPic extends MySprite 
	{
		private const STEP:int = 2;					//计算步长
		private var isStage:Boolean;					//是否已添加到场景
		
		private var sourceSp:Sprite;					//源Sprite
		private var sourceBmp:Bitmap;				//源图
		private var sourceBD:BitmapData;			//源图数据
		
		private var itemArr:Array;						//截取的扑克
		
		
		
		public function CheckPic() 
		{
			super();
		}
		
		/**
		 * 初始化
		 * @param	b
		 */
		override public function init(b:Boolean):void 
		{
			isStage = b;
			if (b){
				this.buttonMode = true;
				this.addEventListener(MouseEvent.CLICK, onClick);
			}
			else{
				this.buttonMode = false;
				this.removeEventListener(MouseEvent.CLICK, onClick);
			}
		}
		
		/**
		 * 点击事件
		 * @param	e
		 */
		private function onClick(e:MouseEvent):void{
			startCalculationImage();
		}
		
		/**
		 * 设置 SP原
		 * @param	sp
		 */
		public function setSp(sp:Sprite):void{
			this.sourceSp = sp;
			
			if (sourceBmp == null){
				sourceBD = new BitmapData(sp.width, sp.height, false, 0x000000);
				sourceBmp = new Bitmap(sourceBD);
				sourceBmp.smoothing = true;
				addChild(sourceBmp);
			}
			
			loopDraw();
			//var tr:TimerRun = new TimerRun(onTime);
			//tr.start(500, 1);
		}
		
		/**
		 * 循环 复制原图
		 */
		private function onTime():void{
			loopDraw();
		}
		/**
		 * 绘制 当前SP
		 */
		private function loopDraw():void{
			sourceBD.draw(sourceSp);
			thresholdImage();
		}
		
		/**
		 * 阈值 图片
		 */
		private function thresholdImage():void{
			FiterEffect.setBmp(sourceBD, FiterEffect.MatrixThreshold(170));
		}
		
		/**
		 * 计算 图片
		 */
		private function startCalculationImage():void{
			if (itemArr != null){
				for (var i:int = 0; i < itemArr.length; i++ ){
					removeChild(itemArr[i]);
				}
				itemArr = null;
			}
			step1();
		}
		/**
		 * 获取牌 大概位置
		 */
		private function step1():void{
			Debug.trace("===================>");
			itemArr = [];
			var index:int = 0;
			var w:int = sourceBD.width;
			var h:int = sourceBD.height;
			var startTime:Date = new Date();
			for (var xx:int = 0; xx < w; xx += 1 ){
				for (var yy:int = 0; yy < h; yy += STEP ){
					
					//找到牌位置
					var resultArea:FormatResult = AreaData.GetPKArea(sourceBD, new Point(xx, yy), PicData.Obj["Bg"]);
					if (resultArea.pct > 95){
						Debug.trace(resultArea.pct);
						var item:CheckPicItem = new CheckPicItem();
						item.setData(sourceBD, new Point(xx, yy), resultArea.width, resultArea.height);
						item.x = (sourceBmp.width + sourceBmp.x) + (index * (resultArea.width+10));
						addChild(item);
						itemArr.push(item);
						
						xx = xx + resultArea.width;
						yy = yy + resultArea.height;
						index++;
					}
					
				}
			}
			//(itemArr[1] as CheckPicItem).checkNum();	//测试第几张牌
			
			var endTime:Date = new Date();
			var time:Number = endTime.time - startTime.time;
			MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.ERROR_TEXT, {text:["共几张牌:" + index, "耗时:" + time+"秒"].toString()}));
		}
		
		
		
		
	}

}