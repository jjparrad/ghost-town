extends CharacterBody3D

@export var speed: float = 2.0
@onready var agent: NavigationAgent3D = $NavigationAgent3D

@export var flee_position: Vector3 = Vector3.ZERO

@export var markerGroup : String

var scared : bool = false

func _physics_process(delta: float) -> void:
	if agent.is_navigation_finished():
		velocity = Vector3.ZERO
		return

	var next_pos = agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()

	velocity = direction * speed
	move_and_slide()

func scare() -> void:
	scared = true
