extends RigidBody2D



# Called when the node enters the scene tree for the first time.
func _ready():
	EventManager.connect("destroy_all_bricks", self, "destroy_brick")


func destroy_brick() -> void:
	call_deferred("queue_free")
