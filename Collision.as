package  
{
	import Box2D.Dynamics.b2ContactFilter;
	import Box2D.Dynamics.b2Fixture;
	
	public class Collision extends b2ContactFilter
	{		
		override public function ShouldCollide( fixtureA:b2Fixture, fixtureB:b2Fixture ):Boolean
		{
			if ( fixtureA.GetBody().GetUserData() == "droplet" && fixtureB.GetBody().GetUserData() == "pot" )
			{
				return false;
			}
			if ( fixtureA.GetBody().GetUserData() == "pot" && fixtureB.GetBody().GetUserData() == "droplet" )
			{
				return false;
			}
			return true;
		}
	}
}