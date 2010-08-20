package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import flash.display.Sprite;
	
	[SWF(width = "800", height = "600")]
	
	/**
	 * ...
	 * @author Noel Berry
	 */
	public class Preloader extends MovieClip 
	{
		[Embed(source = 'data/loading.png')] static private var imgLoading:Class;
		private var loading:Bitmap = new  imgLoading;
		
		private var square:Sprite = new Sprite();
		private var border:Sprite = new Sprite();
		private var wd:Number = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal) * 240;
		
		public function Preloader() 
		{
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			// show loader
			addChild(loading);
			loading.x = 0;
			loading.y = 0;

			addChild(square);
			square.x = 200;
			square.y = stage.stageHeight / 2 - 50;
			
			addChild(border);
			border.x = 200-4;
			border.y = stage.stageHeight / 2 - 4 - 50;
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// update loader
			square.graphics.beginFill(0x000000);
			square.graphics.drawRect(80,0,(loaderInfo.bytesLoaded / loaderInfo.bytesTotal) * 240,20);
			square.graphics.endFill();
			
			border.graphics.lineStyle(2,0x000000);
			border.graphics.drawRect(80, 0, 248, 28);
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				startup();
			}
		}
		
		private function startup():void 
		{
			//hide loader
			stop();
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
	}
}