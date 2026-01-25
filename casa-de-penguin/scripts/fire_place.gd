extends Node2D

@export var coal_scene: PackedScene
@export var coal_count := 30
@export var home: PackedScene

@onready var bar : TextureProgressBar = $TimerBar
@onready var ring = $FireRing
@onready var timer = $Timer
@onready var fire_sprite = $FireSprite
@onready var spawn_area = $SpawnArea/CollisionShape2D
@onready var score_label: Label = $CanvasLayer/ScoreLabel

var score = 0
var elapsed := 0.0 


func _ready():
	randomize()

	timer.start()
	elapsed = 0.0
	bar.value = 100
	bar.queue_redraw()

	ring.score_changed.connect(_on_score_changed)

	var shape := spawn_area.shape as RectangleShape2D
	var extents = shape.extents
	var rect_center = spawn_area.global_position

	var ring_center = ring.get_node("ForceCenter").global_position
	var ring_radius = ring.get_node("CollisionShape2D").shape.radius

	for i in coal_count:
		var coal = coal_scene.instantiate()
		var pos: Vector2

		while true:
			var x = randf_range(rect_center.x - extents.x, rect_center.x + extents.x)
			var y = randf_range(rect_center.y - extents.y, rect_center.y + extents.y)
			pos = Vector2(x, y)

			if pos.distance_to(ring_center) > ring_radius:
				break

		coal.global_position = pos
		add_child(coal)


func _process(delta):
	if elapsed < timer.wait_time:
		elapsed += delta
		var t = clamp(1.0 - elapsed / timer.wait_time, 0.0, 1.0)
		var color := Color.GREEN.lerp(Color.RED, 1.0 - t)
		bar.modulate = color
		bar.value = t * 100.0


func _on_score_changed(count: int):
	var old_score = score
	score = count
	score_label.text = "Score: " + str(score)
	print("Score:", count)
	score_label.scale = Vector2(1.3, 1.3)
	var tween = create_tween()
	tween.tween_property(score_label, "scale", Vector2.ONE, 0.15)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	if score > old_score:
		show_floating_text("+1", ring.get_node("ForceCenter").global_position, Color.GREEN)
	elif score < old_score:
		show_floating_text("-1", ring.get_node("ForceCenter").global_position, Color.RED)


func _on_timer_timeout():
	print("Final score:", score)
	get_tree().paused = true
	await get_tree().create_timer(0.5, true).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://home.tscn")

func show_floating_text(text: String, position: Vector2, color: Color):
	var label := Label.new()
	label.text = text
	label.modulate = color
	label.z_index = 100

	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", color)

	add_child(label)
	label.global_position = position

	var tween := create_tween()
	tween.tween_property(label, "position", label.position + Vector2(0, -40), 0.6)
	tween.tween_property(label, "modulate:a", 0.0, 0.6)

	tween.finished.connect(label.queue_free)
