package data 
{
	import com.hexagonstar.util.debug.Debug;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import poker.FormatCompare;
	import poker.FormatResult;
	/**
	 * ...
	 * @author SamZhou
	 */
	public class AreaData 
	{
		
		
		/**
		 * 获取扑克牌区域
		 * @param	sourceBD
		 * @param	offset
		 * @return
		 */
		public static function GetPKArea(sourceBD:BitmapData, offset:Point, matchingData:Object):FormatResult{
			var resultData:FormatResult = new FormatResult();
			var o:Object = matchingData;
			var a:Array = o.arr;
			var t:int = a.length;
			var l:int = 0;
			
			//超出 宽高 直接返回
			if (offset.x + o.w > sourceBD.width || offset.y + o.h > sourceBD.height) return resultData;
			
			//计算 匹配度
			for (var i:int = 0; i < a.length; i+=1 ){
				var p:Point = new Point(a[i].x + offset.x, a[i].y + offset.y);
				if (sourceBD.getPixel(p.x, p.y) == 0xFFFFFF){
					//bd2.setPixel(p.x, p.y, 0x00FF00);
					l++;
				}
			}
			resultData.pct = AreaData.Round(l / t);
			resultData.width = o.w;
			resultData.height = o.h;
			resultData.done = (resultData.pct >= 97);
			return resultData;
		}
		
		
		
		
		
		
		
		
		/**
		 * 获取 数字区域 进行匹配
		 * @param	offset
		 * @return
		 */
		public static function GetPkAreaNum(sourceBD:BitmapData, offset:Point, matchingData:Object, isWrite:Boolean = true):FormatResult{
			var resultData:FormatResult = new FormatResult();
			var o:Object = matchingData;
			var a:Array = o.arr;
			var name:String = o.name;
			var t:int = a.length;
			var l:int = 0;
			
			//超出 宽高 返回假
			if (offset.x + o.w > sourceBD.width || offset.y + o.h > sourceBD.height){
				return resultData;
			}
			
			//计算 匹配度
			sourceBD.lock();
			for (var i:int = 0; i < a.length; i++ ){
				var p:Point = new Point(a[i].x + offset.x, a[i].y + offset.y);
				if (sourceBD.getPixel(p.x, p.y) <= 0x333333){
					if (isWrite){
						sourceBD.setPixel(p.x,  p.y,  0xFFFFFF);
					}
					l++;
				}
			}
			sourceBD.unlock();
			resultData.pct = AreaData.Round(l / t);
			//Debug.trace("计算结果 : " + resultData.pct);
			
			//反相 计算
			if (resultData.pct >= 85){
				var areaReverse:Object = AreaData.GetPkAreaReverseNum(sourceBD, offset, a, o.w, o.h);
				resultData.pctReverse = areaReverse.pct;
				//Debug.trace("反相计算 : " + resultData.pctReverse);
			}
			
			resultData.done = resultData.pct >= 100;
			resultData.name = name;
			resultData.width = o.w;
			resultData.height = o.h;
			return resultData;
		}
		
		
		/**
		 * 反相区域计算
		 * @param	sourceBD
		 * @param	x
		 * @param	y
		 * @param	w
		 * @param	h
		 * @param	key
		 * @return
		 */
		public static function GetPkAreaReverseNum(sourceBD:BitmapData, offset:Point, templateArr:Array, w:int, h:int):FormatResult {
			var resultData:FormatResult = new FormatResult();
			var t:int = w * h;
			var l:int = 0;
			var x:int = offset.x;
			var y:int = offset.y;
			for (var yy:int = y; yy < h+y; yy++ ){
				for (var xx:int = x; xx < w+x; xx++ ){
					if (sourceBD.getPixel(xx+x, yy+y) <= 0x333333){
						l++;
					}
				}
			}
			resultData.pct = AreaData.Round(l / t);
			return resultData;
		}
		
		
		/**
		 * 比较两个数据
		 * @param	data1
		 * @param	data2
		 * @return
		 */
		public static function CompareData(data1:FormatCompare, data2:FormatCompare):FormatResult{
			var result:FormatResult = new FormatResult();
			var len1:int = data1.width * data1.height;
			var len2:int = data2.width * data2.height;
			if (len1 > len2){
				
				//for (var w:int = 0; w < len1; w++ ){
					//
				//}
				
			}
			return result;
		}
		
		
		/**
		 * 保留小数点
		 * @param	n
		 * @param	len
		 * @return
		 */
		public static function Round(n:Number, len:uint = 2):Number{
			var max:String = "1000000000000";
			var nLen:uint = uint(max.substr(0, len+1));
			return Math.round(n * 100 * nLen) / nLen;
		}
		
		
		
		
	}

}
