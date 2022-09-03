extends Node

class_name PlayerInput
	
var player_type

func _input(event):
	if !GameStatus.can_play : return
	on_player_attack_input(event)
	
func get_player_move_input() -> Vector2:
	var velocity = Vector2()
	
	if Input.is_action_pressed('player%s_right' % player_type):
		velocity.x += 1
	elif Input.is_action_pressed('player%s_left' % player_type):
		velocity.x -= 1
	elif Input.is_action_pressed('player%s_up' % player_type):
		velocity.y -= 1
	elif Input.is_action_pressed('player%s_down' % player_type):
		velocity.y += 1
	
	return velocity.normalized()	
	
	
	
func on_player_attack_input(event) -> void:
	if Input.is_action_just_pressed('player%s_attack' % player_type):
		EventManager.emit_signal("player_attack_input", player_type)
