using System;

namespace Bomberman.Bomb;

public class Explosion : Area2D
{
    private const string ExplosionAnimation = "explosion";

    private AnimationPlayer AnimationPlayer { get; set; }
    private AudioManager AudioManager { get; set; }
    private EventManager EventManager { get; set; }

    public override void _Ready()
    {
        base._Ready();

        EventManager = GetNode<EventManager>("EventManager") ?? throw new ArgumentNullException(nameof(EventManager));
        AnimationPlayer = GetNode<AnimationPlayer>("AnimationPlayer") ??
                          throw new ArgumentNullException(nameof(AnimationPlayer));
        AudioManager = GetNode<AudioManager>("AudioManager") ?? throw new ArgumentNullException(nameof(AudioManager));
        
        Connect(SignalUtil.BodyEntered, this, nameof(OnBodyEntered));
        AnimationPlayer.Play(ExplosionAnimation);
    }

    private void OnBodyEntered(Node body)
    {
        switch (body)
        {
            case PlayerManager player:
                EventManager.EmitSignal(nameof(EventManager.PlayerDie), player.Index);
                break;
            case Bomb bomb:
                bomb.InitExplosion();
                break;
            default:
                return;
        }
    }

    private void Delete()
    {
        QueueFree();
    }
}