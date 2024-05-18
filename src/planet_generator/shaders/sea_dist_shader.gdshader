shader_type spatial;
#include "res://planet_generator/shaders/includes/unwrap.gdshaderinc"
#include "res://planet_generator/shaders/includes/map_tools.gdshaderinc"

uniform sampler2D SEA_MAP;

varying vec3 WS_PIXEL_POS;

void vertex(){
	WS_PIXEL_POS = normalize(VERTEX);
	VERTEX = get_unwrapped_vertex(UV);
}

const float STEP = 0.005;
const int STEP_NUM = 10;
const int DIRS_TO_CHECK = 32;
float get_dist_to_sea(vec3 pos){
	if(texture(SEA_MAP, get_uv_from_pos(pos)).x > 0.99){
		return 0.;
	}
	for(int i = 1; i <= STEP_NUM; i++){
		float current_sea_val = 0.;
		for(int j = 0; j < DIRS_TO_CHECK; j++){
			vec3 new_pos = move_vector_across_globe(pos, STEP * float(i), float(j) * TAU/float(DIRS_TO_CHECK));
			vec2 new_uv = get_uv_from_pos(new_pos);
			 current_sea_val = max(texture(SEA_MAP, new_uv).x, current_sea_val);
		}
		if(current_sea_val > 0.99){
			return float(i)/float(STEP_NUM);
		}
	}
	return 1.;
}


void fragment(){
	vec3 pos = normalize(WS_PIXEL_POS);
	vec2 uv = get_uv_from_pos(pos);
	float dist_to_sea = get_dist_to_sea(pos);
	
	ALBEDO = vec3(dist_to_sea);
}