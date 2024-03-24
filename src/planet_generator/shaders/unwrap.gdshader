shader_type spatial;
render_mode unshaded;

varying vec3 color_vertex_world_position;
varying vec3 color_normal;

uniform bool is_getting_normals = false;

uniform float capture_size = 1;
uniform vec3 unwrap_location = vec3(0, 0, 0);
uniform float unwrap_scale = 1.0;

void vertex()
{
	color_vertex_world_position =  (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	color_normal = (MODEL_MATRIX * vec4(NORMAL, 1.0)).xyz;
	
	// Placed in separate steps for comprehension,
	// it can be simplified in a single row.
	vec2 step1 = (UV - 0.5) * capture_size;
	vec3 step2 = vec3(step1.x*2.0, step1.y, 0);
	vec3 step3 = step2 + unwrap_location; 
	vec3 final_position = step3 * unwrap_scale;
	VERTEX = final_position;
}

void fragment()
{
	if(!is_getting_normals) {
		ALBEDO = color_vertex_world_position;
	} else {
		ALBEDO = color_normal;
	}
}