extends Node2D

@onready var table: Marker2D = $table
@onready var table_coco: Marker2D = $table_coco


@export var fish_scene: PackedScene
@export var hot_choco: PackedScene
@export var room: PackedScene
@export var room2: PackedScene
@export var room3: PackedScene
@export var room4: PackedScene
@export var snowman: PackedScene
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(room)


func _on_test_button_pressed() -> void:
	print("Hello world.2")


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


func _on_kitchen_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(kitchen)


func _on_lawn_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(snowman)



func _on_fire_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(fire_place)


func _on_pond_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(Pond)
