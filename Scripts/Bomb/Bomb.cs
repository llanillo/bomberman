using System;

namespace Bomberman.Bomb;

public class Bomb : Node
{
    private const string BombAnimation = "Bomb";
    
    [Export] public PackedScene ExplosionScene { get; private set; }
    
    private readonly Vector2[] _directions = { Vector2.Up, Vector2.Down, Vector2.Left, Vector2.Right, };

    private AudioManager AudioManager { get; set; }
    private float _durationTime;
    private int _explosionRange;

    private AnimationPlayer _animationPlayer;
    private Area2D _area2D;
    
    private CollisionShape2D _rigidbodyCollision;
    private CollisionShape2D _area2DCollision;
    
    public override void _Ready()
    {
        _animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer") ??
                           throw new ArgumentNullException(nameof(_animationPlayer));
        _area2D = GetNode<Area2D>("Area2D") ?? throw new ArgumentNullException(nameof(_area2D));
        _rigidbodyCollision = GetNode<CollisionShape2D>("CollisionShape2D") ??
                              throw new ArgumentNullException(nameof(_rigidbodyCollision));
        _area2DCollision = GetNode<CollisionShape2D>("Area2D/CollisionShape2D") ??
                           throw new ArgumentNullException(nameof(_area2DCollision));
        
        AudioManager.PlayBombDropSound();
        _area2D.Connect(BodyExited, this, nameof(OnBodyExited));
        _animationPlayer.Play();
    }

    private void InstantiateExplosion(Vector2 position)
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

            var tilesInPosition = Physics2DServer.SpaceGetDirectState().IntersectPoint(position, 1);
            
            if(!tilk)
        }
    }

    private void OnBodyExited(Node body)
    {
        if (!body.IsInGroup(PlayerGroup)) return;
        
        var isPlayerInArea = false;
            
        foreach(var objectInArea in _area2D.GetOverlappingBodies())
        {
            var nodeInArea = (Node)objectInArea;
            if (nodeInArea.IsInGroup(PlayerGroup))
            {
                isPlayerInArea = true;
            }
        }

        if (isPlayerInArea) return;
        _area2DCollision.SetDeferred(Disabled, true);       
        _rigidbodyCollision.SetDeferred(Disabled, false);
    }
}