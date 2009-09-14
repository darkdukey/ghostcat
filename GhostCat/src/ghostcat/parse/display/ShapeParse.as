package ghostcat.parse.display
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	
	import ghostcat.parse.DisplayParse;
	import ghostcat.parse.graphics.GraphicsEndFill;
	import ghostcat.parse.graphics.IGraphicsFill;
	import ghostcat.parse.graphics.IGraphicsLineStyle;
	
	public class ShapeParse extends DisplayParse
	{
		public var line:IGraphicsLineStyle;
		public var fill:IGraphicsFill;
		public var parses:Array;
		public var grid9:Grid9Parse;
		public function ShapeParse(parses:Array,line:IGraphicsLineStyle=null,fill:IGraphicsFill=null,grid9:Grid9Parse=null)
		{
			this.parses = parses;
			
			this.line = line;
			this.fill = fill;
			
			this.grid9 = grid9;
		}
		
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			
			if (line)
				line.parse(target);
			
			if (fill)
				fill.parse(target);
			
			parseBaseShape(target);
			
			if (fill)
				new GraphicsEndFill().parse(target);
		}
		protected function parseBaseShape(target:Graphics) : void
		{
			if (parses)
			{
				for (var i:int = 0;i < parses.length;i++)
					(parse[i] as DisplayParse).parse(target);
			}
		}
		
		public override function parseBitmapData(target:BitmapData) : void
		{
			super.parseBitmapData(target);
			
			target.draw(createShape());
		}
		
		
		public override function parseDisplay(target:DisplayObject) : void
		{
			super.parseDisplay(target);
			
			if (grid9)
				grid9.parse(target);
		}
		
		public override function parseContainer(target:DisplayObjectContainer) : void
		{
			super.parseContainer(target);
			
			var s:Shape = createShape();
			target.addChild(s);
		}
	}
}