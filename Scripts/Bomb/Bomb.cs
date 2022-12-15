using System;
using Godot.Collections;

namespace Bomberman.Bomb;

public class Bomb : RigidBody2D
{
    private const string BombAnimation = "Bomb";

    private readonly Vector2[] _explosionDirections = { Vector2.Up, Vector2.Down, Vector2.Left, Vector2.Right };

    private float _durationTime;
    private int _explosionRange;
    private PlayerIndex _playerIndex;

    [Export] public PackedScene ExplosionScene { get; private set; }

    private EventManager EventManager { get; set; }
    private AudioManager AudioManager { get; set; }
    private AnimationPlayer AnimationPlayer { get; set; }
    private Area2D Area2D { get; set; }
    private CollisionShape2D RigidbodyCollision { get; set; }
    private CollisionShape2D Area2DCollision { get; set; }

    public override void _Ready()
    {
        EventManager = GetNode<EventManager>("root/EventManager") ??
                       throw new ArgumentNullException(nameof(EventManager));
        AudioManager = GetNode<AudioManager>("root/AudioManager") ??
                       throw new ArgumentNullException(nameof(AudioManager));
        AnimationPlayer = GetNode<AnimationPlayer>("AnimationPlayer") ??
                          throw new ArgumentNullException(nameof(AnimationPlayer));
        Area2D = GetNode<Area2D>("Area2D") ?? throw new ArgumentNullException(nameof(Area2D));
        RigidbodyCollision = GetNode<CollisionShape2D>("CollisionShape2D") ??
                             throw new ArgumentNullException(nameof(RigidbodyCollision));
        Area2DCollision = GetNode<CollisionShape2D>("Area2D/CollisionShape2D") ??
                          throw new ArgumentNullException(nameof(Area2DCollision));

        AudioManager.PlayBombDropSound();
        Area2D.Connect(BodyExited, this, nameof(OnBodyExited));
        AnimationPlayer.Play(BombAnimation);
    }

    public void InitExplosion()
    {
        EventManager.EmitSignal(nameof(EventManager.BombExplosion), _playerIndex);
        SpawnExplosion(GlobalPosition); // Spawn  the middle bomb
        
        // Spawns explosions in cross
        foreach(var direction in _explosionDirections)
        {
            SpawnExplosionLine(GlobalPosition, direction);
        }
    }
    
    private void SpawnExplosion(Vector2 position)
    {
        if (ExplosionScene.Instance() is not Explosion explosionInstance) return;
        explosionInstance.GlobalPosition = position;
        GetTree().Root.CallDeferred(AddChildren, explosionInstance);
    }

    private void SpawnExplosionLine(Vector2 position, Vector2 direction)
    {
        for (var i = 0; i < _explosionRange; i++)
        {
            position += direction * GameManager.TileSize;

            var tilesInPosition = GetWorld2d().DirectSpaceState.IntersectPoint(position, 1);

            if (tilesInPosition.Count > 0)
            {
                if (((Dictionary)tilesInPosition[0])[Collider] is not Brick brickInPosition) return;
                if (brickInPosition.IsInGroup(IndestructibleBrickGroup)) return;
                if (brickInPosition.IsInGroup(DestructibleBrickGroup)) brickInPosition.InitDestroy();
            }

            SpawnExplosion(position);
        }
    }

    private void OnBodyExited(Node body)
    {
        if (!body.IsInGroup(PlayerGroup)) return;

        var isPlayerInArea = false;

        foreach (var objectInArea in Area2D.GetOverlappingBodies())
        {
            var nodeInArea = (Node)objectInArea;
            if (nodeInArea.IsInGroup(PlayerGroup)) isPlayerInArea = true;
        }

        if (isPlayerInArea) return;
        Area2DCollision.SetDeferred(Disabled, true);
        RigidbodyCollision.SetDeferred(Disabled, false);
    }
}