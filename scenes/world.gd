extends Node3D

var ghost: XRToolsPlayerBody

func _ready():
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		xr_interface.initialize()
		get_viewport().use_xr = true
	else:
		print("OpenXR non disponible")
