class_name GlobeTools extends Node


# Sphere has to be centered at (0, 0, 0)
static func vector3_to_stereo(point: Vector3) -> Vector2:
	point = point.normalized()
	var x = point.x/(1-point.z)
	var y = point.y/(1-point.z)
	
	return Vector2(x, y)


static func stereo_to_vector3(point: Vector2, radius: float = 1) -> Vector3:
	var div = 1 + pow(point.x, 2) + pow(point.y, 2)
	var x = 2 * point.x / div
	var y = 2 * point.y / div
	var z = (pow(point.x, 2) + pow(point.y, 2) - 1) / div
	return Vector3(x, y, z) * radius


static func vector3_to_uv(pos: Vector3, mult := Vector3(-1, -1, 1)):
	var x = pos.x * mult.x
	var y = pos.y * mult.y
	var z = pos.z * mult.z
	
	var theta;
	if(x > 0):
		theta = PI + acos(Vector2(0.0, -1.0).dot(Vector2(x, z).normalized()))
	else:
		theta = acos(Vector2(0.0, 1.0).dot(Vector2(x, z).normalized()))
	
	var u = theta/TAU
	var v = 1. - acos(y)/PI
	
	return Vector2(u, v)


static func array_vector3_to_stereo(arr: Array[Vector3]) -> Array[Vector2]:
	var return_array = []
	for point in arr:
		return_array.append(vector3_to_stereo(point))
	return return_array


static func array_stereo_to_vector3(arr: Array[Vector2], radius := 1) -> Array[Vector3]:
	var return_array = []
	for point in arr:
		return_array.append(stereo_to_vector3(point, radius))
	return return_array
