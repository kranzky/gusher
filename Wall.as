package  
{
	import glue.PhysicsEntity;
	import glue.PhysicsHelper;
	import glue.PhysicsWorld;
	import Box2D.Dynamics.b2Body;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Stamp;
	
	public class Wall extends PhysicsEntity
	{		
		public function Wall( x:int = 0, y:int = 0, h:int = 600 ) 
		{
			body = PhysicsHelper.CreateBox( PhysicsWorld( FP.world ).world, new Rectangle( x, y, 13, h ), b2Body.b2_staticBody, 0.9, 1, 0.3 );
		}	
	}
}