using Godot;
using System;

public partial class MainGenerator : VoxelGeneratorScript
{
    private const int channel = (int)VoxelBuffer.ChannelId.ChannelType;
    public override int _GetUsedChannelsMask()
    {
        return 1 << channel;
    }

    public override void _GenerateBlock(VoxelBuffer outBuffer, Vector3I originInVoxels, int lod)
    {
        if (originInVoxels.Y < 0)
        {
            outBuffer.Fill(1, channel);
        }
        if (originInVoxels.X == originInVoxels.Z && originInVoxels.Y < 1)
        {
            outBuffer.Fill(1, channel);
        }
    }
}
