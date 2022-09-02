extends Control

onready var player1_bomb_count := $Player1/VBox/Bomb/GrayArea/Count
onready var player1_fire_count := $Player1/VBox/Fire/GrayArea/Count

func _ready():
	EventManager.connect("update_item_canvas", self, "update_player_items")
	
	
	
func update_player_items(bomb_amount: int, bomb_range: int, player_type: int) -> void:
	match player_type:
		0:
			player1_bomb_count.text = str(bomb_amount)
			player1_fire_count.text = str(bomb_range)
		1:
			pass
#			player2_bomb_count.text = str(bomb_amount)
#			player2_fire_count.text = str(fire_amount)
