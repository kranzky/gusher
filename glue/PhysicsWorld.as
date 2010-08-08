package glue
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	public class PhysicsWorld extends World
	{
		public var world:b2World = new b2World( new b2Vec2( 0.0, 9.81 ), true );
		
		public function SetGravity( grav:b2Vec2 ):void
		{
			world.SetGravity( grav );
		}
		
		public function debug_draw():void
		{
			var m_sprite:Sprite = new Sprite();
			FP.stage.addChild( m_sprite );
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			var dbgSprite:Sprite = new Sprite();
			m_sprite.addChild( dbgSprite );
			dbgDraw.SetSprite( m_sprite );
			dbgDraw.SetDrawScale( 30 );
			dbgDraw.SetAlpha( 0.2 );
			dbgDraw.SetFillAlpha( 0.5 );
			dbgDraw.SetLineThickness( 1 );
			dbgDraw.SetFlags( b2DebugDraw.e_shapeBit );
			world.SetDebugDraw( dbgDraw );
		}
	}
}