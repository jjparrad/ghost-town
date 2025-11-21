extends Node3D

var speed := 3.0
var direction := 1.0
var time_acc := 0.0


func _ready() -> void:
	add_to_group("agents")

func _process(delta) -> void:
	# Mover el objeto
	translate(Vector3.FORWARD * 2 * direction * delta)

	# Acumular tiempo
	time_acc += delta

	# Cada 2 segundos invertir la dirección
	if time_acc >= 2.0:
		direction *= -1
		time_acc = 0.0


func scare() -> void:
	print("AAAAHH!")
