## Planet/Triangle ##
class_name PlanetTriangle extends Node3D

var depth: int
var max_depth: int
var is_center: bool

var a: PlanetPoint
var b: PlanetPoint
var c: PlanetPoint

var center:PlanetPoint
var side_ang_length = {}

var children_triangles = []


func _init(p_a:PlanetPoint, p_b:PlanetPoint, p_c:PlanetPoint, p_max_depth = 0, p_depth = 0, p_is_center = false):
	self.a = p_a
	self.b = p_b
	self.c = p_c
	self.max_depth = p_max_depth
	self.depth = p_depth
	self.is_center = p_is_center
	_calculate_center()
	_calculate_side_angular_length()
	_generate_children_if_not_last_level()


func _calculate_center():
	var ab_center:Vector3 = a.position_3d.lerp(b.position_3d, 0.5)
	center = PlanetPoint.new(ab_center.lerp(c.position_3d, 0.5))


func _calculate_side_angular_length():
	side_ang_length = {
		"ab": a.position_3d.angle_to(b.position_3d),
		"ac": a.position_3d.angle_to(c.position_3d),
		"bc": c.position_3d.angle_to(b.position_3d)
	}


func _generate_children_if_not_last_level():
	if self.depth >= self.max_depth:
		return true
	
	var ab_center = PlanetPoint.new(a.position_3d.slerp(b.position_3d, 0.5))
	var ac_center = PlanetPoint.new(a.position_3d.slerp(c.position_3d, 0.5))
	var bc_center = PlanetPoint.new(b.position_3d.slerp(c.position_3d, 0.5))
	
	children_triangles.append(PlanetTriangle.new(a, ab_center, ac_center, max_depth, depth + 1))
	children_triangles.append(PlanetTriangle.new(b, ab_center, bc_center, max_depth, depth + 1))
	children_triangles.append(PlanetTriangle.new(c, bc_center, ac_center, max_depth, depth + 1))
	children_triangles.append(PlanetTriangle.new(ab_center, bc_center, ac_center, max_depth, depth + 1, true))


func _get_single_side_args_for_arc_drawing(v1:Vector3, v2:Vector3, length):
	var bas = Basis.IDENTITY
	var rotation_axis = v1.cross(v2).normalized()
	
	bas.x = v1
	bas.z = rotation_axis
	bas.y = v1.rotated(rotation_axis, PI/2)
	bas = bas.orthonormalized()
	bas = bas.scaled(Vector3(1.005,1.005,1.005))
	
	return [Vector3.ZERO, bas, 0, length]


func is_point_inside(point:PlanetPoint) -> bool:
	if point.position_3d.angle_to(a.position_3d) > side_ang_length:
		return false
	if point.position_3d.angle_to(b.position_3d) > side_ang_length:
		return false
	if point.position_3d.angle_to(c.position_3d) > side_ang_length:
		return false
	return true


func get_args_for_arc_drawing():
	var arcs = []
	
	if is_center:
		arcs.append(_get_single_side_args_for_arc_drawing(a.position_3d, b.position_3d, side_ang_length.ab))
		arcs.append(_get_single_side_args_for_arc_drawing(b.position_3d, c.position_3d, side_ang_length.bc))
		arcs.append(_get_single_side_args_for_arc_drawing(c.position_3d, a.position_3d, side_ang_length.ac))
	
	if not children_triangles.is_empty():
		for child in children_triangles:
			arcs.append_array(child.get_args_for_arc_drawing())
	
	return arcs
