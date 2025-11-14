extends CharacterBody3D

@export var SPEED = 5.0
@export var ROTATION_SPEED := 2.0 

func _process(delta):
	var direction = Vector3.ZERO
	var forward = -global_transform.basis.z
	
	if Input.is_action_pressed("move_forward"):
		direction += forward
	if Input.is_action_pressed("move_back"):
		direction -= forward
	
	if Input.is_action_pressed("move_up"):
		direction += transform.basis.y
	if Input.is_action_pressed("move_down"):
		direction -= transform.basis.y
		
	if Input.is_action_pressed("move_left"):
		rotate_y(ROTATION_SPEED * delta)
	if Input.is_action_pressed("move_right"):
		rotate_y(-ROTATION_SPEED * delta)

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		move_and_collide(direction * SPEED * delta)
