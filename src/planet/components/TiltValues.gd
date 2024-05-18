class_name TiltValues extends Node

var parent: PlanetPoint

var relative_sun_tilt = 0
var sun_direction :
	get:
		return Vector3(1, 0, 0).rotated(Vector3(0, 0, 1), relative_sun_tilt)

# HACK: these should probably be calculated with shader
var day_length : get = _get_day_length
var sunlight_amount : get = _get_sunlight_amount_at_noon

var humidity = 0.5

func _init(p_parent):
	parent = p_parent


func _get_dist_to_a_plane(point: Vector3, normal: Vector3):
	point = point.normalized()
	normal = normal.normalized()
	var step1 = point * normal
	var step2 = step1.x + step1.y + step1.z
	var step3 = normal * normal
	var step4 = sqrt(step3.x + step3.y + step3.z)
	var dist_to_a_plane = step2/step4

	return dist_to_a_plane


# First, we get the circle representing latitude and plane representing
# night and day. Then, we calculate arc length created by dividing the circle
# with the arc, and finally we return what part of the circle it is.
func _get_day_length():
	var point = parent.position_3d
	var sun_direction = Vector3(1, 0, 0).rotated(Vector3(0, 0, 1), relative_sun_tilt)
	
	# latitude of point
	var circle_pos = Vector3(0.0, point.y, 0.0)
	
	# get distance from latitude center to light plane
	# that splits planet into night and day
	var center_to_plane = _get_dist_to_a_plane(circle_pos, sun_direction.normalized())
	var day_longer_than_night = center_to_plane < 0.0
	# drop the sign, since we don't need it anymore
	center_to_plane = abs(center_to_plane)
	
	var radius = Vector2(circle_pos.x, circle_pos.z).distance_to(Vector2(point.x, point.z))
	
	# calculate angle only if plane intersects latitude circle
	var angle_of_smaller_arc = 0.0
	if(center_to_plane < radius):
		angle_of_smaller_arc = 2.0 * acos(center_to_plane/radius)
	
	if(day_longer_than_night):
		return 1.0 - angle_of_smaller_arc/TAU
	
	return angle_of_smaller_arc/TAU


func _get_sunlight_amount_at_noon():
	var point = parent.position_3d
	var angle_to_xz_plane = PI/2.0 - acos(point.dot(Vector3(0.0, 1.0, 0.0)))
	var sun_angle_to_xz_plane = PI/2.0 - acos(-sun_direction.dot(Vector3(0.0, 1.0, 0.0)))
	# we use cos, since the relation of angle to the sun and power recieived
	# is not linear, due to atmosphere
	var signed_amount = cos(2. * angle_to_xz_plane - sun_angle_to_xz_plane)
	var amount = (signed_amount + 1.)/2.
	
	return amount
