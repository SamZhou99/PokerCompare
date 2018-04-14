package sp.areadrag 
{
	import com.hexagonstar.util.debug.Debug;
	import com.zt.utils.MySprite;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author SamZhou
	 */
	public class AreaDrag extends MySprite 
	{
		private var xx:int;
		private var yy:int;
		private var w:uint;
		private var h:uint;
		private var bgColor:uint;
		private var lable:String;
		
		private var isDraging:Boolean;
		private var bgSp:Sprite;
		private var dragSp:Sprite;
		private var lableTxt:TextField;
		
		
		
		public function AreaDrag(x:int, y:int, w:uint, h:uint, bgColor:uint, lable:String = "") 
		{
			super();
			this.xx = x;
			this.yy = y;
			this.w = w;
			this.h = h;
			this.bgColor = bgColor;
			this.lable = lable;
		}
		
		
		/**
		 * 初始化
		 * @param	b
		 */
		override public function init(b:Boolean):void 
		{
			if (b){
				this.x = xx;
				this.y = yy;
				this.addEventListener(MouseEvent.ROLL_OVER, onRollOverThis);
				this.addEventListener(MouseEvent.ROLL_OUT, onRollOutThis);
			}
			else{
				this.removeEventListener(MouseEvent.ROLL_OVER, onRollOverThis);
				this.removeEventListener(MouseEvent.ROLL_OUT, onRollOutThis);
			}
			
			initUI(b);
			
		}
		
		
		/**
		 * 获取 位置与大小
		 * @return	Rectangle
		 */
		public function getRectangle():Rectangle{
			return new Rectangle(this.x, this.y, this.width, this.height);
		}
		
		
		/**
		 * 初始化UI
		 */
		private function initUI(isShow:Boolean):void{
			if (isShow){
				if (bgSp == null){
					bgSp = new Sprite;
					var bgGr:Graphics = bgSp.graphics;
					bgGr.beginFill(bgColor, 0.3);
					bgGr.lineStyle(0.1, 0x000000, 0.5);
					bgGr.drawRect(0, 0, w, h);
					bgGr.endFill();
					bgSp.scale9Grid = new Rectangle(10, 10, w - 20, h - 20);
					addChild(bgSp);
					bgSp.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownBgSp);
				}
				
				if (dragSp == null){
					dragSp = new Sprite;
					var pointA:Point = new Point(10, 0);
					var pointB:Point = new Point(10, 10);
					var pointC:Point = new Point(0, 10);
					var TriangleGr:Graphics = dragSp.graphics;
					TriangleGr.beginFill(0xFFFFFF);
					TriangleGr.moveTo(pointA.x,pointA.y);
					TriangleGr.lineTo(pointB.x,pointB.y);
					TriangleGr.lineTo(pointC.x,pointC.y);
					TriangleGr.lineTo(pointA.x, pointA.y);
					TriangleGr.endFill();
					dragSp.x = w - 10;
					dragSp.y = h - 10;
					dragSp.buttonMode = true;
					addChild(dragSp);
					dragSp.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownDragSp);
				}
				
				if (lableTxt == null){
					lableTxt = new TextField;
					lableTxt.autoSize = TextFieldAutoSize.LEFT;
					lableTxt.background = true;
					lableTxt.mouseEnabled = false;
					lableTxt.text = lable;
					lableTxt.setTextFormat(new TextFormat("Courier New", 12));
					lableTxt.alpha = 0.7;
					lableTxt.x = lableTxt.y = 1;
					lableTxt.cacheAsBitmap = true;
					addChild(lableTxt);
				}
			}
			else{
				bgSp.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownBgSp);
				removeChild(bgSp);
				bgSp = null;
				
				dragSp.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownDragSp);
				removeChild(dragSp);
				dragSp = null;
				
				removeChild(lableTxt);
				lableTxt = null;
			}
			
		}
		
		
		/**
		 * 鼠标移进，移出
		 * @param	e
		 */
		private function onRollOverThis(e:MouseEvent):void{
			this.alpha = 1;
			this.parent.setChildIndex(this, this.parent.numChildren-1);
		}
		private function onRollOutThis(e:MouseEvent):void{
			if(!isDraging) this.alpha = 0.3;
		}
		
		
		/**
		 * 背景移动
		 * @param	e
		 */
		private function onMouseDownBgSp(e:MouseEvent):void{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpBgSpStage);
			this.startDrag();
		}
		private function onMouseUpBgSpStage(e:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpBgSpStage);
			this.stopDrag();
		}
		
		
		/**
		 * 改变宽高
		 * @param	e
		 */
		private function onMouseDownDragSp(e:MouseEvent):void{
			isDraging = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpDragSpStage);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveDragSpStage);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeaveDragSpStage);
		}
		private function onMouseMoveDragSpStage(e:MouseEvent):void{
			e.updateAfterEvent();
			dragSp.startDrag(false, new Rectangle(lableTxt.width, 20, this.parent.width, this.parent.height));
			bgSp.width = int(dragSp.x + 10);
			bgSp.height = int(dragSp.y + 10);
		}
		private function onMouseLeaveDragSpStage(e:Event):void{
			onMouseUpDragSpStage();
		}
		private function onMouseUpDragSpStage(e:MouseEvent=null):void{
			isDraging = false;
			dragSp.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpDragSpStage);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveDragSpStage);
		}
		
		
		
		
	}

}