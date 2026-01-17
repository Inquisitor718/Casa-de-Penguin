extends CharacterBody2D

@export var follow_strength := 0.25
var centre: Vector2 = Vector2(953.0, 525.0)


func _ready():
	pass

func _physics_process(delta):
	var target = get_global_mouse_position()
	look_at(centre)
	global_position = global_position.lerp(target, follow_strength)
