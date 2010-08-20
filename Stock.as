package  
{
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import Box2D.Dynamics.Controllers.b2Controller;
	import Box2D.Dynamics.Controllers.b2BuoyancyController;
	
	public class Stock extends Entity
	{	
		[Embed(source = 'data/water.png')]
		private const SOUP:Class;
		private var scenery:Spritemap;
		public var background:Spritemap;
		public var water:b2BuoyancyController;
		public var rate:Number = 1.0;

		public function Stock( x:int=0, y:int=0 ) 
		{
			var oil_world:OilWorld = FP.world as OilWorld;

			water = new b2BuoyancyController();
			water.normal.Set( 0, -1 );
			water.offset = -10.5;
			water.density = 1.0;
			water.linearDrag = 10.0;
			water.angularDrag = 2.0;
			oil_world.world.AddController( water );
	
			updateRate();
			
			scenery =  new Spritemap( SOUP, 424, 311 );
			scenery.originX = scenery.width / 2;
			scenery.originY = scenery.height / 2;
			scenery.alpha = 0.5;
			scenery.add( "forward", [ 0, 1, 2, 3, 4 ], 1, true );
			
			background =  new Spritemap( SOUP, 424, 311 );
			background.originX = scenery.width / 2;
			background.originY = scenery.height / 2;
			background.alpha = 0.3;
			background.add( "backward", [ 3, 2, 1, 0, 4 ], 1, true );
			
			super( x, y, scenery );
			
			scenery.play( "forward" );
			background.play( "backward" );
		}
		
		public function addIngredient():void
		{
			y -= 30;
			water.offset += 1;
			scenery.alpha += 0.05;
		}
		
		public function increaseHeat():void
		{
			water.density += 0.05;
			if ( water.density > 15 )
			{
				water.density = 15;
			}
			updateRate();
		}
		
		public function reduceHeat():void
		{
			water.density = water.density * ( 500.0 / ( water.density * water.density + 499.0 ) );
			if ( water.density < 1.0 )
			{
				water.density = 1.0;
			}
			updateRate();
		}
		
		private function updateRate():void
		{
			rate = 2.0 / ( water.density * water.density + 1.0 );
			if ( rate < 0.01 )
			{
				rate = 0.01;
			}
			if ( scenery != null )
			{
				scenery.rate = water.density;
				background.rate = water.density * 0.7;
			}
		}
		
		override public function update(): void
		{
			scenery.update();
			background.update();
			super.update();
		}
	}
}
