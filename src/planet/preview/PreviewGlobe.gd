extends MeshInstance3D

@export var sun_path: NodePath

# set by parent
var planet: Planet:
	set(p):
		planet = p
		setup()

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlanetAthmosphere.sun_path = sun_path


func send_data_to_shaders():
	var mat: ShaderMaterial = get_active_material(0)
	
	var height = planet.get_map(Planet.MapType.HEIGHT)
	height = ImageTexture.create_from_image(height)
	
	var sea = planet.get_map(Planet.MapType.SEA)
	sea = ImageTexture.create_from_image(sea)
	
	mat.set_shader_parameter("HEIGHT_MAP", height)
	mat.set_shader_parameter("SEA_MAP", sea)
	mat.set_shader_parameter("SEA_LEVEL", planet.sea_level)


func setup():
	send_data_to_shaders()
