# utils.gd
class_name Utils extends Node


@warning_ignore("shadowed_global_identifier")
static func get_percent(current, max, step = 1):
	return snapped((float(current)/float(max)) * 100, step)


# get_world_3d() and get_viewport()
static func project_camera_ray(camera: Camera3D, world:World3D, viewport:Viewport, length = 2000) -> Dictionary:
	var space_state = world.direct_space_state
	var mouse_position = viewport.get_mouse_position()
	
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_position) * length
	
	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_end))
	return intersection


static func get_random_vector(rng: RandomNumberGenerator) -> Vector3:
	return Vector3(rng.randfn(), rng.randfn(), rng.randfn()).normalized()


## returns transform rotated in random direction 
static func get_randomly_rotated_transform(rng: RandomNumberGenerator) -> Transform3D:
	var trans = Transform3D.IDENTITY
	trans = trans.looking_at(Utils.get_random_vector(rng), Utils.get_random_vector(rng))
	return trans


static func break_transform_into_vectors(trans: Transform3D) -> Array[Vector3]:
	var ret: Array[Vector3] = []
	ret.append(trans.basis.x)
	ret.append(trans.basis.y)
	ret.append(trans.basis.z)
	ret.append(trans.origin)
	return ret


static func get_all_file_paths(path: String) -> Array[String]:
	var file_paths: Array[String] = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var file_path = path + "/" + file_name
		if dir.current_is_dir():
			file_paths += get_all_file_paths(file_path)
		else:
			file_paths.append(file_path)
		file_name = dir.get_next()
	return file_paths 


static func array_shuffle(rng,array):
	for i in array.size():
		var rand_idx = rng.randi_range(0,array.size()-1)
		if rand_idx == i:
			pass
		else:
			var temp = array[rand_idx]
			array[rand_idx] = array[i]
			array[i] = temp
	return array


static func weighted_choice(array: Array, weights: Array, rng: RandomNumberGenerator):
	assert(array.size() == weights.size())
	
	var sum:float = 0.0
	for val in weights:
		sum += val
	
	var normalizedWeights = []
	
	for val in weights:
		normalizedWeights.append(val / sum)
	
	var rnd = rng.randf()
	
	var i = 0
	var summer:float = 0.0
	
	for val in normalizedWeights:
		summer += val
		if summer >= rnd:
			return array[i]
		i += 1


static func color_to_vec3(color: Color) -> Vector3:
	return Vector3(color.r, color.g, color.b)
