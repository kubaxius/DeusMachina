shader_type canvas_item;

uniform sampler2D SEA_MAP;


vec4 side_blur(sampler2D tex, vec2 uv, vec2 pixel_size, int strength){
	vec4 color = texture(tex, vec2(uv.x, uv.y));
	
	if(color == vec4(vec3(0.0), 1.0)){
		for(int i = 1; i <= strength; i++){
			float left_x = uv.x - pixel_size.x * float(i);
			left_x = mod(left_x, 1.0);
			color += texture(tex, vec2(left_x, uv.y));
			
			float right_x = uv.x + pixel_size.x * float(i);
			right_x = mod(right_x, 1.0);
			color += texture(tex, vec2(right_x, uv.y));
		}
		
		color /= float(strength*2+1);
	}
	return color;
}

void fragment() {
	COLOR = side_blur(SEA_MAP, UV, SCREEN_PIXEL_SIZE, 100);
}