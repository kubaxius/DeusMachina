using System;
using Godot;

public partial class VoxelCamera : Node3D
{
	[Export(PropertyHint.Range, "0, 1, 0.1")]
	public float MovementSpeed = 0.2f;
	[Export(PropertyHint.Range, "0, 100, 1")]
	public int Sensitivity = 20;
	[Export(PropertyHint.Range, "0, 5, 0.1")]
	public float ZoomAmount = 1;
	[Export]
	public float MaxZoomDist = 1000f;
	[Export]
	public float MinZoomDist = 1f;
	[Export(PropertyHint.Range, "1.01, 3, 0.05")]
	public float ZoomBase = 1.5f;

	private Node3D hGimbal;
	private Node3D vGimbal;
	private Node3D camera;

	private float currentZoomExponent = 0f;
	private Vector3 movementVector = Vector3.Zero;

	#region Overrides
	public override void _Ready()
	{
		hGimbal = GetNode<Node3D>("HGimbal");
		vGimbal = GetNode<Node3D>("HGimbal/VGimbal");
		camera = GetNode<Camera3D>("%Camera");

		currentZoomExponent = (float)(Mathf.Log(camera.Position.Z) / Mathf.Log(ZoomBase));
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		HandleRotationInput(@event);
		HandleZoomInput(@event);
		HandleMovementInput();
	}

    public override void _PhysicsProcess(double delta)
	{
		Position += movementVector;
		double desiredHeight = GetNode<GroundDetector>("GroundDetector").GetDesiredHeight();
		Vector3 newPosition = Position;
		newPosition.Y = Mathf.Lerp(newPosition.Y, desiredHeight, 0.1);
		Position = newPosition;
	}

	#endregion Overrides

	public void HandleRotationInput(InputEvent @event)
	{
		if (@event is InputEventMouseMotion motion)
		{
			if (Input.IsActionPressed("rotate_camera"))
			{
				RotateCamera(new Vector2(-motion.Relative.X, -motion.Relative.Y));
			}
		}
	}

	private void RotateCamera(Vector2 mouseVector)
	{
		vGimbal.RotateX(mouseVector.Y / (101 - Sensitivity));
		hGimbal.RotateY(mouseVector.X / (101 - Sensitivity));
		Vector3 clampedVerticalRotation = vGimbal.Rotation;
		clampedVerticalRotation.X = Mathf.Clamp(clampedVerticalRotation.X, -Mathf.Pi / 2, Mathf.Pi / 2);
		vGimbal.Rotation = clampedVerticalRotation;
	}


    private void HandleZoomInput(InputEvent @event)
    {
		if(@event.IsActionPressed("zoom_in"))
		{Zoom(-ZoomAmount);}

		if(@event.IsActionPressed("zoom_out"))
		{Zoom(ZoomAmount);}

    }

    private void Zoom(float zoomAmount)
    {
        currentZoomExponent += zoomAmount;
		double newPositionZ = Mathf.Pow(ZoomBase, currentZoomExponent);

		if (newPositionZ > MaxZoomDist || newPositionZ < MinZoomDist)
		{
			currentZoomExponent -= zoomAmount;
			return;
		}

		Vector3 newPosition = camera.Position;
		newPosition.Z = newPositionZ;
		camera.Position = newPosition;
    }

    private void HandleMovementInput()
	{
		var newMovementVector = Utils.Inputs.GetMovementVector();
		newMovementVector = newMovementVector.Rotated(Vector3.Up, camera.GlobalRotation.Y);
		movementVector = newMovementVector * MovementSpeed;
	}



}
