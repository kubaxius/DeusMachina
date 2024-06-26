shader_type spatial;

#include "res://planet_generator/shaders/includes/unwrap.gdshaderinc"
#include "res://planet_generator/shaders/includes/multi_shape_lib.gdshaderinc"


uniform vec3 PLANET_POSITION = vec3(0.0);
uniform float SEA_LEVEL = 0.2;
uniform vec3 NOISE_SHIFT = vec3(0.0);

uniform int MODE = 0;
instance uniform bool UNWRAP = true;

varying vec3 WS_PIXEL_POS;


// ONLY FOR TESTING
vec3 get_color(float height){
	vec3 color;
	
	if(height > SEA_LEVEL){
		color = vec3(0.0, 1.0, 0.0);
		float north_cape_bounds = 0.95 - (0.1 * _simplex3dNoiseFunc(WS_PIXEL_POS * 7.0));
		float south_cape_bounds = -0.9 + (0.1 * _simplex3dNoiseFunc(WS_PIXEL_POS * 7.0));
		if(WS_PIXEL_POS.y > north_cape_bounds || WS_PIXEL_POS.y < south_cape_bounds){
			color = vec3(1.0, 1.0, 1.0);
		}
	} else {
		color = vec3(0.0, 0.0, 1.0);
	}
	
	// HEIGHT TEST //
	float test = 1.0;
	
	if(height < -test){
		color = vec3(0.0, 0.0, 0.8);
	}
	if(height > test){
		color = vec3(0.0, 0.8, 0.0);
	}
	
	return color;
}


void vertex(){
	WS_PIXEL_POS = normalize(VERTEX - PLANET_POSITION);
	if(UNWRAP){
		VERTEX = get_unwrapped_vertex(UV);
	}
}


void fragment() {
	
	switch(MODE){
		case 0:
			ALBEDO = get_color(get_height(WS_PIXEL_POS, NOISE_SHIFT));
			break;
		case 1:
			ALBEDO = vec3(get_sea_value(WS_PIXEL_POS, NOISE_SHIFT, SEA_LEVEL));
			break;
		case 2:
			ALBEDO = vec3(get_height(WS_PIXEL_POS, NOISE_SHIFT));
			break;
	}
	
}