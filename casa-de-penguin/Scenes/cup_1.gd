extends Node2D

@export var max_fill :=1.0
@export var fill_speed :=0.35

@onready var coffee := $Coffee
@onready var cup2 := get_parent().get_node("cup2")

var fill_amount :=0.0
var filled :=false

func fill_coffee():
	if filled:
		return 
		
	fill_amount +=fill_speed* get_process_delta_time()
	fill_amount = clamp(fill_amount,0.0,max_fill)
	
