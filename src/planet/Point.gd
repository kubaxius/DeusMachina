## Planet/Point ##
class_name PlanetPoint extends Resource

@export var planet: Planet
@export var position_3d: Vector3

var position_stereo: Vector2:
	get:
		return GlobeTools.vector3_to_stereo(position_3d)
	set(pos):
		position_3d = GlobeTools.stereo_to_vector3(pos)

var position_uv: Vector2:
	get:
		return GlobeTools.vector3_to_uv(position_3d)


var height: float
var shore_val: float
var is_sea := false
var biome: Biome

var up_tilt = TiltValues.new(self)

var down_tilt = TiltValues.new(self)

var no_tilt = TiltValues.new(self)


func _init(p_pos:Vector3, p_planet: Planet):
	position_3d = p_pos.normalized()
	planet = p_planet


func _to_string():
	var string = ""
	string += "Pos 3D:  " + str(position_3d) + "\n"
	string += "Pos Str: " + str(position_stereo) + "\n"
	string += "Pos UV:  " + str(position_uv) + "\n"
	string += "Height:  " + str(height) + "\n"
	string += "Is sea:  " + str(is_sea) + "\n"
	string += "Biome:  " + biome.name + "\n"
	
	return string
