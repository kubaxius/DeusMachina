## Planet/Point ##
class_name PlanetPoint extends Node3D

var planet: Planet

var height: float
var shore_val: float
var is_sea := false

var up_tilt = TiltValues.new(self)

var down_tilt = TiltValues.new(self)

var no_tilt = TiltValues.new(self)

var position_3d: Vector3:
	get:
		return position
	set(pos):
		position = pos

var position_stereo: Vector2:
	get:
		return GlobeTools.vector3_to_stereo(position)
	set(pos):
		position = GlobeTools.stereo_to_vector3(pos)

var position_uv: Vector2:
	get:
		return GlobeTools.vector3_to_uv(position_3d)

func _init(p_pos:Vector3, p_planet: Planet):
	position = p_pos.normalized()
	planet = p_planet


func _to_string():
	var string = ""
	string += "Pos 3D:  " + str(position_3d) + "\n"
	string += "Pos Str: " + str(position_stereo) + "\n"
	string += "Pos UV:  " + str(position_uv) + "\n"
	string += "Height:  " + str(height) + "\n"
	string += "Is sea:  " + str(is_sea) + "\n"
	
	return string
