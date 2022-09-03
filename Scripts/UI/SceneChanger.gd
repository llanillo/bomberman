extends CanvasLayer

const FadeAnim = "screen_fade"
const MapScenesPath = "res://Scenes/Map/"
const SceneExtension = ".tscn"

onready var animation_player := $AnimationPlayer as AnimationPlayer
var total_levels_count := 0

func _ready():
	get_total_map_count()
	
	
	
func set_scene(play_anim: bool) -> void:
	if play_anim:
		animation_player.play(FadeAnim)
	else:
		switch_scene()
	


func switch_scene() -> void:
	randomize()
#	var random_number := randi() % total_levels_count + 1
#	print (random_number)
#	get_tree().change_scene(scene)



func get_total_map_count () -> void:
	var directory = Directory.new()
	
	if directory.open(MapScenesPath) == OK:
		directory.list_dir_begin()
		
		var file_name = directory.get_next()
		
		while file_name != "":
			if !directory.current_is_dir():
				total_levels_count += 1

			file_name = directory.get_next()
	else:
		print("Path not found")
