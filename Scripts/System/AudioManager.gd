extends Node2D

onready var explosion_audio := $Explosion
onready var sudden_death_theme := $SuddenDeathTheme
onready var main_theme := $MainTheme
onready var victory_theme := $VictoryTheme
onready var step_sound := $Step as AudioStreamPlayer
onready var place_bomb_sound := $Placebomb
onready var item_pickup_sound := $ItemPickup

func play_step() -> void:
	if !step_sound.playing:
		step_sound.play()

func stop_step() -> void:
	step_sound.stop()


func play_exposion() -> void:
	if explosion_audio.playing == false:
		explosion_audio.play()
		
func play_place_bomb() -> void:
	if place_bomb_sound.playing == false:
		place_bomb_sound.play()
		
func play_item_pickup()-> void:
	if item_pickup_sound.playing == false:
		item_pickup_sound.play()
