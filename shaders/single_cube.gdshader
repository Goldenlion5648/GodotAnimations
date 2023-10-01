shader_type spatial;
//
uniform sampler2D noise;

uniform float spawned_threshold;
varying bool should_show;
varying vec3 custom_pos;
//float height(vec2 position, float time) {
//  vec2 offset = cos(position + time);
//  return texture(noise, (position) - offset).x;
//}


void vertex() {
//    VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
//    NORMAL = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
    // same as above for binormal and tangent, if normal mapping is used
	custom_pos = VERTEX;
	COLOR.a = .5;
//	if(UV.x < .5){
//	}
}

void fragment(){
	// pixel's position in object space
//	VERTEX = inverse(WORLD_MATRIX) * CAMERA_MATRIX * vec4(VERTEX, 1.0);
//	ALPHA = 0.0;
	ALPHA = 0.5;
	if(custom_pos.x < spawned_threshold)
	{
		should_show = true;
	}
}

//void vertex() {
//	vec2 pos = VERTEX.xz;
//	float k = height(pos, TIME);
//	AL = vec3(UV.x, UV.y, 0.0);
//	if(UV. > .5){
//	  VERTEX.y += cos(TIME) / 2.0;
//
//	}
	
//VERTEX.p
//}

//void fragment() {
////	COLOR = texture(TEXTURE, UV);
//	float noise = texture(dissolveNoise, UV).r;
//	float showing_threshold = 0.3;
////	COLOR.a *= step(sin(TIME) * (UV.x + .5), noise - showing_threshold);
//}
