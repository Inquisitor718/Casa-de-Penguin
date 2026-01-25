extends Node2D





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgresBar.Decay_Rate = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_snowman_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Snowman.tscn")


func _on_pond_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Pond.tscn")


func _on_fireplace_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fire_place.tscn")


func _on_kitchen_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/kitchen.tscn")
