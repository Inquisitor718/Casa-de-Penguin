extends Node2D

@export var room: PackedScene
@export var room2: PackedScene
@export var room3: PackedScene
@export var room4: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(room)


func _on_test_button_pressed() -> void:
	print("Hello world.2")


func _on_texture_button_2_pressed() -> void:
	ProgresBar.add_energy(5.0)
	print(ProgresBar.Current_Energy)


func _on_kitchen_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(room2)


func _on_lawn_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(room3)



func _on_fire_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(room)


func _on_pond_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(room)
