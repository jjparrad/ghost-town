extends CharacterBody3D

@export var wander_direction : Node3D

const SPEED = 2

func _physics_process(delta: float) -> void:
	velocity = wander_direction.direction * SPEED
	move_and_slide()
