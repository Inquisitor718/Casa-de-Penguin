extends Node


var fish_count: int = 4
var hot_choco: int = 2
var Comfy_Points: int = 0

var MaxEnergy : float= 100.0
var Current_Energy : float = 100.0
var Decay_Rate : float = 0.5 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
#maan le raha hun ki koi variable hai omfy points jo add honge

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Current_Energy -= Decay_Rate * delta


func add_energy(amount: float):
	Current_Energy += amount
	print(Current_Energy)
	if Current_Energy > MaxEnergy:
		Current_Energy = MaxEnergy
	if Current_Energy < 0:
		Current_Energy = 0
