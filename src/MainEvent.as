package 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author SamZhou
	 */
	public class MainEvent extends Event 
	{
		public static const DIS:EventDispatcher = new EventDispatcher();
		
		public static const ERROR_TEXT:String = "error_text";
		public static const SELECT_CAMERA:String = "select_camera";
		public static const READY_CAMERA:String = "ready_camera";
		public static const LOAD_ASSET_COMPLETE:String = "load_asset_complete";
		
		public static const CLEAR_BMP:String = "clear_bmp";
		public static const SHOW_BMP:String = "show_bmp";
		
		//准备就绪
		public static const READY_EVENT:String = "ready_event";
		//截图 并 匹配结果
		public static const SCREENSHOT_MATCHING_EVENT:String = "screenshot_matching_event";
		//定义 左边区域
		public static const AREA_LEFT_EVENT:String = "area_left_event";
		//定义 右边区域
		public static const AREA_RIGHT_EVENT:String = "area_right_event";
		//输出文字
		public static const OUT_TEXT_EVENT:String = "out_text_event";
		
		//Socket图片
		public static const SOCKET_IMG_EVENT:String = "socket_img_event";
		
		
		//参数
		public var parms:Object;
		public function MainEvent(type:String, parms:Object) 
		{
			super(type);
			this.parms = parms;
		}
		
	}

}