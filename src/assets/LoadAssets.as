package assets 
{
	import com.adobe.crypto.HMAC;
	import com.hexagonstar.util.debug.Debug;
	import com.zt.net.LoadSwfPool;
	import com.zt.net.MyData;
	import com.zt.net.ObjectRequire;
	import com.zt.utils.MySprite;
	import com.zt.utils.TimerRun;
	import assets.ConfigData;
	import assets.PicData;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import poker.Poker;
	
	/**
	 * 加载资源
	 * @author SamZhou
	 */
	public class LoadAssets extends MySprite 
	{
		private const STEP_NUM:uint = 1;				//采集密度 调整
		private const STEP_NUM_BG:uint = 2;				//背景采集密度
		private var configUrl:String;						//配置资源URL
		private var tf:TextFormat;							//字体样式
		private var ver_txt:TextField;						//文本
		private var loadIndex:int;							//加载资源 索引数
		
		public function LoadAssets(configUrl:String) 
		{
			super();
			this.configUrl = configUrl;
		}
		
		/**
		 * 初始化
		 * @param	b
		 */
		override public function init(b:Boolean):void 
		{
			if (b){
				tf = new TextFormat();
				tf.font = "Courier New";
				
				ver_txt = new TextField();
				ver_txt.width = stage.stageWidth;
				ver_txt.height = 20;
				//ver_txt.border = true;
				ver_txt.background = true;
				ver_txt.selectable = false;
				text("Loading assets ...");
				addChild(ver_txt);
				
				loadConfig(configUrl);
				
				onResize();
				stage.addEventListener(Event.RESIZE, onResize);
			}
			else{
				stage.removeEventListener(Event.RESIZE, onResize);
			}
		}
		
		/**
		 * 场景改变时
		 * @param	e
		 */
		private function onResize(e:Event = null):void{
			this.y = stage.stageHeight - this.height;
		}
		
		/**
		 * 加载配置文件
		 */
		private function loadConfig(configUrl:String):void{
			var md:MyData = new MyData();
			md.loadTextData(configUrl, onLoadConfigComplete);
		}
		/**
		 * 配置文件加载完成
		 * @param	e
		 */
		private function onLoadConfigComplete(e:*):void{
			if (e.type == "complete"){
				ConfigData.Data = JSON.parse(e.target.data);
				loadPokerPic(ConfigData.Data.ConfigAir.Template.PicPk);
			}
		}
		
		/**
		 * 加载图片
		 */
		private function loadPokerPic(loadData:Object):void{
			var path:String = loadData.Path;
			var a:Array = loadData.Data;
			var len:int = a.length;
			for (var i:int = 0; i < len; i++ ){
				var req:ObjectRequire = new ObjectRequire();
				req.objUrl = path + a[i].name + ".png";
				req.paramsObj = a[i];
				req.paramsObj.i = i;
				req.paramsObj.len = len;
				req.onInit = onLoadPicComplete;
				req.onError = onError;
				LoadSwfPool.getInstance().requireSWF(req);
			}
		}
		
		/**
		 * 图片加载完成
		 * @param	loader
		 * @param	parm
		 */
		private function onLoadPicComplete(loader:*, parm:Object):void{
			loadIndex++;
			var bmp:Bitmap = loader.content as Bitmap;
			//var bd:BitmapData = bmp.bitmapData;
			var bd:BitmapData = Poker.MinArea(bmp.bitmapData, 0x00000000);
			
			var dataObj:Object = {
				name : parm.name,
				label : parm.label,
				color : parm.color,
				w : bd.width,
				h : bd.height,
				bd : bd
			};
			PicData.Obj[parm.name] = dataObj;
			PicData.Arr.push(PicData.Obj[parm.name]);
			
			text(["Loading Template...", loadIndex+"/"+parm.len].toString());
			//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP,{bmp:new Bitmap(bd)}));
			
			if (loadIndex >= parm.len){
				//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.LOAD_ASSET_COMPLETE, {type:"complete"}));
				loadPokerTypePic(ConfigData.Data.ConfigAir.Type);
			}
		}
		
		/**
		 * 图片加载错误
		 * @param	e
		 * @param	parm
		 */
		private function onError(e:*, parm:Object):void{
			loadIndex++;
			text([e.type, parm.name, loadIndex].toString());
		}
		
		
		
		
		private function loadPokerTypePic(typeData:Object):void{
			var path:String = typeData.Path;
			var a:Array = typeData.Data;
			var len:int = a.length;
			for (var i:int = 0; i < len; i++ ){
				var req:ObjectRequire = new ObjectRequire();
				req.objUrl = path + a[i].name + ".png";
				req.paramsObj = {
					i : i,
					len : len,
					name : a[i].name,
					color: a[i].color
				};
				req.onInit = onLoadPokerTypeComplete;
				req.onError = onError;
				LoadSwfPool.getInstance().requireSWF(req);
			}
		}
		private function onLoadPokerTypeComplete(loader:*, parm:Object):void{
			var bmp:Bitmap = loader.content as Bitmap;
			//var bd:BitmapData = Poker.MinArea(bmp.bitmapData, 0x00000000);
			
			var dataObj:Object = {
				name : parm.name,
				color: parm.color,
				bd : bmp.bitmapData
			};
			if (dataObj.color == "b"){
				PicData.BlackArr.push(dataObj);
			}else{
				PicData.RedArr.push(dataObj);
			}
			text(["Loading Template...", parm.name, parm.i+"/"+parm.len].toString());
			//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP,{bmp:new Bitmap(bd)}));
			
			if (parm.i+1 >= parm.len){
				MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.LOAD_ASSET_COMPLETE, {type:"complete"}));
				text(Poker.VER);
			}
		}
		
		
		
		
		/**
		 * 设置文字
		 * @param	str
		 */
		private function text(str:String):void{
			ver_txt.text = str;
			ver_txt.setTextFormat(tf);
		}
		
		
	}

}