extends Node

class_name PlayerAttack

var bomb_scene : PackedScene

func place_bomb(bomb_duration: float, bomb_range: int, position: Vector2) -> void:
	var new_position := Vector2()
#	new_position.x = round(position.x)
#	new_position.y = round(position.y)
#	new_position = position.snapped(Vector2.ONE * tile_size)
#	new_position += Vector2.ONE * tile_size / 2
	new_position = snap_bomb_to_grid(position)	
		
	var bomb_instance = bomb_scene.instance()
	bomb_instance.global_position = new_position
	bomb_instance.explosion_range = bomb_range
	bomb_instance.bomb_duration_time = bomb_duration
	get_tree().root.add_child(bomb_instance)

static func snap_bomb_to_grid(position: Vector2) -> Vector2:
	var tile_size := GameManager.TileSize
	
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	return position
