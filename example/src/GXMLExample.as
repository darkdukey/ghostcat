package
{
	
	import ghostcat.skin.ScrollUpButtonSkin;ScrollUpButtonSkin;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import ghostcat.gxml.spec.DisplaySpec;
		
	import ghostcat.gxml.GXMLManager;
	import flash.events.MouseEvent;
	import ghostcat.manager.DragManager;

	public class GXMLExample extends Sprite
	{
		public var button:DisplayObject;
		public function GXMLExample()
		{
			var xml:XML = <skin:ScrollUpButtonSkin xmlns:skin="ghostcat.skin" xmlns:fi="flash.filters"
							id="button" x="50" y="50" on_mouseDown="mouseDownHandler">
								<filters>
									<fi:BlurFilter blurX="4" blurY="4"/>
									<fi:DropShadowFilter color="0x0000FF"/>
								</filters>
							</skin:ScrollUpButtonSkin>;
							
			GXMLManager.instance.create(xml,new DisplaySpec(this));
			
			addChild(button);
		}
		
		public function mouseDownHandler(event:MouseEvent):void
		{
			DragManager.startDrag(button);
		}
	}
}