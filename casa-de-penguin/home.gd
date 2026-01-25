extends Node2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var snowman_button: TextureButton = $"Snowman Button"





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgresBar.Decay_Rate = 0.5
	camera_2d.global_position=Vector2(963,542)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_snowman_button_pressed() -> void:
	var tween_snowman_move := create_tween()
	tween_snowman_move.tween_property(
		camera_2d,
		"global_position",
		Vector2(1633,241),
		0.5
		
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	var tween_snowman_zoom := create_tween()
	tween_snowman_zoom.tween_property(
		camera_2d,
		"zoom",
		Vector2(1922/snowman_button.rect_size.x,1078/snowman_button.rect_size.y),
		0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	


func _on_pond_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Pond.tscn")


func _on_fireplace_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fire_place.tscn")


func _on_kitchen_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/kitchen.tscn")
