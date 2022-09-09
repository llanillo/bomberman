extends KinematicBody2D

onready var visibility_notifier := $VisibilityNotifier2D as VisibilityNotifier2D
onready var animated_sprite := $AnimatedSprite as AnimatedSprite

export (float) var speed := 130
export (Vector2) var direction := Vector2.LEFT


func _ready():
	visibility_notifier.connect("screen_exited", self, "on_bomber_screen_exited")
	
	var random_style_index = PlayerStyle.get_random_style_index()
	animated_sprite.set_sprite_frames(PlayerStyle.sprite_frames[random_style_index])	
	animated_sprite.flip_h = true
	animated_sprite.set_animation("Horizontal")
	animated_sprite.playing = true
		
		
		
func _physics_process(delta):
	move_and_slide(direction * speed)



func on_bomber_screen_exited() -> void:
	call_deferred("queue_free")
