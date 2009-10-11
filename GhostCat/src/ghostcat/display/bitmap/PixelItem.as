package ghostcat.display.bitmap
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * 像素对象
	 * @author flashyiyi
	 * 
	 */
	public class PixelItem implements IBitmapDataDrawer
	{
		public var x:Number;
		public var y:Number;
		public var color:uint;
		
		public function PixelItem(x:Number,y:Number,color:uint)
		{
			this.x = x;
			this.y = y;
			this.color = color;
		}
		
		/** @inheritDoc*/
		public function drawBitmapData(bitmapData:BitmapData):void
		{
			bitmapData.setPixel32(x,y,color);
		}
	}
}