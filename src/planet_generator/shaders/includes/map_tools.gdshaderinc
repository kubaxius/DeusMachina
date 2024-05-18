
// works only on a sphere with equirectangular projection
vec2 get_uv_from_pos(vec3 pos){
	float x = pos.x;
	float y = pos.y;
	float z = pos.z;
	
	float theta;
	if(x > 0.){
		theta = PI + acos(dot(vec2(0.0, -1.0), normalize(vec2(x, z))));
	}else{
		theta = acos(dot(vec2(0.0, 1.0), normalize(vec2(x, z))));
	}
	float u = theta/TAU;
	float v = 1. - acos(y)/PI;
	
	return vec2(u, v);
}


vec3 rodrigues_rotation(vec3 vector, vec3 axis, float angle){
	axis = normalize(axis);
	vec3 step1 = vector * cos(angle);
	vec3 step2 = cross(axis, vector) * sin(angle);
	vec3 step3 = axis * dot(axis, vector) * (1. - cos(angle));
	return step1 + step2 + step3;
}


vec3 move_vector_across_globe(vec3 pos, float ang_dist, float angle){
	vec3 north_pole = vec3(0., 1., 0.);
	vec3 rotation_axis = normalize(cross(pos, north_pole));
	rotation_axis = rodrigues_rotation(rotation_axis, pos, angle);
	vec3 new_pos = rodrigues_rotation(pos, rotation_axis, ang_dist);
	return new_pos;
}