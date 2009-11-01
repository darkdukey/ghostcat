package ghostcat.operation
{
	import flash.events.EventDispatcher;

	/**
	 * 监听事件，事件触发时继续
	 *  
	 * @param obj	监听的对象
	 * @param event	监听的事件
	 * 
	 */
	public class WatchOper extends TimeoutOper
	{
		/**
		 * 对象
		 */
		public var obj:EventDispatcher;
		/**
		 * 监听的事件 
		 */
		public var event:String;
		public function WatchOper(obj:EventDispatcher=null,event:String=null)
		{
			super();
			this.obj = obj;
			this.event = event;
		}
		/** @inheritDoc*/
		public override function execute():void
		{
			super.execute();
			obj.addEventListener(this.event,result);
		}
		/** @inheritDoc*/
		protected override function end(event:*=null):void
		{
			super.end(event);
			obj.removeEventListener(this.event,result);
		}
	}
}