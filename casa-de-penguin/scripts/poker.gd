extends CharacterBody2D

@export var follow_strength := 4.0  
var centre: Vector2 = Vector2(953.0, 525.0)

func _physics_process(delta):
	var target = get_global_mouse_position()

	var t = 1.0 - exp(-follow_strength * delta)
	global_position = global_position.lerp(target, t)

	look_at(centre)
