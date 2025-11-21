extends CharacterBody3D

@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D


var target_pos: Vector3
var has_target: bool = false
@export var speed : float = 3.0

func _ready() -> void:
	add_to_group("agents")
	has_target = true
	target_pos = Vector3(0.0,0.0,0.0)
	

func _physics_process(delta: float) -> void:
	if has_target:
		nav_agent.target_position = target_pos
		var next_path_pos := nav_agent.get_next_path_position()
		var direction := global_position.direction_to(next_path_pos)
		velocity= direction * speed
		
		if nav_agent.is_navigation_finished():
			has_target = false
			velocity = Vector3.ZERO
	
		var ROTATION_SPEED = 4
		var target_rotation := direction.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
		if abs(target_rotation - rotation.y) > deg_to_rad(60):
			ROTATION_SPEED = 20
		rotation.y = move_toward(rotation.y, target_rotation, delta * ROTATION_SPEED)
	move_and_slide()


func scare() -> void:
	print("oui oui baguette!")
