extends Node2D

@export var fish_interval = 6.0
@export var reel_interval = 2.0
var IsFish = false
@onready var rod: AnimatedSprite2D = $AnimatedSprite2D
@onready var reel: TextureProgressBar = $reel

func _ready() -> void:
	for i in range(4):
		await get_tree().create_timer(fish_interval).timeout
		fish_on_hook()


func _process(delta: float) -> void:
	reel.value -= 5.0 * delta


func fish_on_hook():
	print("fish on hook")
	IsFish = true
	rod.play("default")
	await get_tree().create_timer(reel_interval).timeout
	IsFish = false
	reel.value = 0

func _on_texture_button_pressed() -> void:
	if IsFish:
		print("reeling in")
		reel.value += 12.5
		if reel.value >= 100:
			print("fish caught")
			IsFish = false
			reel.value = 0
