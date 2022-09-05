extends Node

class_name PlayerAttack

var bomb_scene : PackedScene

func place_bomb(bomb_duration: float, bomb_range: int, position: Vector2, in_player_type) -> void:
	var new_position := Vector2()
	new_position = PositionUtil.snap_position_to_grid(position)	
#
	var bomb_instance = bomb_scene.instance()
	bomb_instance.global_position = new_position
	bomb_instance.explosion_range = bomb_range
	bomb_instance.bomb_duration_time = bomb_duration
	
	# Dependency injection (player_type)
	bomb_instance.player_type = in_player_type
	
	get_tree().root.add_child(bomb_instance)
	
	

