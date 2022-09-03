extends Node

class_name PositionUtil

static func snap_position_to_grid(position: Vector2) -> Vector2:
	var tile_size := GameManager.TileSize
	
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	return position
