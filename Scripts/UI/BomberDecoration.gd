extends KinematicBody2D

onready var visibility_notifier := $VisibilityNotifier2D as VisibilityNotifier2D

export (float) var speed := 100
export (Vector2) var direction := Vector2.LEFT


func _ready():
	visibility_notifier.connect("screen_exited", self, "on_bomber_screen_exited")
	$Sprite.texture = GameStatus.test
	
		
func _physics_process(delta):
	move_and_slide(direction * speed)



func on_bomber_screen_exited() -> void:
	queue_free()
