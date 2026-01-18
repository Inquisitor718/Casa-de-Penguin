extends RigidBody2D

@export var k := 0.03
@export var base_radius := 90 # 👈 You tweak this manually

var ring_radius := 0.0
var calm_radius := 0.0

var ring: Area2D


func _ready():
	gravity_scale = 0
	linear_damp = 5
	angular_damp = 2.0
	sleeping = false
	can_sleep = false

	ring = get_tree().get_first_node_in_group("ring")
	if ring:
		ring.radius_changed.connect(_on_radius_changed)

		# Initial sync
		var shape = ring.get_node("CollisionShape2D").shape
		_on_radius_changed(shape.radius * ring.global_scale.x)


func _on_radius_changed(new_radius: float):
	ring_radius = new_radius

	# ✅ Final radius combines your tuning + ring growth
	calm_radius = base_radius + ring_radius


func _integrate_forces(state):
	if ring == null:
		return

	var center = ring.get_node("ForceCenter").global_position
	var pos = state.transform.origin
	var dist = pos.distance_to(center)

	if dist < calm_radius:
		var dir = (pos - center).normalized()

		var t = calm_radius - dist
		var strength = max(30.0, k * t * t)

		state.apply_central_force(dir * strength)
