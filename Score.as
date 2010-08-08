package  
{
	import net.flashpunk.FP;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	
	public class Score extends Entity
	{
		private var message:Text;
		private var age:int = 30;
		public function Score( x:int = 0, y:int = 0, score:int = 0 ) 
		{
			super( x, y );
			message = new Text( String( score ) );
		}
		override public function update():void
		{
			super.update();
			age -= 1;
			if ( age <= 0 )
			{
				FP.world.remove( this );
			}
		}
		override public function render():void
		{
			message.render( new Point( x - 0.5 * message.width, y - 30 + age ), new Point() );
		}
	}
}