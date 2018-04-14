package sp.cam 
{
	import com.hexagonstar.util.debug.Debug;
	import com.zt.utils.MySprite;
	import com.zt.utils.TimerRun;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.Video;
	
	/**
	 * ...
	 * @author SamZhou
	 */
	public class VideoSp extends MySprite 
	{
		private const SCALE_NUM:Number = 1.5;
		private var v:Video;
		private var cam:Camera;
		private var camData:FormatResultCam;
		private var vWidth:uint;
		private var vHeight:uint;
		private var tr:TimerRun;
		
		public function VideoSp(camData:FormatResultCam, width:uint, height:uint) 
		{
			super();
			this.camData = camData;
			vWidth = width;
			vHeight = height;
		}
		
		
		
		override public function init(b:Boolean):void 
		{
			if (b){
				
				var cw:int = 320 * SCALE_NUM;
				var ch:int = 240 * SCALE_NUM;
				cw = vWidth;
				ch = vHeight;
				initCam(camData, cw, ch);
			}
			else{
				if (tr != null){
					tr.stop();
					tr = null;
				}
			}
		}
		
		
		/**
		 * 视频原始尺寸
		 */
		private function onTime():void{
			v.width = v.videoWidth;
			v.height = v.videoHeight;
		}
		
		/**
		 * 初始化摄像头
		 * @param	camName
		 * @param	camWidth
		 * @param	camHeight
		 */
		private function initCam(camData:FormatResultCam, camWidth:int, camHeight:int):void{
			cam = Camera.getCamera(String(camData.camIndex));
			Debug.traceObj(camData);
			if (cam == null){
				Debug.trace("没有获取到摄像头" + camData.camName);
				return ;
			}
			Debug.trace("初始化CAM"+[camWidth, camHeight]);
			cam.setQuality(0, 100);
			cam.setMode(camWidth, camHeight, 15);
			
			v = new Video(camWidth, camHeight);
			v.smoothing = true;
			v.attachCamera(cam);
			addChild(v);
			
			if (tr != null){
				tr.stop();
				tr = null;
			}
			tr = new TimerRun(onTime);
			tr.start(300, 3);
			
		}
		
		
		
		
		
	}

}