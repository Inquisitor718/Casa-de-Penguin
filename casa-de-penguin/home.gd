extends Node2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var snowman_button: TextureButton = $"Snowman Button"

@onready var table: Marker2D = $table
@onready var table_coco: Marker2D = $table_coco


@export var fish_scene: PackedScene
@export var hot_choco: PackedScene
@export var Snowman: PackedScene
@export var kitchen: PackedScene
@export var fire_place: PackedScene
@export var Pond: PackedScene




var fish= ProgresBar.fish_count
var choco= ProgresBar.hot_choco
var dragging = false
@export var fish_spacing : float = 25.0
@export var coco_spacing : float =20.0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	
	place_fish_and_coco()
	ProgresBar.Decay_Rate = 0.5
	camera_2d.global_position=Vector2(963,542)


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass



func place_fish_and_coco():
	
	for i in range(fish): 
		var fish_instance = fish_scene.instantiate()
		table.add_child(fish_instance)
		
		fish_instance.global_position = (table.global_position+ Vector2(i * fish_spacing, 0))
		print("added fish")
	
	for i in range(choco): 
		var choco_instance = hot_choco.instantiate()
		table_coco.add_child(choco_instance)
		
		choco_instance.global_position = (table_coco.global_position+ Vector2(i * coco_spacing, 0))
		print("added hot choco")

#----feeding logic

func _on_texture_button_2_pressed() -> void:
	ProgresBar.add_energy(5.0)
	
	print(ProgresBar.Current_Energy)




#transition to different rooms
#
#func _on_snowman_button_pressed() -> void:
	#get_tree().change_scene_to_packed(Snowman)
#
#
#func _on_pond_button_pressed() -> void:
	#get_tree().change_scene_to_packed(Pond)
#
#func _on_fireplace_pressed() -> void:
	#get_tree().change_scene_to_packed(fire_place)
#
#func _on_kitchen_pressed() -> void:
	#get_tree().change_scene_to_packed(kitchen)


func _on_snowman_button_pressed() -> void:
	var tween_snowman_move := create_tween()
	var tween_snowman_zoom := create_tween()
	
	tween_snowman_zoom.tween_property(
		camera_2d,
		"zoom",
		Vector2(1922/snowman_button.size.x,1078/snowman_button.size.y),
		0.5
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween_snowman_move.tween_property(
		camera_2d,
		"global_position",
		Vector2(1633,241),
		0.37
		
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween_snowman_zoom.finished
	get_tree().change_scene_to_packed(Snowman)
	
	


func _on_pond_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Pond.tscn")


func _on_fireplace_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fire_place.tscn")


func _on_kitchen_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/kitchen.tscn")
