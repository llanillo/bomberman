extends Node

class_name NumberUtil

static func get_random_number_in_range(begin: int, end: int, avoid: int) -> int:
	randomize()
	
	var random_number : int
	while true:
		random_number = randi() % end + begin
		
		if random_number != avoid:
			break
	
	return random_number
