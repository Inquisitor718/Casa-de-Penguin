extends Area2D
@onready var fish: Area2D = $"."
@onready var hot_coco: Area2D = $"."

var comfy_points= 0.0
var dragging = false
var mouse_offset := Vector2.ZERO

var inside_penguin := false


@warning_ignore("unused_parameter")
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			mouse_offset = global_position - get_global_mouse_position()
		else:
			dragging = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and dragging:
			dragging = false
			print("drag released")
			if inside_penguin:
				ProgresBar.add_energy(comfy_points)
				print("Dropped inside Penguin Area!")
				queue_free()

@warning_ignore("unused_parameter")
func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() + mouse_offset


func _on_area_entered(area):
	if area.name == "Penguin" or area.name == "Penguin2":
		inside_penguin = true
		print("in")


func _on_area_exited(area: Area2D) -> void:
	if area.name == "Penguin" or area.name == "Penguin2":
		print("out")
		inside_penguin = false
