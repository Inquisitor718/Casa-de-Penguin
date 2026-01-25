extends Node2D

@export var move_distance  :=200.0
@export var move_speed := 400.0

var target_x := 0
var moving :=false

func move_forward():
	if moving:
		return
		
	moving =true 
	target_x  = position.x+ move_distance 
	
func _process(delta: float) -> void:
	if moving:
		position.x =move_toward(position.x,target_x,move_speed*delta)
		if position.x == target_x:
			moving =false
			
