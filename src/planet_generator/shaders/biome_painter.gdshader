shader_type spatial;
render_mode depth_test_disabled;
#include "res://planet_generator/shaders/includes/unwrap.gdshaderinc"
#include "res://addons/shaderV/rgba/noise/simplex3d.gdshaderinc"

uniform sampler2D SEA_MAP;
uniform vec3 SEA_ID;
uniform int BIOME_CELL_NUMBER;
uniform vec3 BIOME_CELL_IDS[2000];
uniform vec3 BIOME_CELL_POSITIONS[2000];
uniform vec3 NOISE_SHIFT = vec3(0.0);


varying vec3 WS_PIXEL_POS;


void vertex() {
	WS_PIXEL_POS = normalize(VERTEX);
	VERTEX = get_unwrapped_vertex(UV);
}

vec3 get_biome_color(vec3 pos){
	// I almost cried because of this retarded vector conversion
	pos.x = -pos.x;
	pos.y = -pos.y;
	
	float min_dist = 100.0;
	int chosen_id;
	for(int i = 0; i < BIOME_CELL_NUMBER; i++){
		float new_dist = distance(pos, BIOME_CELL_POSITIONS[i]);
		vec3 noise_pos = (NOISE_SHIFT + pos + BIOME_CELL_POSITIONS[i]) * 20.;
		new_dist += _simplex3dNoiseFunc(noise_pos) * 0.1;
		if(new_dist < min_dist){
			min_dist = new_dist;
			chosen_id = i;
		}
	}
	return BIOME_CELL_IDS[chosen_id];
}

void fragment() {
	if(texture(SEA_MAP, vec2(1.) - UV).x > 0.9){
		ALBEDO = SEA_ID;
	} else {
		ALBEDO = get_biome_color(WS_PIXEL_POS);
	}
}