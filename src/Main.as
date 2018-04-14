package
{
	import assets.LoadAssets;
	import com.hexagonstar.util.debug.Debug;
	import com.zt.utils.Format;
	import com.zt.utils.MySprite;
	import controllers.ButtonController;
	import assets.ConfigData;
	import poker.FormatResult;
	import assets.PicData;
	import data.ws.AirSocketServer;
	import data.ws.AirWS;
	import fl.managers.StyleManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextFormat;
	import poker.CheckResult;
	import poker.FormatCheckResult;
	import poker.Poker;
	import sp.cam.CamVideo;
	import sp.cam.ImageSocketSp;
	
	/**
	 * ...
	 * @author SamZhou
	 */
	public class Main extends MySprite
	{
		private const CONFIG_URL:String = "./config.json";
		private var loadAssets:LoadAssets;
		private var controll:ButtonController;
		private var imgSk:ImageSocketSp;		
		private var ws:AirWS;
		private var imgServer:AirSocketServer;
		private var currResult:String;
		
		public function Main()
		{
			super();
		}
		
		override public function init(b:Boolean):void
		{
			if (b)
			{
				StyleManager.setStyle("textFormat", new TextFormat("Courier New, 微软雅黑", 14, 0x556633, true));
				
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				
				loadAssets = new LoadAssets(CONFIG_URL);
				addChild(loadAssets);
				
				MainEvent.DIS.addEventListener(MainEvent.SCREENSHOT_MATCHING_EVENT, onSCREENSHOT_MATCHING_EVENT);
				MainEvent.DIS.addEventListener(MainEvent.LOAD_ASSET_COMPLETE, onLOAD_ASSET_COMPLETE);
			}
			else
			{
				MainEvent.DIS.removeEventListener(MainEvent.SCREENSHOT_MATCHING_EVENT, onSCREENSHOT_MATCHING_EVENT);
				MainEvent.DIS.removeEventListener(MainEvent.LOAD_ASSET_COMPLETE, onLOAD_ASSET_COMPLETE);
			}
		}
		
		/**
		 * 资源加载完成
		 * @param	e
		 */
		private function onLOAD_ASSET_COMPLETE(e:MainEvent):void
		{
			if (e.parms.type == "complete")
			{
				//初始化ws
				ws = new AirWS(ConfigData.Data.ConfigAir.WebSocketServer.Port);
				ws.initServer();
				//截屏图片服务
				imgServer = new AirSocketServer(ConfigData.Data.ConfigAir.SocketServer.IP, ConfigData.Data.ConfigAir.SocketServer.Port);
				imgServer.initServer();
				//初始化UI
				initUI();
				MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.OUT_TEXT_EVENT, {text: ["WebSocket Port:" + ConfigData.Data.ConfigAir.WebSocketServer.Port].toString()}));
			}
		}
		
		/**
		 * 初始化UI
		 */
		private function initUI():void
		{
			var scaleNum:Number = 3;
			
			//扑克			
			//ImageSocket
			imgSk = new ImageSocketSp(160 * scaleNum, 120 * scaleNum);
			imgSk.callback = onScreenCaptureReady;
			addChild(imgSk);
			MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.OUT_TEXT_EVENT, {text: ["Cam:", imgSk.width, imgSk.height].toString()}));
			
			controll = new ButtonController;
			controll.y = stage.stageHeight - controll.height;
			addChildAt(controll, 0);
		}
		
		/**
		 * 屏幕截图 准备好
		 */
		private function onScreenCaptureReady():void
		{
			controll.setEnaled(true);
		}
		
		/**
		 * 截图匹配
		 * @param	e
		 */
		private function onSCREENSHOT_MATCHING_EVENT(e:MainEvent):void
		{
			MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.CLEAR_BMP, {}));
			
			var startTime:Date = new Date();
			var pkRes:Array = calculatorBanker();
			var pkRes2:Array = calculatorPlayer();
			var endTime:Date = new Date();
			var difTime:int = endTime.getTime() - startTime.getTime();
			
			//发送WS消息
			var dataObj:Object = {banker: pkRes, player: pkRes2};
			
			//不应该与上一次结果一样
			if (currResult != null && currResult == dataObj.banker.toString() + dataObj.player.toString()) return;
			
			//应该什么时候发送结果
			//Debug.traceObj(dataObj);
			var checkRes:FormatCheckResult = CheckResult.Check(dataObj);
			Debug.trace([checkRes.code, checkRes.label].toString());
			if (checkRes.code != -1) return;
			
			MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.OUT_TEXT_EVENT, {text: ["\n时间：" + Format.GetFormatTime(new Date()) + "（" + difTime+"毫秒）" ].toString()}));;
			MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.OUT_TEXT_EVENT, {text: "<font color='#FF0000'>"+["Banker：" + getHieroglyphs(pkRes.toString()), "\tResult：" + getTotalNum(pkRes) ].toString()+"</font>"}));
			MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.OUT_TEXT_EVENT, {text: "<font color='#0033FF'>"+["Player：" + getHieroglyphs(pkRes2.toString()), "\tResult：" + getTotalNum(pkRes2) ].toString()+"</font>"}));
			
			var jsonMsg:String = JSON.stringify(dataObj);
			//Debug.trace(jsonMsg);
			ws.sendMsg(jsonMsg);
			currResult = dataObj.banker.toString() + dataObj.player.toString();
		}
		
		/**
		 * 计算 庄家
		 */
		private function calculatorBanker():Array{
			try{
				var pkArr:Array = Poker.FindArea(imgSk.getLeftAreaBD(), ConfigData.Data.ConfigAir.ImgSplit.CountX, ConfigData.Data.ConfigAir.ImgSplit.CountY);
			}catch (e:*){
				Debug.trace("Left:"+e.toString());
				return null;
			}
			var pkRes:Array = [];
			for (var i:int = 0; i < pkArr.length; i++)
			{
				var tmp1:FormatResult = Poker.GetNum(pkArr[i], PicData.Arr);
				//pkRes.push(tmp1.name + "=" + tmp1.pct + "%");
				pkRes.push(tmp1.name);
				MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {bmp: new Bitmap(pkArr[i])}));
			}
			return pkRes;
		}
		
		/**
		 * 计算 闲家
		 */
		private function calculatorPlayer():Array{
			try{
				var pkArr2:Array = Poker.FindArea(imgSk.getRightAreaBD(), ConfigData.Data.ConfigAir.ImgSplit.CountX, ConfigData.Data.ConfigAir.ImgSplit.CountY);
			}catch (e:*){
				Debug.trace("Right:"+e.toString());
				return null;
			}
			var pkRes2:Array = [];
			for (var i2:int = 0; i2 < pkArr2.length; i2++)
			{
				var tmp2:FormatResult = Poker.GetNum(pkArr2[i2], PicData.Arr);
				//pkRes2.push(tmp2.name + "=" + tmp2.pct + "%");
				pkRes2.push(tmp2.name);
				MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {bmp: new Bitmap(pkArr2[i2])}));
			}
			return pkRes2;
		}
		
		
		/**
		 * 获取扑克数值
		 * @param	s
		 * @return
		 */
		private function getNum(s:String):int
		{
			if (s == null) return NaN;
			
			var n:int = int(s.substring(1, s.length));
			if (n >= 10) n = 0;
			return n;
		}
		
		/**
		 * 获取牌总值
		 * @return
		 */
		private function getTotalNum(res:Array):int{
			var total:int = 0;
			var a:Array = res;
			for (var i:int = 0; i < a.length; i++ ){
				total += getNum(String(a[i]).split("=")[0]);
			}
			return total % 10;
		}
		
		/**
		 * 将abcd转为♠♥♣♦
		 * @param	txt
		 * @return
		 */
		private function getHieroglyphs(txt:String):String{
			txt = txt.toLocaleLowerCase().replace(new RegExp("a", "g"), PicData.BlackArr[0].name);
			txt = txt.toLocaleLowerCase().replace(new RegExp("b", "g"), PicData.RedArr[0].name);
			txt = txt.toLocaleLowerCase().replace(new RegExp("c", "g"), PicData.BlackArr[1].name);
			txt = txt.toLocaleLowerCase().replace(new RegExp("d", "g"), PicData.RedArr[1].name);
			return txt;
		}
	
	}

}