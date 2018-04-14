package controllers 
{
	import com.hexagonstar.util.debug.Debug;
	import com.zt.utils.MySprite;
	import com.zt.utils.TimerRun;
	import com.zt.utils.Util;
	import fl.controls.Button;
	import fl.controls.TextArea;
	import fl.managers.StyleManager;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author SamZhou
	 */
	public class ButtonController extends MySprite 
	{
		private var startCompareBtn:Button;		//开始截图匹配
		private var areaLeftBtn:Button;			//左边区域
		private var areaRightBtn:Button;		//右边区域
		private var area:TextArea;				//文本区域
		private var pkListSp:Sprite;
		private var bgSp:Sprite;
		
		private var isAuto:Boolean;				//是否 自动
		private var tr:TimerRun;
		
		public function ButtonController() 
		{
			super();
			bgSp = new Sprite;
			var g:Graphics = bgSp.graphics;
			g.beginFill(0XFFFFFF);
			g.drawRect(0, 0, 200, 340);
			g.endFill();
			addChild(bgSp);
		}
		
		/**
		 * 初始化
		 * @param	b
		 */
		override public function init(b:Boolean):void 
		{
			if (b){
				initUI();
				onResize(null);
				stage.addEventListener(Event.RESIZE, onResize);
				MainEvent.DIS.addEventListener(MainEvent.OUT_TEXT_EVENT, onOUT_TEXT_EVENT);
				MainEvent.DIS.addEventListener(MainEvent.SHOW_BMP, onSHOW_BMP);
				MainEvent.DIS.addEventListener(MainEvent.CLEAR_BMP, onCLEAR_BMP);
				startCompareBtn.addEventListener(MouseEvent.CLICK, onClickStartCompareBtn);
				areaLeftBtn.addEventListener(MouseEvent.CLICK, onClickAreaLeftBtn);
				areaRightBtn.addEventListener(MouseEvent.CLICK, onClickAreaRightBtn);
			}
			else{
				stage.removeEventListener(Event.RESIZE, onResize);
				MainEvent.DIS.removeEventListener(MainEvent.OUT_TEXT_EVENT, onOUT_TEXT_EVENT);
				MainEvent.DIS.removeEventListener(MainEvent.SHOW_BMP, onSHOW_BMP);
				MainEvent.DIS.removeEventListener(MainEvent.CLEAR_BMP, onCLEAR_BMP);
				startCompareBtn.removeEventListener(MouseEvent.CLICK, onClickStartCompareBtn);
				areaLeftBtn.removeEventListener(MouseEvent.CLICK, onClickAreaLeftBtn);
				areaRightBtn.removeEventListener(MouseEvent.CLICK, onClickAreaRightBtn);
				removeUI();
			}
		}
		
		
		/**
		 * 设置 是否禁用 按钮
		 * @param	b
		 */
		public function setEnaled(b:Boolean):void{
			startCompareBtn.enabled = areaLeftBtn.enabled = areaRightBtn.enabled = area.enabled = b;
		}
		
		
		
		
		
		
		/**
		 * 改变大小事件
		 * @param	e
		 */
		private function onResize(e:Event):void{
			bgSp.width = stage.stageWidth;
			this.y = stage.stageHeight - bgSp.height;
		}
		
		/**
		 * 输出文字
		 * @param	e
		 */
		private function onOUT_TEXT_EVENT(e:MainEvent):void{
			var str:String = e.parms.text + "\n";
			//area.appendText(str);
			area.htmlText += str;
			area.verticalScrollPosition = area.maxVerticalScrollPosition;
		}
		
		/**
		 * 点击开始
		 * @param	e
		 */
		private function onClickStartCompareBtn(e:MouseEvent):void{
			if (isAuto && tr != null){
				tr.stop();
				tr = null;
				startCompareBtn.label = "自动采集";
			}
			else{
				tr = new TimerRun(onTimerAuto);
				tr.start(1000, 1000);
				//onTimerAuto();
				startCompareBtn.label = "停止采集";
			}
			isAuto = !isAuto;
		}
		private function onTimerAuto():void{
			//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SCREENSHOT_MATCHING_EVENT, {}));
		}
		
		/**
		 * 点击 左边区域按钮
		 * @param	e
		 */
		private function onClickAreaLeftBtn(e:MouseEvent):void{
			MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.AREA_LEFT_EVENT, {}));
		}
		
		/**
		 * 点击 右边区域按钮
		 * @param	e
		 */
		private function onClickAreaRightBtn(e:MouseEvent):void{
			MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.AREA_RIGHT_EVENT, {}));
		}
		
		/**
		 * 显示图片事件
		 * @param	e
		 */
		private function onSHOW_BMP(e:MainEvent):void{
			e.parms.bmp.scaleX = e.parms.bmp.scaleY = 0.75;
			e.parms.bmp.x = pkListSp.width + 2;
			(e.parms.bmp as Bitmap).smoothing = true;
			pkListSp.addChild(e.parms.bmp);
		}
		
		/**
		 * 清除图片事件
		 * @param	e
		 */
		private function onCLEAR_BMP(e:MainEvent):void{
			Util.ClearAll(pkListSp);
		}
		
		/**
		 * 初始化UI
		 */
		private function initUI():void{
			startCompareBtn = new Button();
			startCompareBtn.label = "自动采集";
			startCompareBtn.height = 100;
			//addChild(startCompareBtn);
			
			areaLeftBtn = new Button();
			areaLeftBtn.label = "庄区域";
			areaLeftBtn.height = 40;
			areaLeftBtn.y = startCompareBtn.y + startCompareBtn.height + 10;
			//addChild(areaLeftBtn);
			
			areaRightBtn = new Button();
			areaRightBtn.label = "闲区域";
			areaRightBtn.height = 40;
			areaRightBtn.y = areaLeftBtn.y + areaLeftBtn.height + 10;
			//addChild(areaRightBtn);
			
			area = new TextArea();
			//area.x = startCompareBtn.x + startCompareBtn.width + 5;
			area.width = stage.stageWidth;// stage.stageWidth - area.x;
			area.height = 200;
			addChild(area);
			
			pkListSp = new Sprite;
			pkListSp.opaqueBackground = 0xFF00FF;
			pkListSp.x = 0;
			pkListSp.y = area.y + area.height + 10;
			addChild(pkListSp);
			
			startCompareBtn.enabled = areaLeftBtn.enabled = areaRightBtn.enabled = area.enabled = false;
		}
		
		/**
		 * 移除UI
		 */
		private function removeUI():void{
			removeChild(startCompareBtn);
			startCompareBtn = null;
			
			removeChild(areaLeftBtn);
			areaLeftBtn = null;
			
			removeChild(areaRightBtn);
			areaRightBtn = null;
			
			removeChild(area);
			area = null;
			
			removeChild(pkListSp);
			pkListSp = null;
		}
		
		
		
		
	}

}