extends Node2D
@onready var snowman_pos: Marker2D = $snowman_pos
var timeout=0
@export var points:int

func _ready() -> void:
	await get_tree().create_timer(15.0).timeout
	timeout=1
	points=floor(100*((1.5-min(1.5,abs(snowman_pos.global_rotation)))/1.5))
	print(points)

func _process(delta: float) -> void:
	var wind=-0.1
	if(timeout==0):
		if (wind>0 and snowman_pos.global_rotation<1.5):
			snowman_pos.global_rotation+=wind*delta
		elif(wind<0 and snowman_pos.global_rotation>-1.5):
			snowman_pos.global_rotation+=wind*delta
		if Input.is_action_just_pressed("click"):
			if(get_global_mouse_position().x>578 and snowman_pos.global_rotation>-1.5):
				snowman_pos.global_rotation-=0.2
			elif(snowman_pos.global_rotation<1.5):
				snowman_pos.global_rotation+=0.2
