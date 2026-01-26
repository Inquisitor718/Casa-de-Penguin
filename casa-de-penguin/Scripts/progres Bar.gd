extends Node
var zoom:=0


var fish_count: int = 4
var hot_choco: int = 0
var Comfy_Points: int = 0


@export var MaxEnergy : float= 100.0
@export var Current_Energy : float = 100.0
var Decay_Rate : float = 0.5 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
#maan le raha hun ki koi variable hai omfy points jo add honge

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var current_scene = get_tree().current_scene
	
	if current_scene == null:
		return
	
	if current_scene.name == "MainMenu": # or current_scene.name == "GameOver":
		GlobalCanvasLayer.hide()
		
	else:
		GlobalCanvasLayer.show()
	
	
	
	Current_Energy -= Decay_Rate * delta * 10
	if Current_Energy <=0 :
		get_tree().change_scene_to_file("res://Scenes/game_over_ui.tscn")


func add_energy(amount: float):
	Current_Energy += amount
	print(Current_Energy)
	if Current_Energy > MaxEnergy:
		Current_Energy = MaxEnergy
	if Current_Energy <= 0:
		Current_Energy = 0
		
func reset_energy():
	Current_Energy = MaxEnergy

func add_hot_choco():
	if hot_choco < 2:
		hot_choco += 1


# optional helper
func reset_hot_choco():
	hot_choco = 0
