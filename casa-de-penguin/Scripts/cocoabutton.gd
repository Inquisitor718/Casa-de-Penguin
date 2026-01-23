extends Node2D
@onready var area_2d: Area2D = $Area2D
@export var button = false

func _ready() -> void:
	area_2d.input_pickable = true
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			button = !button
			if button:
				print("ON")
			elif !button:
				print("OFF")
