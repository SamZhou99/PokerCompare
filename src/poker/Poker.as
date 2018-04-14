package poker 
{
	import com.hexagonstar.util.debug.Debug;
	import com.zt.effect.FiterEffect;
	import poker.FormatPkColor;
	import poker.FormatResult;
	import assets.PicData;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author SamZhou
	 */
	public class Poker
	{
		//版本
		public static const VER:String = "ver:1.03";
		//全局阈值
		public static const MT_NUM:int = 165;
		
		
		
		
		
		/**
		 * 查找图片中的 扑克 区域
		 * @param	sourceBD		源图BitmapData
		 * @param	splitXNum	切分块数
		 * @param	splitYNum		切分块数
		 * @return	返回 扑克牌 [BitmapData,BitmapData]
		 */
		public static function FindArea(sourceBD:BitmapData, splitXNum:uint, splitYNum:uint):Array{
			if (sourceBD == null) return null;
			//图片1 阈值
			var temp1:BitmapData = sourceBD.clone();
			FiterEffect.setBmp(temp1, FiterEffect.MatrixThreshold(Poker.MT_NUM));
			//图片2 阈值
			var temp2:BitmapData = sourceBD.clone();
			FiterEffect.setBmp(temp2, FiterEffect.MatrixThreshold(Poker.MT_NUM));
			
			//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {bmp: new Bitmap(sourceBD)}));
			//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {bmp: new Bitmap(temp1)}));
			//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {bmp: new Bitmap(temp2)}));
			
			var currColor:uint = 0xFF00FFF0;									//填充色
			var bmpWidth:uint = temp1.width;									//源图 宽高
			var bmpHeight:uint = temp1.height;
			var minBmpWidth:uint = Math.round(bmpWidth / splitXNum);			//切分 小图宽高
			var minBmpHeight:uint = Math.round(bmpHeight / splitYNum);
			var step:uint = 1;													//小图 距离
			var pkArr:Array = new Array;										//捕获 多少图
			
			//切分 图片
			for (var y:int = 0; y < splitYNum; y++ ){
				for (var x:int = 0; x < splitXNum; x++ ){
					
					if ( x * minBmpWidth+minBmpWidth > bmpWidth) continue;
					if ( y * minBmpHeight+minBmpHeight > bmpHeight) continue;
					
					var minBmpRect:Rectangle = new Rectangle(x * minBmpWidth, y * minBmpHeight, minBmpWidth, minBmpHeight);
					var minBmpD:BitmapData = new BitmapData(minBmpRect.width, minBmpRect.height);
					//从 temp2 获取小图区块
					minBmpD.copyPixels(temp2, minBmpRect, new Point(0, 0));
					
					//var a_bmp:Bitmap = new Bitmap(minBmpD);
					//a_bmp.x = (minBmpWidth + 1) * x;
					//a_bmp.y = (minBmpHeight + 1) * y;
					//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {bmp: a_bmp, x:a_bmp.x, y:a_bmp.y}));
					
					var xxxColor:int = 0xFFFFFF00;
					var xxxWidth:int = minBmpD.getColorBoundsRect(xxxColor, xxxColor, false).width;
					//xxxColor = 0xFFFFFF00;
					//xxxWidth = minBmpD.getColorBoundsRect(0xFFFFFF00, xxxColor, true).width;
					////Debug.trace("xxxWidth:"+[xxxWidth, minBmpWidth]);
					
					//小区块图上找到 白色色块
					if (xxxWidth == 0){
						//算法1 精确慢
						//var fpp:Point = Poker.FindPixelPoint(minBmpD, 0xFFFFFF);
						//var fx:int = x * minBmpWidth + fpp.x;
						//var fy:int = y * minBmpHeight + fpp.y;
						//算法2 一般快
						var fx:int = x * minBmpWidth + int(minBmpWidth / 2);
						var fy:int = y * minBmpHeight + int(minBmpHeight / 2);
						
						
						//temp1 填充自定色
						temp1.floodFill(fx, fy, currColor);
						//temp1 获取自定色区域
						var rect:Rectangle = temp1.getColorBoundsRect(0xFFFFFFFF, currColor, true);
						//从源图中 取出 牌
						var pkBD:BitmapData = new BitmapData(rect.width, rect.height);
						pkBD.copyPixels(sourceBD, rect, new Point());
						
						//Debug.trace("OVER:"+[xxxWidth, minBmpWidth]);
						//continue;
						//temp1.dispose();
						//temp2.dispose();
						//return pkArr.concat();
						
						//如果横着的，改成，竖着的
						if (pkBD.width > pkBD.height){
							pkBD = Poker.SetBmpRotate(pkBD, 90);
						}
						//确认扑克大小比例
						var size:Size = Poker.GetScale(new Size(pkBD.width, pkBD.height));
						if (size.width > 50 && size.height > 70 && size.scaleX == 2 && size.scaleY == 3){
							pkArr.push(SetBmpSize(pkBD, pkBD.width * 1.5, pkBD.height * 1.5, false).clone());//放大点，增加识别率
						}
						pkBD.dispose();
						//temp1 将找到的区域 填充黑色
						temp1.fillRect(rect, 0x006644);
						//temp1 拷贝到 temp2
						temp2 = temp1.clone();
					}
				}
			}
			temp1.dispose();
			temp2.dispose();
			return pkArr.concat();
		}
		
		/**
		 * 查找块数
		 * @param	sourceBD
		 * @param	splitXNum
		 * @param	splitYNum
		 * @param	findColor	黑色0xFF000000
		 * @param	fillColor
		 * @return
		 */
		public static function FindItemCount(sourceBD:BitmapData, findColor:uint = 0xFF000000, fillColor:uint = 0xFFE9E6E0):Array{
			var sourceBmpData:BitmapData = sourceBD.clone();
			const STEP:int = 4;
			var resArr:Array = [];
			for (var y:int = 0; y < sourceBmpData.height; y+=STEP){
				for (var x:int = 0; x < sourceBmpData.width; x += STEP){
					if (sourceBmpData.getPixel(x, y) == 0x000000){
						//找到黑点
						sourceBmpData.floodFill(x, y, fillColor);
						//找到ITEM
						var itemRect:Rectangle = sourceBmpData.getColorBoundsRect(0xFFFFFFFF, fillColor, true);
						var itemBmpData:BitmapData = new BitmapData(itemRect.width, itemRect.height);
						itemBmpData.copyPixels(sourceBD, itemRect, new Point());
						resArr.push(itemBmpData.clone());
						itemBmpData.dispose();
					}
				}
			}
			sourceBmpData.dispose();
			return resArr;
		}
		
		/**
		 * 比较差异
		 * @param	sourceBD		彩色源图
		 * @param	templateBD	模板
		 * @return	
		 */
		public static function Compare(sourceBD:BitmapData, templateBD:BitmapData):FormatResult{
			if (sourceBD == null) return null;
			var res:FormatResult = new FormatResult();
			var sourec:BitmapData = sourceBD.clone();
			var template:BitmapData = templateBD.clone();
			sourec = Poker.SetBmpSize(sourec, template.width+2, template.height+2);//源图 缩放 到 模板大小+2
			
			FiterEffect.setBmp(sourec, FiterEffect.MatrixThreshold(Poker.MT_NUM));//源图 阈值
			FiterEffect.setBmp(template, FiterEffect.MatrixThreshold(Poker.MT_NUM));//模板 阈值
			
			var tempSourec:BitmapData = new BitmapData(sourec.width, sourec.height);//源图 大小
			tempSourec.copyPixels(sourec, new Rectangle(1, 1, sourec.width-2, sourec.height-2), new Point());//剪去边缘一角像素
			tempSourec = Poker.MinArea(tempSourec, 0xFF000000);//得到最小区域
			
			if (!(tempSourec.width == template.width && tempSourec.height == template.height)){
				//如果大小不一样，则缩放到模板大小一样。
				tempSourec = Poker.SetBmpSize(tempSourec, template.width, template.height);
				FiterEffect.setBmp(tempSourec, FiterEffect.MatrixThreshold(Poker.MT_NUM));
			}
			
			var diffBD:Object = tempSourec.compare(template);//比较结果
			
			//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {bmp:new Bitmap(sourec)}));
			//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {bmp:new Bitmap(tempSourec)}));
			//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {bmp:new Bitmap(template)}));
			
			if (!(diffBD is BitmapData)){
				if (diffBD == 0){
					//diffBD 为 0 时，则相似度为100
					res.pct = 100;
				}
				return res;
			}
			
			//统计像素 相似率
			var bd:BitmapData = diffBD as BitmapData;
			var t:int = diffBD.width * diffBD.height;
			var l:int = t;
			for (var y:int = 0; y < diffBD.height; y++ ){
				for (var x:int = 0; x < diffBD.width; x++ ){
					if (diffBD.getPixel32(x, y) > 0){
						l--;
					}
				}
			}
			//Debug.trace("==========空值==========" + diffBD);
			//Debug.trace("=====================");
			//Debug.trace([tempSourec.width, tempSourec.height]);
			//Debug.trace([template.width, template.height]);
			//Debug.trace("=====================");
			//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {bmp:new Bitmap(diffBD as BitmapData)}));
			//Debug.trace(["===>", "相似度:"+pct+"%", tempSourec.width, tempSourec.height, template.width, template.height].toString());
			var pct:Number = Math.round( l / t * 100000) / 1000;
			res.pct = pct;
			res.bd = bd;
			res.width = bd.width;
			res.height = bd.height;
			res.des = l +"/" + t;
			return res;
		}
		
		/**
		 * 匹配点的个数
		 * @param	sourceBD
		 * @param	colorName
		 * @return
		 */
		public static function CompareBox(sourceBD:BitmapData, colorName:String = "red"):FormatResult{
			if (sourceBD == null) return null;
			const IsDebug:Boolean = false;
			
			var res:FormatResult = new FormatResult();
			var sourec:BitmapData = sourceBD.clone();
			var sourecScale:int = 100;
			sourec = Poker.SetBmpSize(sourec, sourecScale, sourecScale);//源图 缩放 到 模板大小+2
			
			FiterEffect.setBmp(sourec, FiterEffect.MatrixThreshold(Poker.MT_NUM));//源图 阈值
			
			var trimNumX:int = sourec.width/3;
			var trimNumY:int = sourec.height/10;
			var tempSourec:BitmapData = new BitmapData(sourec.width, sourec.height);//源图 大小
			tempSourec.copyPixels(sourec, new Rectangle(trimNumX / 2, trimNumY / 2, sourec.width - trimNumX, sourec.height - trimNumY), new Point());//剪去边缘一角像素
			tempSourec = Poker.MinArea(tempSourec, 0xFF000000);//得到最小区域
			
			var resArr:Array = new Array();
			resArr = Poker.FindItemCount(tempSourec, 0xFF000000, 0xFF993322);
			
			var tempBmp:Bitmap = new Bitmap(tempSourec);
			//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {bmp:tempBmp}));
			
			//获取百分比
			function getComparePct(templateType:BitmapData, templateSourec:BitmapData):Number{
				//统计像素 相似率
				var _templateType:BitmapData = templateType;
				_templateType = Poker.SetBmpSize(_templateType, 80*4, 60*4, true);
				var _templateSourec:BitmapData = Poker.SetBmpSize(templateSourec, _templateType.width, _templateType.height);
				FiterEffect.setBmp(_templateSourec, FiterEffect.MatrixThreshold(Poker.MT_NUM));
				var diffBD:BitmapData = _templateType.compare(_templateSourec) as BitmapData;//比较结果
				if (diffBD == null){
					return 100;
				}
				
				if (IsDebug){
					MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {bmp:new Bitmap(_templateType)}));
					MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {bmp:new Bitmap(_templateSourec)}));
					MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {bmp:new Bitmap(diffBD)}));
				}
				
				var t:int = diffBD.width * diffBD.height;
				var l:int = t;
				for (var y:int = 0; y < diffBD.height; y++ ){
					for (var x:int = 0; x < diffBD.width; x++ ){
						if (diffBD.getPixel32(x, y) > 0){
							l--;
						}
					}
				}
				return Math.round( l / t * 100000) / 1000;
			}
			
			//统计像素 相似率
			if (colorName == "red"){
				var pct1:Number = getComparePct(PicData.RedArr[0].bd, resArr[0]);
				var pct2:Number = getComparePct(PicData.RedArr[1].bd, resArr[0]);
				if (pct1 > pct2){
					res.pct = pct1;
					res.name = "b" + resArr.length;
				}
				else{
					res.pct = pct2;
					res.name = "d" + resArr.length;
				}
				if (IsDebug) Debug.trace(["B:" + pct1, "D:" + pct2].toString());
			}else if (colorName == "black"){
				var pct3:Number = getComparePct(PicData.BlackArr[0].bd, resArr[0]);
				var pct4:Number = getComparePct(PicData.BlackArr[1].bd, resArr[0]);
				if (pct3 > pct4){
					res.pct = pct3;
					res.name = "a" + resArr.length;
				}
				else{
					res.pct = pct4;
					res.name = "c" + resArr.length;
				}
				if (IsDebug) Debug.trace(["pct3-4:" + res.name, "桃" + pct3, "梅" + pct4].toString());
				if (IsDebug) Debug.trace(["A:" + pct3, "C:" + pct4].toString());
			}
			return res;
		}
		
		
		/**
		 * 获取图片 颜色 最小区域
		 * @param	sourecBD
		 * @param	currColor
		 * @return
		 */
		public static function MinArea(sourceBD:BitmapData, currColor:uint):BitmapData{
			if (sourceBD == null) return null;
			var source:BitmapData = sourceBD.clone();
			FiterEffect.setBmp(source, FiterEffect.MatrixThreshold(Poker.MT_NUM));
			var rect:Rectangle = source.getColorBoundsRect(0xFFFFFFFF, 0xFF000000, true);
			//Debug.trace([rect.width, rect.height]);
			var pkBD:BitmapData = new BitmapData(rect.width, rect.height, false, 0xFF0000);
			pkBD.copyPixels(source, rect, new Point());
			return pkBD.clone();
		}
		
		/**
		 * 查询像素点
		 * @param	sourceBD
		 * @param	currColor
		 * @return
		 */
		public static function FindPixelPoint(sourceBD:BitmapData, currColor:uint = 0x111111):Point{
			var s:String = "";
			for (var ty:int = 0; ty < sourceBD.height; ty++ ){
				s += "\n";
				for (var tx:int = 0; tx < sourceBD.width; tx++ ){
					var b:uint = sourceBD.getPixel(tx, ty);
					s += b.toString(16)+",";
					if (b == currColor){
						return new Point(tx, ty);
					}
				}
			}
			Debug.trace(s);
			return new Point(1,1);
		}
		
		/**
		 * 获取扑克数
		 * @param	sourceBD	需要匹配的BitmapData
		 * @param	templateArr	模板数据
		 * @return
		 */
		public static function GetNum(sourceBD:BitmapData, templateArr:Array):FormatResult{
			if (sourceBD == null) return resObj;
			var resObj:FormatResult = new FormatResult;
			var sourceBmpData:BitmapData = sourceBD.clone();
			var currTemplateArr:Array = templateArr.concat();
			var i:int;
			//牌缩小
			var sizeBD:BitmapData = Poker.SetBmpSize(sourceBmpData, 30, 30);
			//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {
				//bmp:new Bitmap(sizeBD)
			//}));
			//减少范围
			var area:int = 5;
			var centreBD:BitmapData = new BitmapData(sizeBD.width-area*2, sizeBD.height-area*2);
			centreBD.copyPixels(sizeBD, new Rectangle(area, area, centreBD.width, centreBD.height), new Point());
			//FiterEffect.setBmp(centreBD, FiterEffect.MatrixThreshold(Poker.MT_NUM));//源图 阈值
			//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.SHOW_BMP, {
				//bmp:new Bitmap(centreBD)
			//}));
			
			//取色占比
			var resColor:FormatPkColor = Poker.GetColorHoldPct(centreBD);
			//Debug.trace("取色占比");
			//Debug.traceObj(resColor);
			//花牌
			if (resColor.isFlowers){
				currTemplateArr = [];
				for (i = 0; i < templateArr.length; i++ ){
					if (templateArr[i].color.indexOf("f") != -1){
						currTemplateArr.push(templateArr[i]);
					}
				}
				return Poker.GetFlowersNum(sourceBmpData, currTemplateArr);
			}
			//黑牌
			else if (resColor.isBlack){
				currTemplateArr = [];
				for (i = 0; i < templateArr.length; i++ ){
					if(templateArr[i].color == "b") currTemplateArr.push(templateArr[i]);
				}
				return Poker.GetBlackNum(sourceBmpData, currTemplateArr, true);
			}
			//红牌
			else if (resColor.isRed){
				currTemplateArr = [];
				for (i = 0; i < templateArr.length; i++ ){
					if(templateArr[i].color == "r") currTemplateArr.push(templateArr[i]);
				}
				return Poker.GetRedNum(sourceBmpData, currTemplateArr, true);
			}
			return null;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 获取花牌值
		 * @param	templateArr
		 * @return
		 */
		public static function GetFlowersNum(sourceBmpData:BitmapData, templateArr:Array):FormatResult{
			var resObj:FormatResult = new FormatResult();
			var a:Array = templateArr;
			var len:int = a.length;
			for (var i:int = 0; i < len; i++ ){
				var result:FormatResult = Poker.Compare(sourceBmpData, a[i].bd);
				if (result.pct > resObj.pct){
					resObj = result;
					resObj.name = a[i].name;
				}
			}
			//Debug.trace([resObj.name + "," + resObj.pct +"%" ].toString() );
			return resObj;
		}
		/**
		 * 获取黑牌值
		 * @param	templateArr
		 * @return
		 */
		public static function GetBlackNum(sourceBmpData:BitmapData, templateArr:Array, isFindDot:Boolean = false):FormatResult{
			var resObj:FormatResult = new FormatResult();
			if (isFindDot){
				resObj = Poker.CompareBox(sourceBmpData, "black");
				//Debug.trace([resObj.name + "," + resObj.pct +"%" ].toString() );
				return resObj;
			}
			
			var a:Array = templateArr;
			var len:int = a.length;
			for (var i:int = 0; i < len; i++ ){
				var result:FormatResult = Poker.Compare(sourceBmpData, a[i].bd);
				if (result.pct > resObj.pct){
					resObj = result;
					resObj.name = a[i].name;
				}
			}
			//Debug.trace([resObj.name + "," + resObj.pct +"%" ].toString() );
			return resObj;
		}
		/**
		 * 获取红牌值
		 * @param	templateArr
		 * @return
		 */
		public static function GetRedNum(sourceBmpData:BitmapData, templateArr:Array, isFindDot:Boolean = false):FormatResult{
			var resObj:FormatResult = new FormatResult();
			if (isFindDot){
				resObj = Poker.CompareBox(sourceBmpData, "red");
				//Debug.trace([resObj.name + "," + resObj.pct +"%" ].toString() );
				return resObj;
			}
			
			var a:Array = templateArr;
			var len:int = a.length;
			for (var i:int = 0; i < len; i++ ){
				var result:FormatResult = Poker.Compare(sourceBmpData, a[i].bd);
				if (result.pct > resObj.pct){
					resObj = result;
					resObj.name = a[i].name;
				}
			}
			//Debug.trace([resObj.name + "," + resObj.pct +"%" ].toString() );
			return resObj;
		}
		
		
		
		
		/**
		 * 设置bmp data 大小
		 * @param	sourceBD
		 * @param	width
		 * @param	height
		 * @return
		 */
		public static function SetBmpSize(sourceBD:BitmapData, width:uint, height:uint, isSmoothing:Boolean=true):BitmapData{
			if (sourceBD == null) return null;
			var bmp:Bitmap = new Bitmap(sourceBD.clone());
			bmp.smoothing = isSmoothing;
			var mat:Matrix = new Matrix();
			var sx:Number = width / bmp.width;
			var sy:Number = height / bmp.height;
			//Debug.trace([bmp.width, bmp.height, width, height, sx, sy].toString());
			mat.scale(sx, sy);
			var bd:BitmapData = new BitmapData(width, height);
			bd.draw(bmp, mat);
			return bd;
		}
		
		/**
		 * 设置图片旋转角度
		 * @param	sourceBD
		 * @param	rotation
		 * @return
		 */
		public static function SetBmpRotate(sourceBD:BitmapData, rotation:Number):BitmapData{
			if (sourceBD == null) return null;
			var tw:int = sourceBD.width;
			var th:int = sourceBD.height;
			var bmp:Bitmap = new Bitmap(sourceBD.clone());
			bmp.smoothing = true;
			var mat:Matrix = new Matrix();
			mat.rotate(90 * (Math.PI / 180));
			mat.translate(bmp.height, 0);
			var bd:BitmapData = new BitmapData(bmp.height, bmp.width);
			bd.draw(bmp, mat);
			return bd;
		}
		
		/**
		 * 获取 白黑红 部分占多少
		 * @param	sourceBD
		 * @return
		 */
		public static function GetColorHoldPct(sourceBD:BitmapData):FormatPkColor{
			if (sourceBD == null) return null;
			var res:FormatPkColor = new FormatPkColor;
			var total:int = sourceBD.width * sourceBD.height;
			var white:int = 0;
			var black:int = 0;
			var red:int = 0;
			for (var xx:int = 0; xx < sourceBD.width; xx++ ){
				for (var yy:int = 0; yy < sourceBD.height; yy++ ){
					
					var color:uint = sourceBD.getPixel(xx, yy);
					var r:uint = (color >> 16) & 0xFF;
					var g:uint = (color >> 8) & 0xFF;
					var b:uint = (color) & 0xFF;
					
					if (color > 0xEEEEEE){
						white++;
					}else if (color < 0x333333){
						black++;
					}else if (r > 100 && g < 60 && b <60){
						red++;
					}
					
				}
			}
			
			res.white = int(white / total * 10000) / 100;
			res.black = int(black / total * 10000) / 100;
			res.red = int(red / total * 10000) / 100;
			res.isFlowers = (res.white < 40 && res.black > 0 && res.red > 0) ? true : false;
			res.isBlack = (!res.isFlowers && res.black > 0) ? true : false;
			res.isRed = (!res.isFlowers && !res.isBlack && res.red > 0) ? true : false;
			
			//测试结果
			//牌色：,白91,黑6,红2
			//牌色：,白80,黑0,红20
			//牌色：,白21,黑18,红21
			//MainEvent.DIS.dispatchEvent(new MainEvent(MainEvent.OUT_TEXT_EVENT, {text:["牌色：", "白"+resColor.white, "黑"+resColor.black, "红"+resColor.red].toString()}));
			
			return res;
		}
		
		/**
		 * 最大公约数 算扑克牌比例
		 * @param	size
		 * @return
		 */
		private static function GetScale(size:Size):Size{
			var n1:Number, n2:Number, n3:Number;
			if (size.width > size.height){
				n1 = size.width;
				n2 = size.height;
			}else{
				n1 = size.height;
				n2 = size.width;
			}
			n3 = n1 % n2;
			size.scaleX = size.width / n3;
			size.scaleY = size.height / n3;
			return size;
		}
		
		
		
		
	}

}

class Size{
	public var width:uint;
	public var height:uint;
	public var scaleX:uint;
	public var scaleY:uint;
	public function Size(width:uint, height:uint)
	{
		this.width = width;
		this.height = height;
	}
}