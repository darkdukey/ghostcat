package ghostcat.display.viewport
{
    import flash.display.*;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import ghostcat.display.GNoScale;
    import ghostcat.events.TickEvent;
    import ghostcat.parse.display.DrawParse;
    import ghostcat.util.display.DisplayUtil;

	/**
	 * 错位分层并自动Tile内容，实时更新，适用于无差异的循环背景
	 *  
	 * @author flashyiyi
	 * 
	 */
    public class BackgroundLayer extends GNoScale
	{
        private var items:Array = [];
		
		private var _width:Number;
		private var _height:Number;
		
		private var _positionX:Number = 0;
		private var _positionY:Number = 0;

		/**
		 * 是否激活X轴的复制
		 */
		public var enabledTileX:Boolean;
		
		/**
		 * 是否激活Y轴的复制
		 */
		public var enabledTileY:Boolean;
		
		private var _autoMove:Point;
		
        public function BackgroundLayer(width:Number,height:Number,enabledTileX:Boolean = true,enabledTileY:Boolean = true)
		{
			this.setSize(width,height);
			
			this.enabledTileX = enabledTileX;
			this.enabledTileY = enabledTileY;
        }

		/**
		 * 自动移动
		 */
		public function get autoMove():Point
		{
			return _autoMove;
		}

		public function set autoMove(value:Point):void
		{
			_autoMove = value;
			enabledTick = (value != null);
		}
		
		/** @inheritDoc*/
		protected override function tickHandler(event:TickEvent) : void
		{
			if (_autoMove)
			{
				contentX += _autoMove.x * event.interval / 1000;
				contentY += _autoMove.y * event.interval / 1000;
			}
		}

		/**
		 * 内部坐标x
		 * @return 
		 * 
		 */
		public function get contentX():Number
		{
			return _positionX;
		}
		
		public function set contentX(value:Number):void
		{
			_positionX = value;
			for (var i:int = 0;i < items.length;i++)
			{
				var item:Item = items[i] as Item;
				if (this.enabledTileX)
					item.layer.x = (value * item.divider) % item.contentSize.x - item.contentSize.x;
				else
					item.layer.x = value;
			};
		}
		
		/**
		 * 内部坐标y 
		 * @return 
		 * 
		 */
		public function get contentY():Number
		{
			return _positionY;
		}
		
		public function set contentY(value:Number):void
		{
			_positionY = value;
			for (var i:int = 0;i < items.length;i++)
			{
				var item:Item = items[i] as Item;
				if (this.enabledTileY)
					item.layer.y = (value / item.divider) % item.contentSize.y - item.contentSize.y;
				else
					item.layer.y = value;
			};
		}
		/** @inheritDoc*/
		protected override function updateSize() : void
		{
			super.updateSize();
			
			for each (var i:Item in items)
				render(i);
		}
		
		/**
		 * 添加层
		 * 
		 * @param skin	皮肤
		 * @param offest	坐标偏移量
		 * @param divider	移动速度比
		 * @param asBitmap	是否缓存为位图
		 * 
		 */
		public function addLayer(skin:Class, divider:Number = 1.0,offest:Point = null,asBitmap:Boolean = false):void
		{
			if (!offest)
				offest = new Point();
			
			var layer:Sprite = new Sprite();
            var child:DisplayObject = new skin() as DisplayObject;
			var contentSize:Point = new Point(child.width,child.height);
			var item:Item = new Item(skin,layer,contentSize,offest,divider,asBitmap);
			items.push(item);
			addChild(layer);
			
			render(item);
		};
		
		/**
		 * 渲染
		 * @param item
		 * 
		 */
		protected function render(item:Item):void
		{
			var lw:int = Math.ceil(width / item.contentSize.x) + 1;
			var lh:int = Math.ceil(height / item.contentSize.y) + 1;
			
			if (!enabledTileX)
				lw = 1;
			if (!enabledTileY)
				lh = 1;
			
			if (item.asBitmap)
			{
				if (item.bitmapData)
					item.bitmapData.dispose();
				
				var child:DisplayObject = new (item.skin)() as DisplayObject;
				var drawPos:Point = child.getBounds(child).topLeft.add(item.offest);
				item.bitmapData = new DrawParse(child).createBitmapData();
				var m:Matrix = new Matrix();
				m.translate(drawPos.x,drawPos.y);
				item.layer.graphics.beginBitmapFill(item.bitmapData,m);
				item.layer.graphics.drawRect(drawPos.x,drawPos.y,child.width * lw,child.height * lh);
				item.layer.graphics.endFill();
			}
			else
			{
				DisplayUtil.removeAllChildren(item.layer);
				for (var j:int = 0;j < lh;j++)
				{
					for (var i:int = 0;i < lw;i++)
					{
						child = new (item.skin)() as DisplayObject;
						child.x = i * child.width + item.offest.x;
						child.y = j * child.height + item.offest.y;
						item.layer.addChild(child);
					}
				}
			}
        }
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			for each (var i:Item in items)
			{
				if (i.bitmapData)
					i.bitmapData.dispose();
			}
			super.destory();
		}

    }
}
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;

class Item
{
	/**
	 * 皮肤类型
	 */
	public var skin:Class
	/**
	 * 层实例
	 */
	public var layer:Sprite;
	/**
	 * 皮肤大小
	 */
	public var contentSize:Point;
	/**
	 * 坐标偏移量
	 */
	public var offest:Point;
	/**
	 * 移动倍率
	 */
	public var divider:Number;
	/**
	 * 是否缓存为位图 
	 */
	public var asBitmap:Boolean;
	/**
	 * 缓存的位图
	 */
	public var bitmapData:BitmapData;
	public function Item(skin:Class,layer:Sprite,contentSize:Point,offest:Point,divider:Number,asBitmap:Boolean):void
	{
		this.skin = skin;
		this.layer = layer;
		this.contentSize = contentSize;
		this.offest = offest;
		this.divider = divider;
		this.asBitmap = asBitmap;
	}
}