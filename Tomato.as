package  
{
	import glue.PhysicsEntity;
	import net.flashpunk.graphics.Image;
	import glue.PhysicsWorld;
	import net.flashpunk.FP;
	import glue.PhysicsHelper;
	import Box2D.Dynamics.b2Body;
	import Box2D.Common.Math.b2Vec2;
	
	public class Tomato extends PhysicsEntity
	{
		[Embed(source = 'data/tomato.png')]
		private const TOMATO:Class;
		private var tomato:Image;
		private var submerged:Boolean = false;
		
		public function Tomato( x:int = 0, y:int = 0 ) 
		{
			tomato = new Image( TOMATO );
			tomato.scale = 0.5;
			width = tomato.scale * tomato.width * 0.72;
			height = tomato.scale * tomato.height * 0.72;
			setHitbox( width, height, width * 0.5, height * 0.5 );
			tomato.centerOO();
			tomato.smooth = true;
			super( x, y, tomato );
			var physics_world:PhysicsWorld = FP.world as PhysicsWorld;
			body = PhysicsHelper.CreateCircle( physics_world.world, x, y, 90 * tomato.scale, b2Body.b2_dynamicBody, 0.5, 8, 0.0 );
			body.SetAngularVelocity( 2 * Math.random() - 2 * Math.random() );
			step();
			visible = true;
		}
		override public function step():void
		{
			var oil_world:OilWorld = FP.world as OilWorld;

			if ( body != null )
			{
				var pos:b2Vec2 = body.GetPosition();
				x = pos.x * 30;
				y = pos.y * 30;
				tomato.angle = -body.GetAngle() * (180 / Math.PI);
			}
			
			if ( ! submerged && y > 160 && x > 100 && x < 500 )
			{
				oil_world.water.AddBody( body );
				submerged = true;
			}
			
			if ( submerged && y < 150 )
			{
				oil_world.water.RemoveBody( body );
				submerged = false;
			}
			
			if ( y < -100 || y > 600 || x < 0 || x > 800 )
			{
				oil_world.world.DestroyBody(body);
				FP.world.remove( this );
			}
		}
	}
}