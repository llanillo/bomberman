extends Node

onready var animation_player := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "on_body_entered")
	animation_player.play("explosion")
	AudioManager.play_exposion()


func on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		EventManager.emit_signal("player_die", body.player_type)		
		
	if body.is_in_group("Bomb"):
		body.init_bomb_explosion()
		
		

func queue_free_explosion() -> void:
	call_deferred("queue_free")
