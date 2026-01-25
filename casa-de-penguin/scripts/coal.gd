extends RigidBody2D
@onready var coal: RigidBody2D = $"."
@onready var sprite: Sprite2D = $Sprite2D

@export var k := 0.5
@export var base_radius := 90 # 👈 You tweak this manually
@onready var marker_2d: Marker2D = $Marker2D
@onready var hit_sound: AudioStreamPlayer2D = $HitSound

var ring_radius := 0.0
var calm_radius := 0.0
var can_play := true
var ring: Area2D
var heat := 0.0
var base_color: Color
@export var neutral_radius := 50.0

func _ready():
	base_color = sprite.modulate
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
	calm_radius = ring_radius


func _integrate_forces(state):
	if ring == null:
		return
	var center = ring.get_node("ForceCenter").global_position
	var pos = state.transform.origin
	var dist = pos.distance_to(center)

	if dist < calm_radius and dist > neutral_radius:
		var dir = (pos - center).normalized()
#calm_radius - 
		var t = calm_radius - dist
		var strength =  (k) * t

		state.apply_central_impulse(dir * strength)


func _on_body_entered(body):
	if body.name == "Poker" and can_play:
		$HitSound.play()
		can_play = false
		await get_tree().create_timer(0.1).timeout
		can_play = true
	
