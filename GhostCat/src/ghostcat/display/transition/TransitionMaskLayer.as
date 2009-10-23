package ghostcat.display.transition
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.display.movieclip.GMovieClipBase;
	import ghostcat.events.MovieEvent;
	import ghostcat.operation.DelayOper;
	import ghostcat.operation.FunctionOper;
	import ghostcat.operation.MovieOper;
	import ghostcat.operation.Oper;
	import ghostcat.operation.TweenOper;
	import ghostcat.util.core.Handler;
	
	import mx.core.MovieClipLoaderAsset;
	
	import org.gameui.events.MovieEvent;

	/**
	 * 显示一个动画对象作为Mask的过渡
	 * 
	 * 当设置了wait属性后，将会暂停，此时只能用continueFadeOut方法继续
	 *
	 * @author flashyiyi
	 * 
	 */
	public class TransitionMaskLayer extends TransitionLayer
	{
		/**
		 * 缓存对象
		 */
		public var bitmap:Bitmap;
		
		/**
		 * Mask动画
		 */
		public var maskMovieClip:GMovieClip;
		
		private var displayObj:Sprite;
		
		
		/** @inheritDoc*/
		public override function createTo(container:DisplayObjectContainer):TransitionLayer
		{
			displayObj = new Sprite();
			displayObj.addChild(bitmap);
			
			container.addChild(displayObj);
			
			return super.createTo(container);
		}
		
		public function TransitionMaskLayer(switchHandler:Handler,maskMovieClip:GMovieClipBase,maskLabel:String = null, fadeOut:int = 1000, wait:Boolean=false)
		{
			var bitmap:Bitmap = new DrawParse(target).createBitmap();
			
			var fadeOutOper:Oper;
			var waitOper:Oper;
			
			this.maskMovieClip = maskMovieClip;
			
			if (fadeOut)
				fadeOutOper = new MovieOper(maskMovieClip,maskLabel);
			if (wait)
				waitOper = new DelayOper(-1);
			
			super(switchHandler,null,fadeOutOper,waitOper);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (bitmap)
			{
				bitmap.parent.removeChild(bitmap);
				bitmap.bitmapData.dispose();
			}
			
			if (displayObj)
				displayObj.parent.removeChild(displayObj);
			
			super.destory();
		}
	}
}