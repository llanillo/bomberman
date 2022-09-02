extends Node2D

class_name Bomb

var direction_array := [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT] as Array

export (PackedScene) var explosion_scene : PackedScene

export (float) var explosion_duration := 2.0

var bomb_duration_time : float
var explosion_duration_time : float
var explosion_range : int

onready var destroy_timer = $DestroyTimer
onready var area2d := $Area2D as Area2D
onready var rigidbody_collision_shape := $CollisionShape2D as CollisionShape2D
onready var area2d_collision_shape := $Area2D/CollisionShape2D as CollisionShape2D

func _ready():
	area2d.connect("body_exited", self, "on_body_exited")	
	destroy_timer.connect("timeout", self, "on_bomb_timer_timeout")		
	destroy_timer.start(bomb_duration_time)
	


func on_bomb_timer_timeout() -> void:
	EventManager.emit_signal("bomb_exploted")
	
#	var rigidbody_position = rigidobyd2d.global_position
	
	instantiate_explosion(global_position)
	for direction in direction_array:
		instantiate_cross_explosion(global_position, direction)
	
	queue_free()


func on_body_exited(body: Node) -> void:	
	if body.is_in_group("Player"):
		area2d_collision_shape.set_deferred("disabled", true)
		rigidbody_collision_shape.set_deferred("disabled", false)
	


func instantiate_cross_explosion(position: Vector2, direction: Vector2) -> void:
	for index in explosion_range:
		position += direction * GameManager.TileSize
		
		var tiles_in_position := get_world_2d().direct_space_state.intersect_point(position, 1)
				
		if not tiles_in_position.empty(): 
			var tile_object = tiles_in_position[0].collider
			
			if tile_object.is_in_group("DBrick"):
				tile_object.destroy_brick()
			
			return
			
		instantiate_explosion(position)
	
	

func instantiate_explosion(position) -> void:	
	var explosion_instance = explosion_scene.instance()
	explosion_instance.global_position = position	
	explosion_instance.explosion_duration_time = explosion_duration_time
	get_tree().root.add_child(explosion_instance)	
