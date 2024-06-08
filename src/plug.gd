extends "res://addons/gd-plug/plug.gd"

func _plugging():
	
	# qol
	plug("NoctemCat/BottomPanelShortcuts")
	
	# planning
	plug("HolonProduction/godot_kanban_tasks", {"exclude": ["addons/standalone_tools"]})
	plug("OrigamiDev-Pete/TODO_Manager")
	
	# debug
	# plug("russmatney/log.gd")
	plug("Ericdowney/SignalVisualizer")
	
	# shaders
	plug("arkology/ShaderV")
	plug("paddy-exe/GodotVisualShader-Extras")
	plug("kubaxius/SDFAddon")
	plug("Zylann/godot_atmosphere_shader")
	
	# state machine
	plug("derkork/godot-statecharts")
	
	# ico sphere
	plug("MAGGen-hub/Icosphere-Mesh-Godot-Plugin")
