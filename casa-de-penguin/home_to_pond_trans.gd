extends Node2D
@onready var macchi: Sprite2D = $macchi
@onready var camera_2d: Camera2D = $Camera2D
@onready var snowfall: GPUParticles2D = $Snowfall


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	snowfall.preprocess = 96
	snowfall.emitting = true
	await get_tree().process_frame
	await get_tree().process_frame 
	macchi.global_position=Vector2(-951,546)
	var tween_pond :=create_tween()
	tween_pond.tween_property(
		macchi,
		"global_position",
		Vector2(-11,541),
		0.5
	).set_trans(Tween.TRANS_LINEAR)
	await tween_pond.finished
	var tween_camera :=create_tween()
	tween_camera.tween_property(
		camera_2d,
		"global_position",
		Vector2(-961,542),
		1
	).set_trans(Tween.TRANS_LINEAR)
	await tween_camera.finished
	var tween_pond2 :=create_tween()
	tween_pond2.tween_property(
		macchi,
		"global_position",
		Vector2(955,541),
		0.5
	).set_trans(Tween.TRANS_LINEAR)
	await tween_pond2.finished
	get_tree().change_scene_to_file("res://Scenes/Pond.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
