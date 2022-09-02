extends Node

class_name GameManager

const TileSize := 32
const TileMapBrickindex := 0

onready var bricks_tile_map := $BricksTileMap
onready var game_ui := $GameUI

export (Dictionary) var tiles_scenes := {
	0: preload("res://Scenes/Environment/UndestructibleBrick.tscn"),
	1: preload("res://Scenes/Environment/DestructibleBrick.tscn")}

# Called when the node enters the scene tree for the first time.
func _ready():
	EventManager.connect("player_die", self, "game_over")
	reset_game()
	
	yield(get_tree(), "idle_frame") # Neccesary to avoid TileMap crashes
	replace_tiles_with_scene_objects(bricks_tile_map, tiles_scenes)


func game_over(losing_player: int) -> void:
	print("Game over: Player " + str(losing_player) + " is a loser")
	

func reset_game() -> void:
	
	# Initial player canvas values
	game_ui.update_player_items(1, 1, 0)
	game_ui.update_player_items(1, 1, 1)


func replace_tiles_with_scene_objects(tile_map: TileMap, scenes_dicitionary: Dictionary) -> void:
	for tile_pos in tile_map.get_used_cells():
		var tile_id := tile_map.get_cell(tile_pos.x, tile_pos.y)
		
		if scenes_dicitionary.has(tile_id):
			var object_scene = scenes_dicitionary[tile_id]
			# Clear the cell in the tilemap
			if tile_map.get_cellv(tile_pos) != tile_map.INVALID_CELL:
				tile_map.set_cellv(tile_pos, -1) # Removes the tile cell
				tile_map.update_bitmask_region() # Updates the tile map to avoid conflict
				
			# Spawn the object at the position
			if object_scene:
				var object_instance = object_scene.instance()
				var object_position := tile_map.map_to_world(tile_pos) + tile_map.cell_size * 0.5
				object_instance.global_position = object_position
				get_tree().root.add_child(object_instance)

	
