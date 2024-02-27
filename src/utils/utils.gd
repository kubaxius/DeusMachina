class_name Utils extends Node


@warning_ignore("shadowed_global_identifier")
static func get_percent(current, max, step = 1):
	return snapped((float(current)/float(max)) * 100, step)


# get_world3d() and get_viewport()
static func project_camera_ray(camera: Camera3D, world:World3D, viewport:Viewport, length = 2000) -> Dictionary:
	var space_state = world.direct_space_state
	var mouse_position = viewport.get_mouse_position()
	
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_position) * length
	
	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_end))
	return intersection
