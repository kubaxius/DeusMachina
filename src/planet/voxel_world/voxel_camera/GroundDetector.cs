using Godot;
using System;

public partial class GroundDetector : RayCast3D
{
	public double GetDesiredHeight()
	{
		if(GetCollider() != null)
		{
			return GetCollisionPoint().Y;
		}
		return GetParent<Node3D>().GlobalPosition.Y;
	}
}
