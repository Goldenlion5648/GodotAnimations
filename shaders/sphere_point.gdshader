shader_type spatial;
uniform sampler2D noise;
void fragment() {
	// Place fragment code here.
	ALBEDO = vec3(.8, 0, 0);
}

void vertex() {
	
//	vec4 tex = texture(noise, vec2(TIME, 0.5));
//	float current_value = (cos(TIME) / (sin(TIME)));
//	if(abs(current_value) < tex.x)
//		VERTEX.y += current_value;
}