extends KinematicBody2D

class_name PlayerManager

const UpVector := Vector2.UP
const LabelPosition := Vector2(-7, -24)

onready var player_input := $Controllers/Input as PlayerInput
onready var player_attack := $Controllers/Attack as PlayerAttack
onready var player_label := $Label as Label
onready var player_animation := $AnimationPlayer as AnimationPlayer
onready var player_animated_sprite := $AnimatedSprite as AnimatedSprite

export (PackedScene) var bomb_scene : PackedScene

export (PlayerType.Index) var player_type := PlayerType.Index.player0
export (float) var speed := 3.5
#export (float) var speed := 200
export (int) var push_strength := 10
export (float) var max_bomb_duration_time := 2.0

var max_bomb_amount := 1
var current_velocity : Vector2
var current_bomb_count : int
var current_bomb_range : int
var current_bomb_duration_time : float


func _ready():	
	EventManager.connect("player_attack_input", self, "on_player_attack")
	EventManager.connect("bomb_exploted", self, "on_bomb_exploted")
	EventManager.connect("item_pickup", self, "on_pickup_item")
	
	# Depencendy injection
	player_input.player_type = player_type
	player_attack.bomb_scene = bomb_scene
	
	# Nodes preparation	
	player_label.set_position(LabelPosition) # Sets label position above the player
	player_label.text = str(player_type + 1) # Sets label text according to the player type
	player_animation.play("Label") # Plays the bounce label animation
	
	# Resets player stats
	current_bomb_count = max_bomb_amount
	current_bomb_duration_time = max_bomb_duration_time
	current_bomb_range = 1
	
	
	
func set_sprite_frame(sprite_frame: SpriteFrames) -> void:
	player_animated_sprite.set_sprite_frames(sprite_frame)
	player_animated_sprite.set_animation("Down")
	player_animated_sprite.playing = true 
	
	
func set_label_color(color: Color) -> void:
	player_label.add_color_override("font_color", color)
	
	
	
func hide_label()-> void:
	player_label.visible = false
	
	
	
func _process(delta):
	if !GameStatus.can_play : return
	handle_player_animation()
	
	
	
func _physics_process(delta):	
	if !GameStatus.can_play : return
	
	current_velocity = player_input.get_player_move_input()
#	current_velocity = move_and_slide(current_velocity * speed, UpVector, false, 4, PI/4, false)
	var collision_info = move_and_collide(current_velocity * speed, false)
	if collision_info:
#		current_velocity = (collision_info.normal.tangent() + collision_info.remainder) * speed
		
		if collision_info.collider.is_in_group("Bomb"):
				collision_info.collider.apply_central_impulse(-collision_info.normal * push_strength)
				



func handle_player_animation() -> void:
#	if current_velocity == Vector2.ZERO:
#		player_animated_sprite.stop()
#	else:
		player_animated_sprite.play()
		
		if current_velocity.x != 0:
			player_animated_sprite.set_animation("Horizontal")
			
			if current_velocity.x > 0:
				player_animated_sprite.flip_h = false
			elif current_velocity.x < 0:
				player_animated_sprite.flip_h = true
				
		elif current_velocity.y != 0:
			if current_velocity.y < 0:
				player_animated_sprite.set_animation("Up")
			elif current_velocity.y >= 0:
				player_animated_sprite.set_animation("Down")
		
		
		
#func on_player_collision_with_bomb(collision_count: int) -> void:
#	for index in collision_count:
#		var collision = get_slide_collision(index)
#
#		if collision.collider.is_in_group("Bomb"):
#			collision.collider.apply_central_impulse(-collision.normal * push_strength)
#


func on_player_attack(in_player_type) -> void:	
	if !GameStatus.can_play : return
	if player_type != in_player_type: return
	if current_bomb_count <= 0: return
	if is_there_already_a_bomb_in_position(global_position) : return
			
	player_attack.place_bomb(current_bomb_duration_time, current_bomb_range, global_position, player_type)
	current_bomb_count -= 1
	EventManager.emit_signal("update_item_canvas", current_bomb_count, current_bomb_range, player_type)	



func on_bomb_exploted(in_player_type) -> void:
	if player_type != in_player_type: return
	if current_bomb_count >= max_bomb_amount: return
	
	current_bomb_count += 1
	EventManager.emit_signal("update_item_canvas", current_bomb_count, current_bomb_range, player_type)	



func on_pickup_item(in_player_type: int, in_pickup_type : int) -> void:
	if player_type != in_player_type: return
	
	match in_pickup_type:		
		0: # Fire items, increase explosion range
			if current_bomb_range >= GameManager.MaximumBombRange: return
			current_bomb_range += 1
		1: # Minibombs items, increase bomb amount
			if current_bomb_count >= GameManager.MaximumBombs: return
			if max_bomb_amount >= GameManager.MaximumBombs: return
			max_bomb_amount += 1
			current_bomb_count += 1
			
	EventManager.emit_signal("update_item_canvas", current_bomb_count, current_bomb_range, player_type)	



func is_there_already_a_bomb_in_position(position: Vector2) -> bool:
	var objects_in_position := get_world_2d().direct_space_state.intersect_point(
		PositionUtil.snap_position_to_grid(global_position), 5, [], 0x7FFFFFFF, true, true)
		
	if not objects_in_position.empty():	
		for object_collisiion in objects_in_position:
			var object = object_collisiion.collider
			
			if object.is_in_group("Bomb"):
				return true
				
	return false
