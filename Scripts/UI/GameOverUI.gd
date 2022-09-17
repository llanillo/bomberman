extends CanvasLayer

onready var home_button := $HomeButton as TextureButton
onready var restart_button := $RestartButton as TextureButton 
onready var winner_label := $WinnerLabel as Label
onready var cooldown_timer := $CooldownTimer as Timer



# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.stop_warning_sound()	
	AudioManager.stop_main_theme()
	AudioManager.stop_sudden_death()
	AudioManager.victory_theme.play()
	home_button.connect("pressed", self, "on_home_button_pressed")
	restart_button.connect("pressed", self, "on_restart_button_pressed")
	cooldown_timer.connect("timeout", self, "on_cooldown_timer_timeout")
	cooldown_timer.start()
	
	set_buttons_disabled(true)


"""
	Use some time offset to wait for all the bombs to explode otherwise
	they will still be on the next level load
"""
func on_cooldown_timer_timeout() -> void:
	set_buttons_disabled(false)



func set_winner_label_text(winner: int, new_color : Color) -> void:
	winner_label.add_color_override("font_color", new_color)
	winner_label.text = "PLAYER " + str(winner) + "\nWINS"



func on_home_button_pressed() -> void:
	AudioManager.stop_warning_sound()	
	AudioManager.stop_victory_theme()
	AudioManager.stop_sudden_death()
	AudioManager.stop_main_theme()
	SceneChanger.load_main_menu()
	


func on_restart_button_pressed() -> void:
	AudioManager.stop_warning_sound()
	AudioManager.stop_victory_theme()
	AudioManager.stop_sudden_death()
	AudioManager.stop_main_theme()
	SceneChanger.switch_to_next_level(true)



func set_buttons_disabled(value: bool) -> void:
	home_button.disabled = value
	restart_button.disabled = value
