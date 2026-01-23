extends Node2D

@export var Snowman: PackedScene
@export var Pond: PackedScene
@export var Fireplace: PackedScene  
@export var Kitchen: PackedScene  


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_packed(Snowman)


func _on_pond_button_pressed() -> void:
	get_tree().change_scene_to_packed(Pond)


func _on_fireplace_pressed() -> void:
	get_tree().change_scene_to_packed(Fireplace)


func _on_kitchen_pressed() -> void:
	get_tree().change_scene_to_packed(Kitchen)
