shader_type spatial;
render_mode depth_test_disabled;

#include "res://planet_generator/shaders/includes/multi_shape_lib.gdshaderinc"

uniform int MAX_STEPS = 1000;
uniform float MAX_DIST = 100.0;
uniform float SURF_DIST = 0.1;

uniform float alpha = 0.9;


float GetDistance(vec3 p, mat4 transform){
	//vec3 np = vec3(p.x, -p.y, p.z);
	transform[0] = - transform[0];
	transform[1] = - transform[1];
	transform[2] = - transform[2];
	vec3 np = (transform * vec4(p, 1.0)).xyz;
	return get_distance_to_shapes(p);
}

vec3 GetNormal(vec3 p, mat4 transform){
	float dist = GetDistance(p, transform);
	vec2 dev = vec2(0.01, 0.0);
	vec3 normal = dist - vec3(
		GetDistance(p - dev.xyy, transform),
		GetDistance(p - dev.yxy, transform),
		GetDistance(p - dev.yyx, transform));
	return normalize(normal);
}

float RayMarch(vec3 ray_origin, vec3 ray_direction, mat4 transform) {
	float dist = 0.0;
	
	for(int i = 0; i < MAX_STEPS; i++){
		vec3 pos = ray_origin + (ray_direction * dist);
		
		// Don't show parts of shapes inside planet
		if(length(pos) < 1.0){return 1000.0;}
		
		float current_dist = GetDistance(pos, transform);
		dist += current_dist;
		if(dist > MAX_DIST || current_dist < SURF_DIST) break;
	}
	return dist;
}

varying vec3 WS_PIXEL_POS;
void vertex() {
	WS_PIXEL_POS = normalize(VERTEX);
}


void fragment() {
	mat4 trans = inverse(MODEL_MATRIX);
	vec3 ws_pixel_pos = ((INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz);
	vec3 ray_origin = CAMERA_POSITION_WORLD;
	vec3 ray_direction = normalize(ray_origin - ws_pixel_pos);
	
	float dist_traveled = RayMarch(ray_origin, ray_direction, trans);
	
	ALBEDO = vec3(1., 0., 0.);
	if(dist_traveled < MAX_DIST){
		ALPHA = alpha;
	}else{
		ALPHA = 0.0;
	}
	NORMAL = GetNormal(ray_origin + ray_direction * dist_traveled, trans);
}