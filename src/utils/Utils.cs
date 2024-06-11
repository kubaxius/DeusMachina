using Godot;

namespace Utils;

public static class Inputs
{
    public static Vector3 GetMovementVector()
    {
        Vector3 movementVector = Vector3.Zero;

        if (Input.IsActionPressed("move_forwards"))
        {movementVector.Z -= 1;}
        if (Input.IsActionPressed("move_backwards"))
        {movementVector.Z += 1;}
        if (Input.IsActionPressed("move_left"))
        {movementVector.X -= 1;}
        if (Input.IsActionPressed("move_right"))
        {movementVector.X += 1;}

        movementVector = movementVector.Normalized();

        if (Input.IsActionPressed("action_sprint"))
        {movementVector *= 2;}

        return movementVector;

    }
}