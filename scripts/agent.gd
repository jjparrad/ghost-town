extends CharacterBody3D

@export var speed: float = 2.0
@onready var agent: NavigationAgent3D = $NavigationAgent3D

@export var flee_position: Vector3 = Vector3.ZERO

@export var markerGroup : String

@onready var anim := $Character/AnimationPlayer
@onready var scared_sound: AudioStreamPlayer3D = $ScaredSound

var scared : bool = false #scared state (permanent)
var is_scaring: bool = false #just for the scared animation
var iswaiting : bool = false

func _physics_process(delta: float) -> void:
	if is_scaring:
		update_animation()
		return

	if agent.is_navigation_finished():
		velocity = Vector3.ZERO
		update_animation()
		return

	var next_pos = agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()

	if direction.length() > 0.01 and not iswaiting:
		$Character.look_at(global_position - direction, Vector3.UP)

	if not iswaiting:
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector3.ZERO

	update_animation()

func scare() -> void:
	if is_scaring:
		return
	is_scaring = true
	scared = true
	speed *= 1.5
	velocity = Vector3.ZERO
	move_and_slide()
	_play_scare_animation()

func _play_scare_animation() -> void:
	iswaiting = true

	scared_sound.play()
	anim.play("anims/Jump_Full_Short")
	await anim.animation_finished

	iswaiting = false
	is_scaring = false

func play_idle():
	iswaiting = true
	await get_tree().create_timer(2.0).timeout
	iswaiting = false

func update_animation():
	if is_scaring:
		return

	if iswaiting:
		if anim.current_animation != "anims/Idle_A":
			anim.play("anims/Idle_A")
	elif velocity.length() > 0.1:
		if not scared:
			if anim.current_animation != "anims/Walking_A":
				anim.play("anims/Walking_A")
		else:
			if anim.current_animation != "anims/Running_A":
				anim.play("anims/Running_A")
