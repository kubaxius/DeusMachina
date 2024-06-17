using Godot;
using GodotPlugins.Game;
using System;

public partial class VoxelWorld : Node3D
{
	private Resource MG = GD.Load("res://planet/voxel_world/generators/MainGenerator.cs");

	public override void _Ready()
	{
		var Terrain = GetNode<VoxelTerrain>("VoxelTerrain");
		Terrain.Generator = (VoxelGenerator)MG;
	}

}
