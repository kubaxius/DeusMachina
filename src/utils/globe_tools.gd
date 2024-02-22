extends Node


# Sphere has to be centered at (0, 0, 0)
static func vector3_to_stereo(point: Vector3) -> Vector2:
	point = point.normalized()
	var x = point.x/(1-point.z)
	var y = point.y/(1-point.z)
	
	return Vector2(x, y)


static func stereo_to_vector3(point: Vector2, radius := 1) -> Vector3:
	var div = 1 + pow(point.x, 2) + pow(point.y, 2)
	var x = 2 * point.x / div
	var y = 2 * point.y / div
	var z = (pow(point.x, 2) + pow(point.y, 2) - 1) / div
	return Vector3(x, y, z) * radius


static func array_vector3_to_stereo(arr: Array) -> Array:
	var return_array = []
	for point in arr:
		return_array.append(vector3_to_stereo(point))
	return return_array


static func array_stereo_to_vector3(arr: Array, radius := 1) -> Array:
	var return_array = []
	for point in arr:
		return_array.append(stereo_to_vector3(point, radius))
	return return_array
