package poker 
{
	/**
	 * ...
	 * @author SamZhou
	 */
	public class FormatCheckResult 
	{
		public static const IsNull:FormatCheckResult = new FormatCheckResult(101, "数据为NULL");
		public static const IsUndefined:FormatCheckResult = new FormatCheckResult(102, "庄或闲 数据不正确");
		public static const IsNotEnough:FormatCheckResult = new FormatCheckResult(103, "还不够四张牌");
		public static const IsOther:FormatCheckResult = new FormatCheckResult(200, "其他情况");
		
		public static const IsSupplementary10:FormatCheckResult = new FormatCheckResult(11, "庄6点，闲补到6,7，庄必补");
		public static const IsSupplementary11:FormatCheckResult = new FormatCheckResult(12, "庄0,1,2，必补");
		public static const IsSupplementary12:FormatCheckResult = new FormatCheckResult(13, "庄小于3，必补");
		public static const IsSupplementary20:FormatCheckResult = new FormatCheckResult(20, "闲6点，补到6,7，庄要补");
		public static const IsSupplementary21:FormatCheckResult = new FormatCheckResult(21, "闲6，庄0-5，庄必补");
		public static const IsSupplementary22:FormatCheckResult = new FormatCheckResult(22, "闲家小于6，必补");
		
		public static const IsOK:FormatCheckResult = new FormatCheckResult(-1, "通过");
		
		public var code:int;		//结果码
		public var label:String;	//说明
		
		public function FormatCheckResult(code:int, label:String) 
		{
			this.code = code;
			this.label = label;
		}
		
	}

}