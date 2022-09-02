extends Area2D

class_name PickupBase

enum Index {fire = 0, mini_bomb = 1}

export (float) var time_to_destroy := 3.0
export (int) var power_up_increase_amount := 1
export(Index) var pickup_type := Index.fire

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "on_body_entered")


func on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		EventManager.emit_signal("item_pickup", body.player_type, pickup_type)
		queue_free()
