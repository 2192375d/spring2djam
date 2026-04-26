shader_type canvas_item;

uniform float hue_offset = 0.0;
uniform float saturation = 0.9;
uniform float value = 1.0;
uniform float width = 3.0;

vec3 hsv2rgb(vec3 c) {
	vec3 rgb = clamp(abs(mod(c.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
	rgb = rgb * rgb * (3.0 - 2.0 * rgb);
	return c.z * mix(vec3(1.0), rgb, c.y);
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float hue = fract(UV.x * width + hue_offset);
	vec3 rainbow = hsv2rgb(vec3(hue, saturation, value));
	COLOR = vec4(rainbow, tex.a) * COLOR;
}
