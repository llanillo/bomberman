extends Area2D

export (float) var speed_reduce_percentage := 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	

func on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.reduce_speed(body.player_type, speed_reduce_percentage)


func on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		body.recover_speed(body.player_type)
