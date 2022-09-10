extends Node2D

export (int) var max_steps_amount := 5
export (int) var stop_steps_amount := 2

onready var move_array_directions := [Vector2.DOWN, Vector2.UP, Vector2.LEFT, Vector2.RIGHT]
onready var walls_array := [$TopWall, $DownWall, $RightWall, $LeftWall]
onready var move_timer := $MoveTimer

var current_step_count := 0

func _ready():
	EventManager.connect("sudden_death_start", self, "on_sudden_death_start")
	assign_signal_to_walls(walls_array)
	move_timer.connect("timeout", self, "on_move_timer_timeout")
	
	
	
func assign_signal_to_walls(walls: Array) -> void:
	for wall in walls:
		wall.connect("body_entered", self, "on_wall_body_entered")
		
		

func move_walls() -> void:
	for index in walls_array.size():
		walls_array[index].global_position += move_array_directions[index] * GameManager.TileSize



func on_sudden_death_start() -> void:
	move_timer.start()
	
	
	
func on_wall_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		EventManager.emit_signal("player_die", body.player_type)	
	
	if body.is_in_group("Bomb") or body.is_in_group("Items"):
		body.init_bomb_explosion()


func on_move_timer_timeout() -> void:
	if current_step_count >= max_steps_amount: return
	if !GameStatus.can_play: return
	if current_step_count == stop_steps_amount: EventManager.emit_signal("destroy_all_bricks")
	
	move_walls()
	move_timer.start()
	current_step_count += 1
	
