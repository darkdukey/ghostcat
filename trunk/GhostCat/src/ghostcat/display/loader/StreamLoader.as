package ghostcat.display.loader
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	import ghostcat.display.GSprite;
	
	/**
	 * 渐进式加载图片
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class StreamLoader extends GSprite
	{
		/**
		 * 载入完毕
		 */
		public var loadComplete:Boolean = false;
		
		private var stream:URLStream;
		
		public function StreamLoader(request:URLRequest = null)
		{
			super(new Loader());
			
			stream = new URLStream();
			stream.addEventListener(ProgressEvent.PROGRESS,refreshProgress);
			stream.addEventListener(Event.COMPLETE,completeHandler);
			
			if (request)
				load(request);
		}
		/** @inheritDoc*/
		public override function get content():DisplayObject
		{
			return (content as Loader).content;
		}
		
		public function load(request:URLRequest):void
		{
			loadComplete = false;
			stream.load(request);
		}
		
		/**
		 * 获得加载器 
		 * @return 
		 * 
		 */
		public function get eventDispatcher():EventDispatcher
		{
			return stream;
		}
		
		private function refreshProgress(event:Event):void
		{
			var loader:Loader = content as Loader;
			var bytes:ByteArray;
			stream.readBytes(bytes,0,stream.bytesAvailable);
			bytes.position = 0;
			loader.loadBytes(bytes);
		}
		
		private function completeHandler(event:Event):void
		{
			refreshProgress(event);
			loadComplete = true;
			stream.close();
		}
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			stream.removeEventListener(ProgressEvent.PROGRESS,refreshProgress);
			stream.removeEventListener(Event.COMPLETE,refreshProgress);
			stream.close();
			
			super.destory();
		}
	}
}