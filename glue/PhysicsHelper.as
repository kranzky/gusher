package glue 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import flash.geom.Rectangle;

	public class PhysicsHelper
	{
		private static var fixture:b2FixtureDef = new b2FixtureDef();
		
		public static function CreateBox(world:b2World, loc:Rectangle, type:int = 0, friction:Number = 0.3, density:Number = 1, restitution:Number = 0):b2Body
		{
			var body:b2Body;
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(loc.x / 30 + (loc.width / 2) / 30, loc.y / 30 + (loc.height / 2 ) / 30);
			bodyDef.type = type;			
			
			var boxDef:b2PolygonShape = new b2PolygonShape();
			boxDef.SetAsBox((loc.width / 2) / 30, (loc.height / 2) / 30);
			
			fixture.shape = boxDef;
			fixture.friction = friction;
			fixture.density = density;
			fixture.restitution = restitution;
			
			body = world.CreateBody(bodyDef);
			body.CreateFixture(fixture);
			return body;
		}
		
		public static function CreateCircle(world:b2World, x:int = 0, y:int = 0, radius:int = 5, type:int = 0, friction:Number = 0.3, density:Number = 1, restitution:Number = 0):b2Body
		{
			var body:b2Body;
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(x / 30 + (radius / 2) / 30, y / 30 + (radius / 2 ) / 30);
			bodyDef.type = type;			
			
			var boxDef:b2CircleShape = new b2CircleShape();
			boxDef.SetRadius(radius / 30);
			
			fixture.shape = boxDef;
			fixture.friction = friction;
			fixture.density = density;
			fixture.restitution = restitution;
			
			body = world.CreateBody(bodyDef);
			body.CreateFixture(fixture);
			return body;
		}	
	}
}