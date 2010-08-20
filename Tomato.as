package  
{
	import Box2D.Dynamics.Controllers.b2BuoyancyController;
	import flash.display.BlendMode;
	import flash.geom.Rectangle;
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
		[Embed(source = 'data/celery.png')]
		private const CELERY:Class;
		[Embed(source = 'data/onion.png')]
		private const ONION:Class;
		[Embed(source = 'data/carrot.png')]
		private const CARROT:Class;
		[Embed(source = 'data/kransky.png')]
		private const KRANSKY:Class;
		private var tomato:Image;
		private var submerged:Boolean = false;
		private var ingredient:Boolean = false;
		
		public function Tomato( x:int = 0, y:int = 0, n:int = 0 ) 
		{
			if ( n == 0 )
			{
				tomato = new Image( TOMATO );
			}
			else if ( n == 1 )
			{
				tomato = new Image( CELERY );
			}
			else if ( n == 2 )
			{
				tomato = new Image( ONION );
			}
			else if ( n == 3 )
			{
				tomato = new Image( CARROT );
			}
			else
			{
				tomato = new Image( KRANSKY );
			}
			tomato.scale = 0.7 + 0.05 * n;
			width = tomato.scale * tomato.width;
			height = tomato.scale * tomato.height;
			if ( n == 0 || n == 2 )
			{
				width *= 0.72;
				height *= 0.72;
			}
			else
			{
				width *= 0.85;
				height *= 0.85;				
			}
			setHitbox( width, height, width * 0.5, height * 0.5 );
			tomato.centerOO();
			tomato.smooth = true;
			super( x, y, tomato );
			var physics_world:PhysicsWorld = FP.world as PhysicsWorld;
			if ( n == 0 || n == 2 )
			{
				body = PhysicsHelper.CreateCircle( physics_world.world, x, y, 60 * tomato.scale, b2Body.b2_dynamicBody, 0.5, 4 + 3 * n, 0.0 );
			}
			else
			{
				body = PhysicsHelper.CreateBox( physics_world.world, new Rectangle( x, y, width, height ), b2Body.b2_dynamicBody, 0.5, 4 + 3 * n, 0.0 );
			}
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
				tomato.angle = -body.GetAngle() * ( 180 / Math.PI );
			}
			
			if ( ! submerged && ( y + 0.5 * height ) > ( oil_world.soup.y - 10 ) && x > 100 && x < 500 )
			{
				oil_world.soup.water.AddBody( body );
				submerged = true;
			}
			
			if ( ! ingredient && y > oil_world.soup.y )
			{
				ingredient = true;
				oil_world.soup.addIngredient();
			}
			
			if ( submerged && ( ( y + 0.5 * height ) < ( oil_world.soup.y - 20 ) || x < 100 || x > 500 ) )
			{
				oil_world.soup.water.RemoveBody( body );
				submerged = false;
			}
			
			if ( y < -100 || y > 600 || x < -100 || x > 900 )
			{
				oil_world.world.DestroyBody(body);
				FP.world.remove( this );
			}
		}
	}
}