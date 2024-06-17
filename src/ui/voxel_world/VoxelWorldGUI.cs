using Godot;
using System;

public partial class VoxelWorldGUI : Control
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

    public override void _Input(InputEvent @event)
    {
        if(@event.IsActionPressed("context_menu"))
		{
			GD.Print("dupasass");
			GetViewport().SetInputAsHandled();
		}
    }
}
