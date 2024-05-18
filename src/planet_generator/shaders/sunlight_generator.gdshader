shader_type spatial;
#include "res://planet_generator/shaders/includes/unwrap.gdshaderinc"

const vec3 PLANET_POSITION = vec3(0.0);

varying vec3 WS_PIXEL_POS;

uniform vec3 SUNLIGHT_DIRECTION = vec3(0.917, 0.399, 0.0);

float get_dist_to_a_plane(vec3 point, vec3 normal){
	vec3 step1 = point * normal;
	float step2 = step1.x + step1.y + step1.z;
	vec3 step3 = normal * normal;
	float step4 = sqrt(step3.x + step3.y + step3.z);
	float dist_to_a_plane = step2/step4;
	
	return dist_to_a_plane;
}


// First, we get the circle representing latitude and plane representing
// night and day. Then, we calculate arc length created by dividing the circle
// with the arc, and finally we return what part of the circle it is.
float get_day_to_night_proportion(vec3 point){
	// latitude of point
	vec3 circle_pos = vec3(0.0, point.y, 0.0);
	
	// get distance from latitude center to light plane
	// that splits planet into night and day
	float center_to_plane = get_dist_to_a_plane(circle_pos, normalize(SUNLIGHT_DIRECTION));
	bool day_longer_than_night = center_to_plane < 0.0;
	// drop the sign, since we don't need it anymore
	center_to_plane = abs(center_to_plane);
	
	float radius = distance(circle_pos.xz, point.xz);
	
	// calculate angle only if plane intersects latitude circle
	float angle_of_smaller_arc = 0.0;
	if(center_to_plane < radius){
		angle_of_smaller_arc = 2.0 * acos(center_to_plane/radius);
	}
	
	if(day_longer_than_night){
		return 1.0 - angle_of_smaller_arc/TAU;
	}
	return angle_of_smaller_arc/TAU;
}


float get_sunlight_amount_at_noon(vec3 point){
	float angle_to_xz_plane = PI/2.0 - acos(dot(point, vec3(0.0, 1.0, 0.0)));
	float sun_angle_to_xz_plane = PI/2.0 - acos(dot(-SUNLIGHT_DIRECTION, vec3(0.0, 1.0, 0.0)));
	// we use cos, since the relation of angle to the sun and power recieived
	// is not linear, due to atmosphere
	float signed_amount = cos(2. * angle_to_xz_plane - sun_angle_to_xz_plane);
	float amount = (signed_amount + 1.)/2.;
	
	
	return amount;
}


void vertex() {
	WS_PIXEL_POS = normalize(VERTEX - PLANET_POSITION);
	VERTEX = get_unwrapped_vertex(UV);
}

void fragment() {
	
	float day_to_night = get_day_to_night_proportion(WS_PIXEL_POS);
	float sunlight_amount = get_sunlight_amount_at_noon(WS_PIXEL_POS);
	
	ALBEDO = vec3(day_to_night * sunlight_amount);
}
