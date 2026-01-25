extends Area2D

signal radius_changed(new_radius: float)
signal score_changed(new_score: int)

@export var min_radius := 150.0
@export var max_radius := 500.0
@export var max_coals_for_full_size := 15
@export var scoring_radius_factor := 0.7   # 🔥 only center area gives points

@onready var force_center: Marker2D = $ForceCenter
@onready var enter_sound: AudioStreamPlayer2D = $EnterSound
@onready var fire_sprite: Sprite2D = $Sprite2D
@onready var sparks: GPUParticles2D = $Sparks

@onready var collision := $CollisionShape2D
@onready var circle := collision.shape as CircleShape2D
@onready var ring: CollisionShape2D = $CollisionShape2D

var base_scale := Vector2(1, 1)
var scale_per_coal := 0.05
var coal_count := 0

var coals_inside: Array = []
var scoring_coals: Array = []

var score := 0
var last_radius := 0.0


func _ready():
	add_to_group("ring")
	monitoring = true
	last_radius = circle.radius

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func get_ring_radius():
	return (ring.shape as CircleShape2D).radius


# ------------------------------------------------
# Only tracking coals + VFX here (NO scoring here)
# ------------------------------------------------
func _on_body_entered(body):
	if body.is_in_group("coal"):
		coals_inside.append(body)
		coal_count += 1
		update_fire_vfx()
		


func _on_body_exited(body):
	if body.is_in_group("coal"):
		coal_count -= 1
		update_fire_vfx()
		coals_inside.erase(body)

		# If coal leaves ring while it was scoring, remove score
		if body in scoring_coals:
			scoring_coals.erase(body)
			score -= 1
			emit_signal("score_changed", score)


# ------------------------------------------------
# Heat + Glow + CENTER-ONLY SCORING
# ------------------------------------------------
func _process(delta):
	var all_coals = get_tree().get_nodes_in_group("coal")

	for coal in all_coals:
		if coal == null:
			continue

		# ----- Heat / glow -----
		var target_heat := 0.0
		if overlaps_body(coal):
			var dist = coal.global_position.distance_to(force_center.global_position)
			var max_dist = get_ring_radius()
			target_heat = 1.0 - clamp(dist / max_dist, 0.0, 1.0)

		coal.heat = lerp(coal.heat, target_heat, delta * 4.0)
		apply_glow(coal)

		# ----- CENTER SCORING -----
		var scoring_radius = get_ring_radius() * scoring_radius_factor
		var distance = coal.global_position.distance_to(force_center.global_position)
		var is_scoring = distance <= scoring_radius

		if is_scoring and coal not in scoring_coals:
			scoring_coals.append(coal)
			score += 1
			enter_sound.play()
			sparks.restart()
			emit_signal("score_changed", score)

		elif not is_scoring and coal in scoring_coals:
			scoring_coals.erase(coal)
			score -= 1
			emit_signal("score_changed", score)


	# ----- Ring growth still based on score -----
	var t = clamp(float(score) / max_coals_for_full_size, 0.0, 1.0)
	var target_radius = lerp(min_radius, max_radius, t)

	circle.radius = lerp(circle.radius, target_radius, 0.1)

	if abs(circle.radius - last_radius) > 0.5:
		last_radius = circle.radius
		emit_signal("radius_changed", circle.radius * global_scale.x)


# ------------------------------------------------
# Fire VFX
# ------------------------------------------------
func update_fire_vfx():
	var target_scale = base_scale + Vector2(scale_per_coal, scale_per_coal) * coal_count

	var tween = create_tween()
	tween.tween_property(fire_sprite, "scale", target_scale, 0.2)

	var brightness = 1.0 + coal_count * 0.05
	fire_sprite.modulate = Color(brightness, brightness, brightness)


# ------------------------------------------------
# Coal glow
# ------------------------------------------------
func apply_glow(coal):
	if not coal.has_node("Sprite2D"):
		return

	var sprite := coal.get_node("Sprite2D") as Sprite2D
	var glow = coal.heat

	sprite.modulate = Color(
		1.0 + glow * 2.0,
		1.0 + glow * 0.6,
		1.0 - glow * 0.4,
		1.0
	)
