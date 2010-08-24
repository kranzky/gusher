package  
{
	import flash.display.BlendMode;
	import glue.PhysicsWorld;
	import glue.PhysicsEntity;
	import glue.PhysicsHelper;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import Box2D.Dynamics.b2Body;
	import Box2D.Common.Math.b2Vec2;
	import net.flashpunk.FP;
	import flash.geom.Point;
	import net.flashpunk.utils.Draw;
	
	public class OilDrop extends PhysicsEntity
	{		
		[Embed(source = 'data/droplet_blue.png')]
		private const DROPLET_BLUE:Class;
		[Embed(source = 'data/droplet_green.png')]
		private const DROPLET_GREEN:Class;
		[Embed(source = 'data/droplet_red.png')]
		private const DROPLET_RED:Class;
		private var droplet:Image;
		[Embed(source = 'data/poplet.png')]
		private const POPLET:Class;
		private var poplet:Image;
		private var submerged:Boolean = false;
		private var age:int = 0;
		public var colour:int = 0;
		public var scale:Number = 1.0;
		public var hover:Boolean = false;
		public var select:Boolean = false;
		public var joined:Boolean = false;
		public var score:int = 0;

		public function OilDrop( x:int = 0, y:int = 0, scale:Number = 0.1, colour:Number = 0 ) 
		{
			this.colour = colour;
			this.scale = scale;
			if ( colour == 0 )
			{
				droplet = new Image( DROPLET_BLUE );
			}
			else if ( colour == 1 )
			{
				droplet = new Image( DROPLET_GREEN );
			}
			else
			{
				droplet = new Image( DROPLET_RED );
			}
			
			droplet.scale = scale;
			width = droplet.scale * droplet.width * 0.72;
			height = droplet.scale * droplet.height * 0.72;
			setHitbox( width, height, width * 0.5, height * 0.5 );
			droplet.centerOO();
			droplet.smooth = true;
			poplet = new Image( POPLET );
			poplet.centerOO();
			poplet.scale = droplet.scale;
			poplet.smooth = true;
			super( x, y, droplet );
			type = "droplet";
			var physics_world:PhysicsWorld = FP.world as PhysicsWorld;
			body = PhysicsHelper.CreateCircle( physics_world.world, x, y, 160 * droplet.scale, b2Body.b2_dynamicBody, 0.0, 0.5, 0.0 );
			body.SetUserData( "droplet" );
			step();
			visible = true;
		}
		override public function render():void
		{
			if ( select || joined )
			{
				Draw.circlePlus( x, y, 157 * scale, 0xFFFFFFFF );
			}
			super.render();
			if ( hover )
			{
				Draw.circlePlus( x, y, 157 * scale, 0xFFFFFFFF, 0.3 );
			}
			if ( joined )
			{
				Draw.circlePlus( x, y, 160 * scale, 0xFFFF0000, 0.8, false, 3 );
			}
			else if ( select )
			{
				Draw.circlePlus( x, y, 160 * scale, 0xFFFF0000, 0.5, false, 3 );
			}
		}
		override public function step():void
		{
			var oil_world:OilWorld = FP.world as OilWorld;
			
			if ( body != null )
			{
				var pos:b2Vec2 = body.GetPosition();
				x = pos.x * 30;
				y = pos.y * 30;
			}
			
			if ( ! submerged || body == null || scale > 0.4 )
			{
				age += 1;
			}
			
			if ( ! submerged && ( y + 0.5 * height ) > ( oil_world.soup.y - 10 ) && x > 100 && x < 500 )
			{
				if ( body != null )
				{
					oil_world.soup.water.AddBody( body );
				}
				submerged = true;
			}
			
			if ( submerged && ( ( y + 0.5 * height ) < ( oil_world.soup.y - 20 ) || x < 100 || x > 500 ) )
			{
				if ( body != null )
				{
					oil_world.soup.water.RemoveBody( body );
				}
				submerged = false;
			}
			
			if ( graphic == poplet )
			{
				oil_world.unselect( this );
				if ( body != null )
				{
					oil_world.world.DestroyBody( body );
				}
				if ( score > 0 )
				{
					oil_world.add( new Score( x, y - 0.4 * height, score ) );
					oil_world.score += score;
				}
				FP.world.remove( this );
			}
			
			if ( scale > 0.5 || y < 10 || y > 590 || x < 10 || x > 790 )
			{
				age = 49;
			}
			if ( age > 48 && body != null )
			{
				oil_world.unselect( this );
				graphic = poplet;
				oil_world.world.DestroyBody(body);
				body = null;
				submerged = false;
			}
			
			if ( hover )
			{
				age = 0;
			}
			
			hover = false;
		}
	}
}