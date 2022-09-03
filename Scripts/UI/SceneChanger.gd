extends CanvasLayer

const FadeAnim = "fade"
const MapScenesPath = "res://Scenes/Map/"
const SceneExtension = ".tscn"
const MainMenuPath = "res://Scenes/UI/HomeUI"

onready var animation_player := $AnimationPlayer as AnimationPlayer
var total_levels_count := 0



func _ready():
	get_total_levels_count()
	
	

func load_main_menu() -> void:
	get_tree().change_scene(MainMenuPath + SceneExtension)
	

	
func switch_to_next_level(play_anim: bool) -> void:
	if play_anim:
		animation_player.play(FadeAnim)
	else:
		load_next_random_level()
	


func load_next_random_level() -> void:
	randomize()
	var random_number := randi() % total_levels_count + 1 # Random number between 1 and total_levels_count
	var next_scene := MapScenesPath + "Level" + str(random_number) + SceneExtension
	get_tree().change_scene(next_scene)



func get_total_levels_count () -> void:
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
