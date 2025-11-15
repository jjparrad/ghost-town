extends Node3D

var ghost: Node3D
var time_passed: float = 0.0
var mesh: MeshInstance3D
var is_glowing: bool = false
var is_interacting: bool = false
var base_position: Vector3

@export var interaction_distance: float = 60
@export var float_height := 0.5
@export var float_speed := 2.0
@export var shake_magnitude := 0.1
@export var float_duration := 0.5

func _ready() -> void:
	ghost = Global.ghost
	for child in get_children():
		if child is MeshInstance3D:
			mesh = child
			break

func _process(delta: float) -> void: 
	base_position = self.global_position
	var ghost_position: Vector3 = ghost.global_position
	var distance = (base_position - ghost_position).length()
	if not is_glowing and distance < interaction_distance:
		is_glowing = true
		mesh.set_surface_override_material(0, Global.glow_material)
		
	if is_glowing and distance > interaction_distance:
		is_glowing = false
		mesh.set_surface_override_material(0, Global.base_material)
		
	if not is_interacting and is_glowing and Input.is_action_pressed("interact"):
		time_passed = 0.0
		is_interacting = true
		interact(delta)
		mesh.set_surface_override_material(0, Global.base_material)
		await get_tree().create_timer(3).timeout
		mesh.set_surface_override_material(0, Global.glow_material)
		is_interacting = false

func interact(delta: float) -> void:
	pass
