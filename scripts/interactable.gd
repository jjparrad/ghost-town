extends Node3D

# --- Références ---
var ghost: XROrigin3D
var xr_camera: XRCamera3D
var mesh: MeshInstance3D

var Rhand:XRController3D
var Lhand:XRController3D
# --- États ---
var is_glowing: bool = false
var is_interacting: bool = false

# --- Interaction ---
@export var interaction_distance: float = 8.0
@export var interaction_timeout: float = 2.5

# --- Agents proches ---
var near_agents: Array = []

func _ready() -> void:
	# Récupération du mesh
	for child in get_children():
		if child is MeshInstance3D:
			mesh = child
			break
	
	if mesh == null:
		push_error("Interactable: aucun MeshInstance3D trouvé")
		return
	
	#recup hands
	Lhand = Global.leftHand
	if Lhand == null:
		push_error("Interactable: Lhand est null")
		
	Rhand = Global.rightHand
	if Rhand == null:
		push_error("Interactable: Rhand est null")
		
	Lhand.connect("button_pressed",_on_left_button_pressed)
	
	# Récupération du joueur XR
	ghost = Global.ghost
	if ghost == null:
		push_error("Interactable: Global.ghost est null")
		return
	
	# Récupération de la caméra XR
	xr_camera = ghost.get_node_or_null("XRCamera3D")
	if xr_camera == null:
		push_error("Interactable: XRCamera3D introuvable")
		return
	
	# Connexion de l'Area3D
	if has_node("Area3D"):
		$Area3D.body_entered.connect(_on_body_entered)
		$Area3D.body_exited.connect(_on_body_exited)
	else:
		push_error("Interactable: Area3D manquante")

func _process(_delta: float) -> void:
	if xr_camera == null or mesh == null:
		return
	
	if is_interacting:
		return
	
	var distance := global_position.distance_to(xr_camera.global_position)
	

	# Activation du glow
	if distance <= interaction_distance and not is_glowing:
		print(distance)
		_enable_glow()

	# Désactivation du glow
	elif distance > interaction_distance and is_glowing:
		_disable_glow()

	# Interaction
	if is_glowing and Input.is_action_just_pressed("vr_interact"):
		interact()

func _enable_glow() -> void:
	is_glowing = true
	mesh.set_surface_override_material(0, Global.glow_material)

func _disable_glow() -> void:
	is_glowing = false
	mesh.set_surface_override_material(0, Global.base_material)

func interact() -> void:
	is_interacting = true
	_disable_glow()

	# Animation
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("interact")

	# Effet sur les agents proches
	scare()

	# Cooldown
	await get_tree().create_timer(interaction_timeout).timeout
	is_interacting = false

func scare() -> void:
	for agent in near_agents:
		if agent.has_method("scare"):
			agent.scare()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("agents"):
		near_agents.append(body)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("agents"):
		near_agents.erase(body)


func _on_left_button_pressed(button_name: String) -> void:
	if(button_name == "ax_button" and is_glowing):
		interact()
	
