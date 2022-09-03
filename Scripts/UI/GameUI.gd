extends Control

# Player 1 related canvas
onready var player1_bomb_count := $Player1/VBox/Bomb/GrayArea/Count as Label
onready var player1_fire_count := $Player1/VBox/Fire/GrayArea/Count as Label
onready var player1_label := $Player1/VBox/PlayerLabel as Label
onready var player1_panel := $Player1 as Panel

# Player 2 related canvas
onready var player2_bomb_count := $Player2/VBox/Bomb/GrayArea/Count as Label
onready var player2_fire_count := $Player2/VBox/Fire/GrayArea/Count as Label
onready var player2_label := $Player2/VBox/PlayerLabel as Label
onready var player2_panel := $Player2 as Panel



func _ready():
	EventManager.connect("update_item_canvas", self, "update_player_items")
	
	
	
func update_player_items(bomb_amount: int, bomb_range: int, player_type: int) -> void:
	match player_type:
		0:
			player1_bomb_count.text = str(bomb_amount)
			player1_fire_count.text = str(bomb_range)
		1:
			pass
			player2_bomb_count.text = str(bomb_amount)
			player2_fire_count.text = str(bomb_range)



func set_player_canvas_colors(player_type: int, new_color: Color) -> void:
	match player_type:
		0:
			player1_label.add_color_override("font_color", new_color)
			player1_panel.set_self_modulate(new_color) 
		1:
			player2_label.add_color_override("font_color", new_color)
			player2_panel.set_self_modulate(new_color)
