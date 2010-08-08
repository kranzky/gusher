package  
{
	import glue.PhysicsEntity;
	import glue.PhysicsHelper;
	import glue.PhysicsWorld;
	import Box2D.Dynamics.b2Body;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Stamp;
	
	public class Ground extends PhysicsEntity
	{		
		public function Ground( x:int = 0, y:int = 0, w:int = 800 ) 
		{
			body = PhysicsHelper.CreateBox( PhysicsWorld( FP.world ).world, new Rectangle( x, y, w, 10 ), b2Body.b2_staticBody, 0.9, 1, 0.3 );
		}	
	}
}