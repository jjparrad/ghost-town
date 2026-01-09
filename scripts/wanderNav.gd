extends Node3D

var group_name: String
@export var speed: float = 3.5
@export var arrive_distance: float = 1.5

@onready var agent: NavigationAgent3D = get_parent().get_node("NavigationAgent3D")
@onready var owner_node: Node3D = get_parent()

var positions: Array[Marker3D]
var temp_positions: Array[Marker3D]
var current_position: Marker3D
var waiting: bool = false

var flee_position: Vector3 = Vector3.ZERO

func _ready() -> void:
	group_name = owner_node.markerGroup
	var nodes := get_tree().get_nodes_in_group(group_name)
	positions = []
	for n in nodes:
		if n is Marker3D:
			positions.append(n)
		else:
			push_warning("%s n'est pas un Marker3D" % n.name)

	_get_positions()
	_set_next_target()
	
func _physics_process(delta: float) -> void:
	if owner_node.scared:
		flee_position = owner_node.flee_position
		if agent.target_position != flee_position:
			agent.target_position = flee_position
		return

	if agent.is_navigation_finished() and not waiting:
		_wait_and_set_next_target()


func _wait_and_set_next_target() -> void:
	waiting = true
	owner_node.play_idle()
	_set_next_target()
	waiting = false


func _get_positions():
	temp_positions = positions.duplicate()
	temp_positions.shuffle()
	
func _set_next_target():
	if temp_positions.is_empty():
		_get_positions()

	current_position = temp_positions.pop_front()
	agent.target_position = current_position.global_position
