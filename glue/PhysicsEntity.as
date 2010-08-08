package glue 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Entity;
	
	public class PhysicsEntity extends Entity
	{
		public var body:b2Body;
		
		public function PhysicsEntity( x:Number = 0, y:Number = 0, graphic:Graphic = null, mask:Mask = null ):void
		{
			super( x, y, graphic, mask );
			visible = false;
		}
		
		public function step():void
		{
		}
	}
}