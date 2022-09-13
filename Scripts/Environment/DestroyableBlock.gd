extends RigidBody2D

onready var animation_player := $AnimationPlayer

export (int) var time_before_destroy := 1
export (float) var fire_pickup_chance := 0.10
export (float) var minibomb_pickup_chance := 0.20 # From range, it is 10% because its calculated from the fire chance

export (PackedScene) var fire_pickup_scene := preload("res://Scenes/Pickups/Fire.tscn")
export (PackedScene) var minibomb_pickup_scene := preload("res://Scenes/Pickups/MiniBomb.tscn")


func _ready():
	EventManager.connect("destroy_all_bricks", self, "start_brick_destroy_animation")
	
	
	
func start_brick_destroy_animation() -> void:
	animation_player.play("destroy")
	


func on_destroy_brick_animation_finish () -> void:	
	if !GameStatus.sudden_death_started:
		randomize()
		var random_value := randf()
			
		if is_float_in_range(random_value, 0, fire_pickup_chance):
			instantiate_pickup(fire_pickup_scene)
		elif is_float_in_range(random_value, fire_pickup_chance,  minibomb_pickup_chance):
			instantiate_pickup(minibomb_pickup_scene)
			
	call_deferred("queue_free")
	
	
	
func instantiate_pickup(object_scene: PackedScene) -> void:	
	var object_instance = object_scene.instance()	
	object_instance.global_position = global_position
	get_tree().root.add_child(object_instance)



func is_float_in_range(value: float, minimum: float, maximum: float) -> bool:
	return value >= minimum and value <= maximum

