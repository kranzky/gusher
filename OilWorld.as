package
{
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import glue.PhysicsWorld;
	import glue.PhysicsEntity;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Draw;
	import flash.geom.Point;
	import Box2D.Common.Math.b2Vec2;
	
	public class OilWorld extends PhysicsWorld
	{		
		[Embed(source = 'data/background.png')]
		private const BACKGROUND:Class;
		[Embed(source = 'data/foreground.png')]
		private const FOREGROUND:Class;
		private var background:Entity;
		private var foreground:Entity;
		public var soup:Stock;
		private var next:Number = 2.0;
		private var normal:Number = 1.0 / 30;
		private var slow:Number = 1.0 / 150;
		private var hover:OilDrop = null;
		public var select1:OilDrop = null;
		public var select2:OilDrop = null;
		private var joinlist:Array = new Array();
		private var testdrop:OilDrop = null;
		public var old1:OilDrop = null;
		public var old2:OilDrop = null;
		public var newdrop:OilDrop = null;
		private var timer:Number = 180.0;
		private var drop_timer:Number = 0.0;
		private var drop_num:int = 0;
		private var timer_message:Text;
		public var score:int = 0;
		private var score_message:Text;
		
		override public function begin():void
		{		
			// debug_draw();
			
			timer_message = new Text( "TIMER: 180" );
			score_message = new Text( "SCORE: 999999" );
			
			var pot:Ground = new Ground( 90, 450, 410 );
			pot.body.SetUserData("pot");
			add( pot );
			
			add( new Ground( 0, 532, 800 ) );
			add( new Wall( 80, 140, 400 ) );
			add( new Wall( 500, 140, 400 ) );
			var fluid:Image = new Image( FOREGROUND );
			background = new Scenery( new Image( BACKGROUND ), 0, 0 );
			soup = new Stock( 86, 290 );
			foreground = new Scenery( fluid, 0, 0 );
			world.SetContactFilter( new Collision() );
		}
		
		public function unselect( drop:OilDrop ):void
		{
			drop.select = false;
			if ( drop == select1 || drop == select2 )
			{
				if ( select1 != null )
				{
					select1.select = false;
				}
				if ( select2 != null )
				{
					select2.select = false;
				}
				select1 = null;
				select2 = null;
			}
			testdrop = drop;
			joinlist = joinlist.filter( removeDrop ); 
			testdrop = null;
		}
        private function removeDrop(element:*, index:int, arr:Array):Boolean {
            return ( element["join1"] != testdrop && element["join2"] != testdrop );
        }

		override public function render():void
		{
			var select:Boolean = false;
			if ( select1 != null )
			{
				select = select1.select;
				select1.select = false;
			}
			background.render();
			soup.background.render( new Point( soup.x, soup.y - 10 ), new Point() );
			super.render();
			if ( Input.mouseDown && select1 != null && select2 == null )
			{
				Draw.linePlus( select1.x, select1.y, mouseX, mouseY,  0xFFFF0000, 0.5, 3.0 );
				select1.select = select;
				select1.render();
			}
			joinlist.forEach( drawLine );
			soup.render();
			foreground.render();
			timer_message.render( new Point( 650,  450 ), new Point() );
			score_message.render( new Point( 650,  470 ), new Point() );
		}
		
		private function drawLine(element:*, index:int, arr:Array):void
		{
			Draw.linePlus( element["join1"].x, element["join1"].y, element["join2"].x, element["join2"].y,  0xFFFF0000, 0.8, 3.0 );
			element["join1"].joined = true;
			element["join1"].render();
			element["join1"].joined = false;
			element["join2"].joined = true;
			element["join2"].render();
			element["join2"].joined = false;
		}
		
		override public function update():void
		{
			timer -= FP.elapsed;
			drop_timer += FP.elapsed;
			timer_message.text = "TIMER: ".concat( Math.ceil( timer ) );
			score_message.text = "SCORE: ".concat( score );
			
			if ( Input.mouseDown )
			{
				world.Step( slow, 1, 1 );
				next += 0.002;
			}
			else
			{
				world.Step( normal, 1, 1 );
				next += 0.01;
			}
	
			world.ClearForces();
			
			var entities:Array = [];
			getClass( PhysicsEntity, entities );
			for each ( var e:PhysicsEntity in entities )
			{
				e.step();
			}

			if ( next > soup.rate && classCount( OilDrop ) < 50 )
			{
				next = 0.0;
				var drop:OilDrop = new OilDrop( 360 * Math.random() + 115, 480,
												0.1 + 0.05 * Math.random() - 0.05 * Math.random(),
												Math.round( Math.random() * 2 ) );
				add( drop );
				soup.increaseHeat();
			}

			if ( drop_timer >= 30.0 && timer > 29.0 && drop_num < 5 )
			{
				drop_timer = 0.0;
				var tomato:Tomato = new Tomato( 290 - 180 * Math.random() + 180 * Math.random(), -80, drop_num );
				drop_num += 1;
				add( tomato );
			}

			if ( Input.mousePressed )
			{
				select1 = null;
				select2 = null;
			}

			hover = collideRect( "droplet", mouseX - 5, mouseY - 5, 10, 10 ) as OilDrop;
			if (  hover != null && hover.body == null )
			{
				hover = null;
			}
			if ( hover != null && ( select1 == null || select2 != null || hover.colour == select1.colour ) )
			{
				hover.hover = ! joinlist.some( hoverExists ) && hover != select1;
				if ( hover.hover )
				{
					if ( Input.mouseDown && select1 == null )
					{
						select1 = hover;
						select1.select = true;
					}
					else if ( Input.mouseReleased )
					{
						if ( select2 == null && select1 != null && select1.colour == hover.colour )
						{
							select2 = hover;
						}
						else
						{
							select1 = null;
							select2 = null;
						}
					}
				}
			}
			
			if ( ! joinlist.every( addForces ) )
			{
				joinlist = joinlist.filter( duplicate );
				joinlist = joinlist.map( replace );
				if ( select1 == old1 || select2 == old1 || select1 == old2 || select2 == old2 )
				{
					select1 = newdrop;
					select2 = null;
				}
				FP.world.remove( old1 );
				FP.world.remove( old2 );
				add( newdrop );
				old1 = null;
				old2 = null;
				newdrop = null;
				soup.reduceHeat();
			}
			
			if ( Input.mouseReleased && select1 != null && select2 != null && select1 != select2 )
			{
				if ( ! joinlist.some( pairExists ) )
				{
					var pair:Object = { join1: select1, join2: select2 };
					joinlist.push( pair );
				}
				select1.select = false;
				select1 = null;
				select2 = null;
			}
			if ( Input.mouseReleased && select1 != null )
			{
				select1.select = false;
				select1 = null;
			}

			world.DrawDebugData();
			super.update();
			soup.update();
		}
		private function pairExists( element:*, index:int, arr:Array ):Boolean
		{
            return ( element["join1"] == select1 && element["join2"] == select2 ||
			         element["join1"] == select2 && element["join2"] == select1 );
        }
		private function hoverExists( element:*, index:int, arr:Array ):Boolean
		{
            return ( element["join1"] == select1 && element["join2"] == hover ||
			         element["join1"] == hover && element["join2"] == select1 );
        }
		private function addForces(element:*, index:int, arr:Array):Boolean
		{
			var drop1:OilDrop = element["join1"];
			var drop2:OilDrop = element["join2"];
			if ( drop1.body == null || drop2.body == null )
			{
				return true;
			}
			var hit:b2Vec2 = drop2.body.GetPosition().Copy();
			var edge:b2ContactEdge = drop1.body.GetContactList();
			var touching:Boolean = false;
			while ( edge != null && !touching )
			{
				if ( edge.other == drop2.body )
				{
					touching = edge.contact.IsTouching();
				}
				edge = edge.next;
			}
			if ( touching )
			{
				var oil_world:OilWorld = FP.world as OilWorld;
				oil_world.world.DestroyBody( drop1.body );
				oil_world.world.DestroyBody( drop2.body );
				var x:Number = 15 * ( drop1.body.GetPosition().x + drop2.body.GetPosition().x ) - 40 * ( drop1.scale + drop2.scale );
				var y:Number = 15 * ( drop1.body.GetPosition().y + drop2.body.GetPosition().y ) - 40 * ( drop1.scale + drop2.scale );
				var s:Number = Math.sqrt( drop1.scale * drop1.scale + drop2.scale * drop2.scale );
				old1 = drop1;
				old2 = drop2;
				newdrop = new OilDrop( x, y, s, drop1.colour );
				newdrop.score = ( drop1.score + 1 ) * ( drop2.score + 1 );
				return false;
			}
			else
			{
				hit.Subtract( drop1.body.GetPosition() );
				hit.Multiply( 10.0 );
				drop1.body.ApplyForce( hit, drop1.body.GetPosition() );
				hit.Multiply( -1.0 );
				drop2.body.ApplyForce( hit, drop2.body.GetPosition() );
			}
			return true;
		}
		private function duplicate(element:*, index:int, arr:Array):Boolean
		{
			return ! ( element["join1"] == old1 && element["join2"] == old2 ||
					   element["join1"] == old2 && element["join2"] == old1 );
		}
		private function replace(element:*, index:int, arr:Array):Object
		{
			if ( element["join1"] == old1 || element["join1"] == old2 )
			{
				element["join1"] = newdrop;
			}
			if ( element["join2"] == old1 || element["join2"] == old2 )
			{
				element["join2"] = newdrop;
			}
			return element;
		}
	}
}