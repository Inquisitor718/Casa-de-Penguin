extends Area2D

signal radius_changed(new_radius: float)
signal score_changed(new_score: int)

@export var min_radius := 120.0
@export var max_radius := 400.0
@export var max_coals_for_full_size := 15

@onready var collision := $CollisionShape2D
@onready var circle := collision.shape as CircleShape2D

var score := 0
var last_radius := 0.0

func _ready():
	add_to_group("ring")
	monitoring = true
	last_radius = circle.radius

	# Use events instead of scanning every frame
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("coal"):
		score += 1
		emit_signal("score_changed", score)

func _on_body_exited(body):
	if body.is_in_group("coal"):
		score -= 1
		emit_signal("score_changed", score)

func get_score() -> int:
	return score

func _process(delta):
	var t = clamp(float(score) / max_coals_for_full_size, 0.0, 1.0)
	var target_radius = lerp(min_radius, max_radius, t)

	circle.radius = lerp(circle.radius, target_radius, 0.1)

	if abs(circle.radius - last_radius) > 0.5:
		last_radius = circle.radius
		emit_signal("radius_changed", circle.radius)
