extends CharacterBody3D

@export var speed: float = 2.0
@onready var agent: NavigationAgent3D = $NavigationAgent3D

@export var flee_position: Vector3 = Vector3.ZERO

@export var markerGroup : String

@onready var anim := $Character/AnimationPlayer

var scared : bool = false

func _physics_process(delta: float) -> void:
	if agent.is_navigation_finished():
		velocity = Vector3.ZERO
		return

	var next_pos = agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	
	if direction.length() > 0.01:
		$Character.look_at(global_position - direction, Vector3.UP)

	velocity = direction * speed
	move_and_slide()
	update_animation()

func scare() -> void:
	speed = speed * 1.5
	scared = true

	
func update_animation():
	if velocity.length() > 0.1:
		if scared == false :
			if anim.current_animation != "anims/Walking_A":
				anim.play("anims/Walking_A")
		else :
			if anim.current_animation != "anims/Running_A":
				anim.play("anims/Running_A")
