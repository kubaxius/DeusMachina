#include "res://addons/sdf_visual_shader_nodes/3D/capped_cone.gdshaderinc"
#include "res://addons/sdf_visual_shader_nodes/3D/capped_torus.gdshaderinc"


uniform int CONTINENTS_NUMBER;
uniform int SHAPES_PER_CONTINENT;

uniform vec3 TRANSFORM_COMPONENTS[1200];
uniform vec2 SHAPE_DATA[300];


mat4 get_shape_transform(int shape_id){
	mat4 trans = mat4(
			vec4(TRANSFORM_COMPONENTS[4*shape_id], 0.0),
			vec4(TRANSFORM_COMPONENTS[4*shape_id+1], 0.0),
			vec4(TRANSFORM_COMPONENTS[4*shape_id+2], 0.0),
			vec4(TRANSFORM_COMPONENTS[4*shape_id+3], 1.0));
	
	return trans;
}


int get_shape_type(int shape_id){
	return int(SHAPE_DATA[shape_id].x);
}


float get_shape_scale(int shape_id){
	return SHAPE_DATA[shape_id].y;
}


float get_distance_to_shape(vec3 pos, int shape_id){
	mat4 trans = get_shape_transform(shape_id);
	int type = get_shape_type(shape_id);
	float sc = get_shape_scale(shape_id);
	
	switch(type){
		default:
			return sdCappedConeNode(pos, 0.4*sc, 0.3*sc, 0.4*sc, trans);
		case 1:
			return sdCappedTorusNode(pos, 0.4*sc, 0.2*sc, 2.5, trans);
	}
	
}


float get_distance_to_shapes(vec3 ws_pixel_pos){
	float dist = 100.0;
	
	for(int i = 0; i < CONTINENTS_NUMBER * SHAPES_PER_CONTINENT; i++){
		dist = min(get_distance_to_shape(ws_pixel_pos, i), dist);
	}
	
	return dist;
}