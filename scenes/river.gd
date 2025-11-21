extends Node3D

@onready var anim := $AnimationPlayer

func _ready():
	anim.play("move_river")
