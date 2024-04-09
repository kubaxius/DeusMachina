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


static func break_transform_into_vectors(trans: Transform3D) -> Array:
	var ret = []
	ret.append(trans.basis.x)
	ret.append(trans.basis.y)
	ret.append(trans.basis.z)
	ret.append(trans.origin)
	return ret
