extends Control

onready var spawn_bomber_position := $SpawnBomberPosition
onready var start_button := $VBox/Button
onready var spawn_timer := $SpawnTimer

export (PackedScene) var bomber_scene := preload("res://Scenes/UI/BomberDecoration.tscn")



func _ready():
	start_button.connect("pressed", self, "on_start_button_press")
	spawn_timer.connect("timeout", self, "on_spawn_timer_timeout")
	spawn_timer.start()


func on_start_button_press() -> void:
	SceneChanger.switch_to_next_level(true)



func on_spawn_timer_timeout() -> void:
	var bomber_instance := bomber_scene.instance()
	bomber_instance.global_position = spawn_bomber_position.global_position
	add_child(bomber_instance)
	spawn_timer.start()
	
