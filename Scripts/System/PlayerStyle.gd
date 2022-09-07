extends Node

var sprite_frames := {
	0: preload("res://Animations/SpriteFrames/BluePlayer.tres"),
	1: preload("res://Animations/SpriteFrames/GreenPlayer.tres"),
	2: preload("res://Animations/SpriteFrames/PurplePlayer.tres"),
	3: preload("res://Animations/SpriteFrames/YellowPlayer.tres")}

var player_colors := {
	0: Color.blue,
	1: Color.green,
	2: Color.purple,
	3: Color.yellow}



var player1_index : int
var player2_index : int



func get_random_style_index() -> int:
	randomize()
	return randi() % sprite_frames.keys().size()


func get_player1_color() -> Color:
	return player_colors[player1_index]
	
	
	
func get_player2_color() -> Color:
	return player_colors [player2_index]
	

func get_player2_sprite_frame() -> SpriteFrames:
	return sprite_frames[player2_index]


func get_player1_sprite_frame() -> SpriteFrames:
	return sprite_frames[player1_index]	
	
	
func set_player_random_style() -> void:
	player1_index = -1
	player2_index = -1
	
	while player2_index == player1_index:
		randomize()
		player1_index = randi() % sprite_frames.keys().size()
		player2_index = randi() % sprite_frames.keys().size()
