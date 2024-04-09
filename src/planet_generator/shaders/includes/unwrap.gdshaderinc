uniform float capture_size = 1.0;
uniform vec3 unwrap_location = vec3(0, 0, 0);
uniform float unwrap_scale = 1.0;


vec3 get_unwrapped_vertex(vec2 uv){
	
	// Placed in separate steps for comprehension,
	// it can be simplified in a single row.
	vec2 step1 = (uv - 0.5) * capture_size;
	vec3 step2 = vec3(step1.x*2.0, step1.y, 0);
	vec3 step3 = step2 + unwrap_location; 
	vec3 final_position = step3 * unwrap_scale;
	return final_position;
}