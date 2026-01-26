extends Node2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var snowman_button: TextureButton = $"Snowman Button"
@onready var snowfall: GPUParticles2D = $Snowfall

@onready var progress_bar = $CanvasLayer/TextureProgressBar
@onready var table: Marker2D = $table
@onready var table_coco: Marker2D = $table_coco
@onready var macchi: Sprite2D = $macchi

@export var fish_scene: PackedScene
@export var hot_choco: PackedScene
@export var Snowman: PackedScene
@export var kitchen: PackedScene
@export var fire_place: PackedScene
@export var Pond: PackedScene




var dragging = false
@export var fish_spacing : float = 25.0
@export var coco_spacing : float =20.0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	
	place_fish_and_coco()
	ProgresBar.Decay_Rate = 0.1
	camera_2d.global_position=Vector2(963,542)
	if(ProgresBar.zoom==1):
		camera_2d.zoom=Vector2(1922/snowman_button.size.x,1078/snowman_button.size.y)
		camera_2d.global_position=Vector2(1633,241)
		var tween_snowman_move := create_tween()
		var tween_snowman_zoom := create_tween()
		
		tween_snowman_zoom.tween_property(
			camera_2d,
			"zoom",
			Vector2(1,1),
			1
		).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween_snowman_move.tween_property(
			camera_2d,
			"global_position",
			Vector2(963,542),
			0.74
			
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		ProgresBar.add_energy(ProgresBar.points*0.3)
		ProgresBar.zoom=0
		
		place_fish_and_coco()
		ProgresBar.Decay_Rate = 0.1
	else:
		camera_2d.global_position=Vector2(963,542)
		place_fish_and_coco()
		ProgresBar.Decay_Rate = 0.1


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass



func place_fish_and_coco():

	# Clear previous fish
	for child in table.get_children():
		child.queue_free()

	# Clear previous coco
	for child in table_coco.get_children():
		child.queue_free()

	# Spawn fish (max 4 automatically)
	for i in range(ProgresBar.fish_count):
		var fish_instance = fish_scene.instantiate()
		table.add_child(fish_instance)
		fish_instance.global_position = table.global_position + Vector2(i * fish_spacing, 0)
		print("added fish")

	# Spawn hot coco
	for i in range(ProgresBar.hot_choco):
		var choco_instance = hot_choco.instantiate()
		table_coco.add_child(choco_instance)
		choco_instance.global_position = table_coco.global_position + Vector2(i * coco_spacing, 0)
		print("added hot choco")


#----feeding logic

func _on_texture_button_2_pressed() -> void:
	ProgresBar.add_energy(5.0)
	
	print(ProgresBar.Current_Energy)


#lol



func _on_snowman_button_pressed() -> void:
	var tween_snowman_move := create_tween()
	var tween_snowman_zoom := create_tween()
	
	tween_snowman_zoom.tween_property(
		camera_2d,
		"zoom",
		Vector2(1922/snowman_button.size.x,1078/snowman_button.size.y),
		1
	).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween_snowman_move.tween_property(
		camera_2d,
		"global_position",
		Vector2(1633,241),
		0.74
		
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween_snowman_zoom.finished
	get_tree().change_scene_to_file("res://Scenes/Snowman.tscn")
	


func _on_pond_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/home_to_pond_trans.tscn")

func _on_fireplace_pressed() -> void:
	var transition_scene = preload("res://Scenes/Fireplace_Transition.tscn")
	
	# 2. Uska actual instance banao (Ye step missing tha)
	var transition_instance = transition_scene.instantiate()
	
	# 3. Isko "Root" mein add karo, taaki Scene change hone par ye delete na ho
	get_tree().root.add_child(transition_instance)
	
	# 4. Ab function call karo (Make sure function ka naam wahi ho jo script me hai)
	# Humne pichle steps me iska naam "change_scene" rakha tha.
	# Agar aapne rename karke "play_transition" kar diya hai, toh wahi use karein.
	transition_instance.change_scene("res://Scenes/fire_place.tscn")


func _on_kitchen_pressed() -> void:
	var transition_scene = preload("res://Scenes/cocoa_splash.tscn").instantiate()
	get_tree().current_scene.add_child(transition_scene)
	transition_scene.play_transition("res://Scenes/kitchen.tscn")
	
