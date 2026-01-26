extends Node2D

			  
@onready var chain: Node2D = $chain
@onready var chain_button: TextureButton = $UI/Button
@onready var bowl_sprite: Sprite2D = $BowlSprite


@export var cook_time := 2.5

var cups := []
var current_cup_index := 0
const NORMAL_COLOR = Color(1, 1, 1)   # white = unchanged
const READY_COLOR = Color(1, 0.4, 0.4)  # soft red, not pure red


func _ready():
	# Get cups
	cups = [
		$cup1,
		$cup2
	]

	# Initial state
	chain.disable_chain()
	chain_button.disabled = true
	bowl_sprite.modulate = NORMAL_COLOR

	# Listen to chain result
	chain.attempt_finished.connect(_on_chain_attempt_finished)

	# Start first cooking
	start_cooking()



func start_cooking():
	print("Cooking...")
	chain_button.disabled = true
	bowl_sprite.modulate = NORMAL_COLOR

	await get_tree().create_timer(cook_time).timeout

	print("Ready!")
	chain_button.disabled = false
	set_bowl_color(READY_COLOR)



# -----------------------
# BUTTON PRESS
# -----------------------



# -----------------------
# RESULT FROM CHAIN
# -----------------------
func _on_chain_attempt_finished(success: bool):
	if success:
		ProgresBar.add_hot_choco()
	print("SUCCESS" if success else "SPILL")

	# Tell current cup
	cups[current_cup_index].try_fill(success)

	# Hide chain
	chain.disable_chain()

	# Move to next cup
	current_cup_index += 1

	# If another cup remains → cook again
	if current_cup_index < cups.size():
		start_cooking()
	else:
		print("Minigame finished!")


func _on_button_pressed() -> void:
	if current_cup_index >= cups.size():
		print("All cups done")
		return

	chain_button.disabled = true
	chain.enable_chain()
	bowl_sprite.modulate = NORMAL_COLOR

func set_bowl_color(color: Color):
	var tween = create_tween()
	tween.tween_property(bowl_sprite, "modulate", color, 0.3)
