extends Node2D

@export var can_swap := false   # true for cup1, false for cup2
@export var swap_delay := 0.4
@export var swap_duration := 0.6

@onready var other_cup: Node2D

var attempted := false
var filled := false
var swapping := false

func _ready():
	if name == "cup1":
		other_cup = get_parent().get_node("cup2")
	else:
		other_cup = get_parent().get_node("cup1")

func try_fill(success: bool):
	# Only one attempt per cup
	if attempted:
		return

	attempted = true
	filled = success

	if success:
		print(name, "SUCCESS")
	else:
		print(name, "SPILLED")

	# 🔁 Swap always for cup1, no matter success or fail
	if can_swap:
		do_swap()


func do_swap():
	if swapping:
		return

	swapping = true

	await get_tree().create_timer(swap_delay).timeout

	var pos1 = position
	var pos2 = other_cup.position

	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "position", pos2, swap_duration)
	tween.parallel().tween_property(other_cup, "position", pos1, swap_duration)

	tween.finished.connect(func():
		swapping = false
		can_swap = false   # disable further swaps forever
)
