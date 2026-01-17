extends RigidBody2D
@onready var coal: RigidBody2D = $"."

@export var k := 5  #spring constant
@export var calm_radius := 75.0

var ring: Area2D
var max_acceleration := 0.01  # start with 5, tune lower for heavier feel

func _ready():
	gravity_scale = 0
	linear_damp = 5
	angular_damp = 2
	sleeping = false
	can_sleep = false

	ring = get_tree().get_first_node_in_group("ring")
	if ring:
		ring.radius_changed.connect(_on_radius_changed)
		_on_radius_changed(ring.get_node("CollisionShape2D").shape.radius)

func _on_radius_changed(new_radius: float):
	calm_radius = new_radius

func _integrate_forces(state):
	var vel_before: Vector2 = state.linear_velocity

	# --- APPLY FORCES FIRST ---
	if ring != null:
		var center = ring.get_node("ForceCenter").global_position
		var pos = global_position
		var dist = pos.distance_to(center)

		if dist < calm_radius:
			var dir = (pos - center).normalized()
			var strength = k * (calm_radius-dist)
			state.apply_central_force(dir * strength)
			print(strength)

	# --- NOW CLAMP ACCELERATION ---
	#var vel_after: Vector2 = state.linear_velocity
	#var delta_v: Vector2 = vel_after - vel_before

	#if delta_v.length() > max_acceleration:
		#state.linear_velocity = vel_before + delta_v.normalized() * max_acceleration

	# --- OPTIONAL: gentle drift slowdown ---
	#state.linear_velocity *= 0.99
