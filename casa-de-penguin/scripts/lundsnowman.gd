extends Node2D


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
	ProgresBar.zoom=0
	target_rot = snowman_pos.rotation
	snowfall.preprocess = 100
	snowfall.emitting = true
	await get_tree().create_timer(15.0).timeout
	timeout = 1

	ProgresBar.points = floor(100.0 * ((0.7 - min(0.7, abs(snowman_pos.rotation))) / 0.7))
	print(ProgresBar.points)

func _rotate(step: float) -> void:
	target_rot = snowman_pos.rotation
	target_rot = clamp(target_rot + step, -0.7, 0.7)

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
		snowman_pos.rotation = clamp(snowman_pos.rotation + wind * delta, -0.7, 0.7)

		holding = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) \
			or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)

		if holding:
			if get_global_mouse_position().x > snowman_pos.global_position.x:
				_rotate(-0.02)
			else:
				_rotate(0.02)


func _on_timer_timeout() -> void:
	ProgresBar.zoom=1
	get_tree().change_scene_to_file("res://home.tscn")
