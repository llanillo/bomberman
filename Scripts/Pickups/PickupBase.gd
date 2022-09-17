extends Area2D

class_name PickupBase

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var collision_shape := $CollisionShape2D


enum Index {fire = 0, mini_bomb = 1}

var destroyed = false

export (float) var time_to_destroy := 3.0
export (int) var power_up_increase_amount := 1
export(Index) var pickup_type := Index.fire

# Called when the node enters the scene tree for the first time.
func _ready():
	EventManager.connect("destroy_all_bricks", self, "destroy_items")
	connect("body_entered", self, "on_body_entered")
	animation_player.play("pickup_item")


func on_body_entered(body: Node) -> void:
	if body.is_in_group("Player") and !destroyed:		
		AudioManager.play_item_pickup()
		EventManager.emit_signal("item_pickup", body.player_type, pickup_type)
		collision_shape.set_deferred("disabled", true)
		call_deferred("queue_free")

func destroy_items() -> void:
	call_deferred("queue_free")
