extends Node

onready var destroy_timer := $DestroyTimer as Timer

var explosion_duration_time : float

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "on_body_entered")
	destroy_timer.connect("timeout", self, "on_explosion_timer_timeout")	
	destroy_timer.set_one_shot(true)
	destroy_timer.start(explosion_duration_time)


func on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		var player := body as PlayerManager
		EventManager.emit_signal("player_die", player.player_type)		
	
	if body.is_in_group("Bomb"):
		body.init_bomb_explosion()
		
		

func on_explosion_timer_timeout() -> void:
	call_deferred("queue_free")
