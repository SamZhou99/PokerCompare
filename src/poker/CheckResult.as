package poker 
{
	import com.hexagonstar.util.debug.Debug;
	/**
	 * ...
	 * @author SamZhou
	 */
	public class CheckResult 
	{
		public static const IsDebug:Boolean = false;
		
		public function CheckResult() 
		{
			
		}
		
		
		/**
		 * 开始检查结果
		 * @param	dataObj
		 * @return
		 */
		public static function Check(resultObj:Object):FormatCheckResult{
			function getNum(s:String):int
			{
				if (s == null) return NaN;
				if (s.indexOf("=") != -1){
					s = s.split("=")[0];
				}
				var n:int = int(s.substring(1, s.length));
				if (n >= 10) n = 0;
				return n;
			}
			
			
			if (resultObj == null) return FormatCheckResult.IsNull;
			//必须大于等于四张牌
			if (resultObj.banker == undefined || resultObj.player == undefined) return FormatCheckResult.IsUndefined;
			if (resultObj.banker.length < 2 || resultObj.player.length < 2) return FormatCheckResult.IsNotEnough;
			
			
			
			//共6张牌，结束
			if (resultObj.banker.length >= 3 && resultObj.player.length >= 3) return FormatCheckResult.IsOK;
			
			
			
			//共5张牌			
			//庄有3张牌，结束
			if (resultObj.banker.length >= 3) return FormatCheckResult.IsOK;
			
			
			var playerNum:int = (getNum(resultObj.player[0]) + getNum(resultObj.player[1])) % 10;
			var isPlayerBP:Boolean = resultObj.player.length >= 3;
			var playerBP:int = isPlayerBP ? getNum(resultObj.player[2]) : -99;
			
			var bankerNum:int = (getNum(resultObj.banker[0]) + getNum(resultObj.banker[1])) % 10;
			var isBankerBP:Boolean = resultObj.banker.length >= 3;
			var bankerBP:int = isBankerBP ? getNum(resultObj.banker[2]) : -99;
			
			if (CheckResult.IsDebug){
				Debug.trace("::::::::::::::::::::::::::::::::::::::::::::");
				Debug.trace(["player", playerNum, playerBP, resultObj.player.toString()].toString());
				Debug.trace(["banker", bankerNum, bankerBP, resultObj.banker.toString()].toString());
			}
			
			//闲有3张，补到牌N
			if (isPlayerBP){
				//庄6点，闲补到6,7，庄必补
				if (bankerNum == 6 && (playerBP==6 || playerBP==7) ){
					return FormatCheckResult.IsSupplementary10;
				}
				
				//庄5点，闲补到123890，庄不补，结束
				if (bankerNum == 5 && (playerBP == 1 || playerBP == 2 || playerBP == 3 || playerBP == 8 || playerBP == 9 || playerBP == 0) ){
					return FormatCheckResult.IsOK;
				}
				
				//庄4点，闲补到1890，庄不补，结束
				if (bankerNum == 4 && (playerBP == 1 || playerBP == 8 || playerBP == 9 || playerBP == 0) ){
					return FormatCheckResult.IsOK;
				}
				
				//庄3点，闲补到8，庄不补，结束
				if (bankerNum == 3 && playerBP == 8 ){
					return FormatCheckResult.IsOK;
				}
				
				//庄0,1,2，必补
				if (bankerNum < 3) return FormatCheckResult.IsSupplementary11;
				
				
				
				//闲6点
				if (playerNum == 6){
					//，补到6,7，庄要补
					if (playerBP == 6 || playerBP == 7){
						return FormatCheckResult.IsOK;
					}
					else{
						return FormatCheckResult.IsSupplementary20;
					}
				}
				//闲5点
				if (playerNum == 5){
					
				}
				
				return FormatCheckResult.IsOK;
			}
			
			
			
			//4张牌
			
			//庄或闲 89，结束
			if (playerNum >= 8 || bankerNum >= 8) return FormatCheckResult.IsOK;
			
			//庄7，闲6，结束
			if (bankerNum == 7 && playerNum == 6) return FormatCheckResult.IsOK;
			
			//闲7，庄6,7，庄不补，结束
			if (playerNum == 7 && (bankerNum == 6 || bankerNum == 7)) return FormatCheckResult.IsOK;
			
			//庄闲都是6和，结束
			if (playerNum == 6 && bankerNum == 6) return FormatCheckResult.IsOK;
			
			//闲6，庄0-5，庄必补
			if (playerNum >= 6 && bankerNum < 6) return FormatCheckResult.IsSupplementary21;
			
			//闲家小于6，必补
			if (playerNum < 6) return FormatCheckResult.IsSupplementary22;
			
			//庄小于3，必补
			if (bankerNum < 3) return FormatCheckResult.IsSupplementary12;
			
			return FormatCheckResult.IsOther;
		}
		
		
		
		
		
	}

}

