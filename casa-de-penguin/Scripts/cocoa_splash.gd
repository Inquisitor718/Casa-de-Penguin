extends CanvasLayer
@onready var cocoa: ColorRect = $Cocoa


var time := 0.0

func _ready():
	hide()  # hide initially

func _process(delta):
	time += delta
	cocoa.material.set("shader_parameter/time", time)

func play_transition(next_scene: String):
	show()
	cocoa.material.set("shader_parameter/fill", 0.0)

	var tween = create_tween()

	# 1️⃣ Chocolate fills
	tween.tween_property(
		cocoa.material,
		"shader_parameter/fill",
		1.0,
		1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# 2️⃣ Change scene at full fill
	tween.tween_callback(func():
		get_tree().change_scene_to_file(next_scene)
	)

	# 3️⃣ Chocolate drains
	tween.tween_property(
		cocoa.material,
		"shader_parameter/fill",
		0.0,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# 4️⃣ Hide transition
	tween.tween_callback(hide)
