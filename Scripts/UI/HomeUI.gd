extends CanvasLayer

onready var start_button := $VBox/Button

func _ready():
	start_button.connect("pressed", self, "on_start_button_press")



func on_start_button_press() -> void:
	SceneChanger.switch_scene()
