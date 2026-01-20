extends Node2D
@onready var snowman_pos: Marker2D = $snowman_pos
var timeout=0
@export var points:int
var target_rot := 0.0
var duration := 0.12
var lerp_const: float = 0.02
var holding = false

func _ready() -> void:
	target_rot = snowman_pos.rotation
	await get_tree().create_timer(15.0).timeout
	timeout=1
	points=floor(100*((1.5-min(1.5,abs(snowman_pos.global_rotation)))/1.5))
	print(points)
	
func _rotate(rotate_step)->void:
	target_rot = clamp(
	target_rot + rotate_step,
	-1.5,
	1.5
	)

	var tween := create_tween()
	tween.tween_property(
		snowman_pos,
		"rotation",
		target_rot,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
func _process(delta: float) -> void:
	var wind=-0.3
	if(timeout==0):
		if (wind>0 and snowman_pos.global_rotation<1.5):
			snowman_pos.global_rotation+=wind*delta
		elif(wind<0 and snowman_pos.global_rotation>-1.5):
			snowman_pos.global_rotation+=wind*delta
			
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) \
		or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			holding=true
		else:
			holding=false
			
		if holding:
			if(get_global_mouse_position().x>578 and snowman_pos.global_rotation>-1.5):
				_rotate(-0.005)
			elif(snowman_pos.global_rotation<1.5):
				_rotate(0.005)
