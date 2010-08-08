package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	public class Scenery extends Entity
	{		
		private var scenery:Image;
		
		public function Scenery( image:Image, x:int=0, y:int=0 ) 
		{
			scenery =  image;
			scenery.originX = scenery.width / 2;
			scenery.originY = scenery.height / 2;
			super( x, y, scenery );
		}
	}
}