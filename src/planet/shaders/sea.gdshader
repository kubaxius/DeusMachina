shader_type spatial;
render_mode sss_mode_skin;
#include "res://planet_generator/shaders/includes/map_tools.gdshaderinc"
#include "res://addons/shaderV/rgba/noise/simplex4d.gdshaderinc"

varying vec3 WS_POS;

void vertex() {
	WS_POS = normalize(VERTEX);
}

uniform float WAVE_STRENGTH = 1.;
uniform float ANG_STEP = 0.01;
uniform float NOISE_AMP = 10.;
uniform vec3 WATER_COLOR : source_color = vec3(0.0, 0.05, 0.3);
void fragment() {
	vec3 p1 = move_vector_across_globe(WS_POS, ANG_STEP, 0.0);
	vec3 p2 = move_vector_across_globe(WS_POS, ANG_STEP, PI/3.0);
	vec3 p3 = move_vector_across_globe(WS_POS, ANG_STEP, 2.0*PI/3.0);
	float height1 = _simplex4dNoiseFunc(vec4(p1 * NOISE_AMP, TIME));
	float height2 = _simplex4dNoiseFunc(vec4(p2 * NOISE_AMP, TIME));
	float height3 = _simplex4dNoiseFunc(vec4(p3 * NOISE_AMP, TIME));
	p1 = vec3(0.0, 0.0, height1 * WAVE_STRENGTH);
	p2 = vec3(2.0, 0.0, height2 * WAVE_STRENGTH);
	p3 = vec3(1.0, 1.732, height3 * WAVE_STRENGTH);
	vec3 norm = normalize(cross((p2 - p1), (p3 - p1)));
	norm = norm/2. + 0.5;
	
	NORMAL_MAP = norm;
	ALBEDO = WATER_COLOR;
	ROUGHNESS = 0.1;
	// for some reason none of this works
	SSS_STRENGTH = 1.;
	SSS_TRANSMITTANCE_COLOR = vec4(1.0, 1.0, 1.0, 1.);
	//SSS_TRANSMITTANCE_DEPTH = 0.05;
	//SSS_TRANSMITTANCE_BOOST = 1.0;
}