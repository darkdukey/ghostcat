package ghostcat.operation.effect
{
	import ghostcat.operation.Queue;
	
	/**
	 * 队列效果 
	 * @author Administrator
	 * 
	 */
	public class QueueEffect extends Queue implements IEffect
	{
		/** @inheritDoc*/
		public function get target():*
		{
			return (children && children.length > 0) ? children[0] : null;
		}
		
		public function set target(v:*):void
		{
			for each (var oper:* in children)
			{
				if (oper is IEffect)
					(oper as IEffect).target = v;
			}
		}
		
		public function QueueEffect(data:Array=null)
		{
			super(data);
		}
	}
}