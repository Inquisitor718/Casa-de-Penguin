extends Node2D


@export var mainscene_transition: PackedScene
@export var spill_thershold := 70.0
var velocity := 500.0

@onready var chain_123: Area2D = $Chain123

var drag := false
var spill := false

func _ready() -> void:
	chain_123.input_pickable = true

func _process(delta: float) -> void:

	if !drag:
		chain_123.position.y = (max(0,chain_123.position.y-velocity * delta))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
		drag = false
		
	if drag and event is InputEventMouseMotion:
		var vel = event.relative.y
		chain_123.position.y = min((max(0,chain_123.position.y+vel)),750)

		if vel > spill_thershold and not spill:
			spill = true
			print("spill")

func _on_chain_123_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			drag = true
			spill = false
		else:
			drag = false
		return
