extends RigidBody2D



# Called when the node enters the scene tree for the first time.
func _ready():
	EventManager.connect("sudden_death_start", self, "destroy_brick")


func destroy_brick() -> void:
	queue_free()
