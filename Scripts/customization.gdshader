shader_type canvas_item;

uniform vec3 rgb;

void fragment() {
	COLOR = vec4(rgb[0], rgb[1], rgb[2], COLOR.a);
}