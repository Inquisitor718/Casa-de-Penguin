extends Node2D

signal attempt_finished(success: bool)

@onready var chain_area: Area2D = $Chain123
@export var disappear_delay := 1.0  # seconds to wait before disappearing

@export var spill_threshold := 10.0
@export var max_pull_y := 750.0
@export var return_speed := 600.0   # how fast chain goes back up

var drag := false
var can_interact := false
var start_y := 0.0
var frozen := false


func _ready():
	chain_area.input_pickable = true
	start_y = chain_area.position.y


func enable_chain():
	visible = true
	can_interact = true
	drag = false
	frozen = false
	chain_area.position.y = start_y


func disable_chain():
	can_interact = false
	drag = false
	visible = false


func _process(delta):
	if frozen:
		return
	# If not dragging, smoothly return upward
	if not drag and chain_area.position.y > start_y:
		chain_area.position.y = move_toward(
			chain_area.position.y,
			start_y,
			return_speed * delta
		)


func _input(event):
	if not can_interact:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		drag = false

	if drag and event is InputEventMouseMotion:
		var speed = abs(event.relative.y)

		# Move chain downward
		chain_area.position.y = clamp(
			chain_area.position.y + event.relative.y,
			start_y,
			max_pull_y
		)

		# Spill immediately
		if speed > spill_threshold:
			finish(false)
			return

		# Success
		if chain_area.position.y >= max_pull_y:
			finish(true)
			return


func _on_chain_123_input_event(viewport, event, shape_idx):
	if not can_interact:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		drag = event.pressed


func finish(success: bool):
	can_interact = false
	drag = false
	frozen = true   
	# Wait before telling kitchen (chain still visible here)
	await get_tree().create_timer(disappear_delay).timeout
	frozen = false

	emit_signal("attempt_finished", success)
