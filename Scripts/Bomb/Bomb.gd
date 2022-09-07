extends RigidBody2D

class_name Bomb

var direction_array := [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT] as Array

export (PackedScene) var explosion_scene : PackedScene
export (float) var explosion_duration := 0.5

var bomb_duration_time : float
var explosion_range : int
var player_type : int

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var area2d := $Area2D as Area2D
onready var rigidbody_collision_shape := $CollisionShape2D as CollisionShape2D
onready var area2d_collision_shape := $Area2D/CollisionShape2D as CollisionShape2D



func _ready():
	area2d.connect("body_exited", self, "on_body_exited")	
	animation_player.play("bomb")
	


func init_bomb_explosion() -> void:
	EventManager.emit_signal("bomb_exploted", player_type)

	instantiate_explosion(global_position)
	for direction in direction_array:
		instantiate_explosion_line(global_position, direction)
	
	call_deferred("free")



func on_body_exited(body: Node) -> void:	
	if body.is_in_group("Player"):
		area2d_collision_shape.set_deferred("disabled", true)
		rigidbody_collision_shape.set_deferred("disabled", false)
	

# Stops the rigidbody movement
func on_bomb_explosion_animation_almost_finished()-> void:
#	sleeping = true
#	global_position = PositionUtil.snap_position_to_grid(global_position)
	pass


func instantiate_explosion_line(position: Vector2, direction: Vector2) -> void:
	for index in explosion_range:
		position += direction * GameManager.TileSize
		
		var tiles_in_position := get_world_2d().direct_space_state.intersect_point(position, 1)
				
		if not tiles_in_position.empty(): 
			var tile_object = tiles_in_position[0].collider

			if tile_object.is_in_group("UBrick"): return

			if tile_object.is_in_group("DBrick"):
				tile_object.start_brick_destroy_animation()
				return

		instantiate_explosion(position)
	
	

func instantiate_explosion(position) -> void:	
	var explosion_instance = explosion_scene.instance()
	explosion_instance.global_position = position	
	explosion_instance.explosion_duration_time = explosion_duration
	get_tree().root.add_child(explosion_instance)	
