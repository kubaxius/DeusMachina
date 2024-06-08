shader_type spatial;

uniform sampler2D SEA_MAP;
uniform sampler2D HEIGHT_MAP;

uniform float TERRAIN_AMPLITUDE = 0.05;
uniform float SEA_LEVEL = 0.2;

void vertex() {
	//float multiplier = texture(HEIGHT_MAP, UV).r - SEA_LEVEL;
	//float scaled_multiplier = multiplier * TERRAIN_AMPLITUDE;
	//
	//VERTEX = VERTEX * (scaled_multiplier + 1.);
}

uniform vec3 DEF_COLOR: source_color = vec3(0.02, 0.2, 0.05);
void fragment() {
	ALBEDO = DEF_COLOR;
	ALPHA = 1.0 - texture(SEA_MAP, UV).r;
}