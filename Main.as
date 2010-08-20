package 
{
	import OilWorld;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	import splash.Splash;
	
	public class Main extends Engine 
	{		
		public function Main():void 
		{
			super( 800, 600, 50, false );
		}

		override public function init():void 
		{
			var s:Splash = new Splash;
			FP.world.add( s );
			s.start( splashComplete );
		}
		
		public function splashComplete():void
		{
			//FP.console.enable();
			FP.world = new OilWorld();
		}
	}
}