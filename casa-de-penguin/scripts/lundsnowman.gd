extends Node2D

@export var zoom:=0
@export var points: int
@export var home: PackedScene
@onready var snowman_pos: Marker2D = $snowman_pos
@onready var snowfall: GPUParticles2D = $Snowfall


@export var home: PackedScene
@onready var timer = $Timer
@onready var progress_bar = $CanvasLayer/TextureProgressBar

var timeout := 0
var target_rot := 0.0
var duration := 0.12
var holding := false


func _ready() -> void:
	target_rot = snowman_pos.rotation
	snowfall.preprocess = 100
	snowfall.emitting = true
	await get_tree().create_timer(15.0).timeout
	timeout = 1

	points = floor(100.0 * ((1.5 - min(1.5, abs(snowman_pos.rotation))) / 1.5))
	print(points)

func _rotate(step: float) -> void:
	target_rot = snowman_pos.rotation
	target_rot = clamp(target_rot + step, -1.5, 1.5)

	var tween := create_tween()
	tween.tween_property(
		snowman_pos,
		"rotation",
		target_rot,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _process(delta: float) -> void:
	progress_bar.max_value= timer.wait_time
	progress_bar.value=timer.time_left
	
	var wind := -0.3
	progress_bar.max_value= timer.wait_time
	progress_bar.value=timer.time_left
	if timeout == 0:
		snowman_pos.rotation = clamp(snowman_pos.rotation + wind * delta, -1.5, 1.5)

		holding = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) \
			or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)

		if holding:
			if get_global_mouse_position().x > snowman_pos.global_position.x:
				_rotate(-0.02)
			else:
				_rotate(0.02)


func _on_timer_timeout() -> void:
	zoom=1
	get_tree().change_scene_to_packed(home)
