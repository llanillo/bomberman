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
export (int) var speed := 200
export (int) var push_strength := 10
export (int) var max_bomb_amount := 1
export (int) var max_bomb_range := 1
export (float) var max_bomb_duration_time := 2.0

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
	current_bomb_range = max_bomb_range
	
	
func set_sprite_frame(new_sprite_frame: SpriteFrames) -> void:
	player_animated_sprite.set_sprite_frames(new_sprite_frame)
	
	
	
func set_label_color(new_color: Color) -> void:
	player_label.add_color_override("font_color", new_color)
	
	
	
func _physics_process(delta):	
	if !GameStatus.can_play : return
	
	current_velocity = player_input.get_player_move_input()
	current_velocity = move_and_slide(current_velocity * speed, UpVector, false, 4, PI/4, false)
	on_player_collision_with_bomb(get_slide_count())



func on_player_collision_with_bomb(collision_count: int) -> void:
	for index in collision_count:
		var collision = get_slide_collision(index)
		
		if collision.collider.is_in_group("Bomb"):
			collision.collider.apply_central_impulse(-collision.normal * push_strength)
		


func on_player_attack(in_player_type) -> void:	
	if !GameStatus.can_play : return
	if player_type != in_player_type: return
	if current_bomb_count <= 0: return
	if is_there_already_a_bomb_in_position(global_position) : return
			
	player_attack.place_bomb(current_bomb_duration_time, current_bomb_range, global_position)
	current_bomb_count -= 1
	EventManager.emit_signal("update_item_canvas", current_bomb_count, current_bomb_range, player_type)	



func on_bomb_exploted() -> void:
	if current_bomb_count >= max_bomb_amount: return
	
	current_bomb_count += 1
	EventManager.emit_signal("update_item_canvas", current_bomb_count, current_bomb_range, player_type)	



func on_pickup_item(in_player_type: int, in_pickup_type : int) -> void:
	if player_type != in_player_type: return
	
	match in_pickup_type:		
		0: # Fire items, increase explosion range
			max_bomb_range += 1
			current_bomb_range += 1
		1: # Minibombs items, increase bomb amount
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
