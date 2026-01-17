extends Node2D

var IsFish = false
@onready var rod: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(4):
		await get_tree().create_timer(4.0).timeout
		fish_on_hook()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func fish_on_hook():
	print("fish on hook")
	IsFish = true
	rod.play("default")
	await get_tree().create_timer(0.5).timeout
	IsFish = false
	


func _on_texture_button_pressed() -> void:
	if IsFish:
		print("fish caught")
		
		IsFish = false
