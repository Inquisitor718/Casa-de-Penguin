extends Node2D

@export var mainscene_transisiton: PackedScene
@export var fish_interval := 6.0      
@export var reel_interval := 5.0     

@export var click_gain := 12.5

# Difficulty tuning
@export var decay_factor := 2
@export var grace_time := 0.12
@export var grace_multiplier := 0.3

var IsFish := false
var decay_block_time := 0.0

@onready var rod: AnimatedSprite2D = $AnimatedSprite2D
@onready var reel: TextureProgressBar = $reel


func _ready() -> void:
	start_fishing_loop()

func start_fishing_loop() -> void:
	while true:
		await get_tree().create_timer(fish_interval).timeout
		await fish_on_hook()

func fish_on_hook() -> void:
	print("fish on hook")

	IsFish = true
	reel.value = 0
	rod.play("default")

	var time_passed := 0.0

	while IsFish and time_passed < reel_interval:
		await get_tree().process_frame
		time_passed += get_process_delta_time()

	IsFish = false
	reel.value = 0
	rod.stop()
	print("fish ended")

func _process(delta: float) -> void:
	if not IsFish:
		return

	var multiplier := 1.0

	if decay_block_time > 0:
		decay_block_time -= delta
		multiplier = grace_multiplier

	if reel.value > 0:
		reel.value -= reel.value * decay_factor * multiplier * delta
		reel.value = max(reel.value, 0)

func _on_texture_button_pressed() -> void:
	if not IsFish:
		return

	reel.value += click_gain
	decay_block_time = grace_time

	if reel.value >= 100:
		print("fish caught!")
		IsFish = false


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_packed(mainscene_transisiton)
