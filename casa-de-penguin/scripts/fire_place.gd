extends Node2D

@export var coal_scene: PackedScene
@export var coal_count := 30

@onready var ring = $FireRing
@onready var timer = $Timer
@onready var fire_sprite = $FireSprite
@onready var spawn_area = $SpawnArea/CollisionShape2D
@onready var score_label: Label = $CanvasLayer/ScoreLabel
var score = 0
func _ready():
	randomize()

	# Listen to score changes instead of polling
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

	timer.start()

func _on_score_changed(count: int):
	score = count
	score_label.text = "Score: " + str(score)
	print("Score:", count)


func _on_timer_timeout():
	print("Final score:", ring.get_score())
	get_tree().paused = true
	await get_tree().create_timer(0.5, true).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()
