extends Node3D

var ghost: Node3D
var time_passed: float = 0.0
var mesh: MeshInstance3D
var is_glowing: bool = false
var is_interacting: bool = false
var base_position: Vector3

@export var interaction_distance: float = 10
@export var interaction_timeout := 2.5

func _ready() -> void:
	ghost = Global.ghost
	for child in get_children():
		if child is MeshInstance3D:
			mesh = child
			break

func _process(_delta: float) -> void: 
	base_position = self.global_position
	var distance = self.global_position.distance_to(ghost.global_position)

	if is_interacting:
		return
		
	if not is_glowing and distance < interaction_distance:
		is_glowing = true
		mesh.set_surface_override_material(0, Global.glow_material)
		
	if is_glowing and distance > interaction_distance:
		is_glowing = false
		mesh.set_surface_override_material(0, Global.base_material)
		
	if not is_interacting and is_glowing and Input.is_action_pressed("interact"):
		is_glowing = false
		interact()

func interact() -> void:
	is_interacting = true
	mesh.set_surface_override_material(0, Global.base_material)
	var anim_player = $AnimationPlayer
	anim_player.play("interact")
	await get_tree().create_timer(interaction_timeout).timeout
	is_interacting = false
