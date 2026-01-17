extends Node2D
@export var a : Vector2 = Vector2(870,0)
@export var b : Vector2 = Vector2(870,500)

var drag=false
var lastposition = Vector2.ZERO
var dragvel = Vector2.ZERO
var velocity = 500
var istimeout = 0
var startposn = 0
var endposn = 0
var starttime = 0
var endtime = 0
var timer = Timer.new()
@onready var chain_123: Area2D = $Chain123



func _ready() -> void:
	chain_123.input_pickable = true

func _process(delta: float) -> void:
	if drag:
		var mouseposn = get_global_mouse_position()
		var linedirn = (b-a).normalized()
		var projected = a + linedirn*((mouseposn - a).dot(linedirn))
		projected = clamp_point_to_segment(projected,a,b)
		dragvel = (startposn - endposn) / (endtime - starttime)
		position = projected
		lastposition = projected
	if chain_123.global_position.y < 130:
		chain_123.global_position.y = 130
		istimeout = 0
	if istimeout == 1:
		chain_123.global_position.y-= velocity*delta
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			istimeout = 0
			drag  = true
			start()
			startposn = chain_123.global_position.y
			lastposition = position
		
		
		else:
			drag = false
			stop()
			endposn = chain_123.global_position.y
			#await get_tree().create_timer(0.5).timeout
			istimeout = 1
			_on_drag_release()
		
func _on_drag_release():
	print("Drag velocity :", dragvel)
	
func clamp_point_to_segment (p: Vector2, vara: Vector2, varb: Vector2):
	var t = (p-vara).dot(varb-vara)/(varb-vara).length_squared()
	t = clamp(t,0,1)
	return vara + (varb-vara)*t

func start():
		starttime = Time.get_ticks_msec() / 10000.0
		
func stop():
	endtime = Time.get_ticks_msec()/10000.0
