extends Node

signal bomb_exploted(player_type)
signal player_attack_input(player_type)
signal player_die(player_type)
signal item_pickup(player_type, item_index)
signal update_item_canvas(bomb_amount, bomb_range, player_type)
signal sudden_death_start()
signal destroy_all_bricks()
