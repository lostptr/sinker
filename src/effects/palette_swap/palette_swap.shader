shader_type canvas_item;

uniform sampler2D palette;

void fragment() {
	vec4 c = texture(SCREEN_TEXTURE, SCREEN_UV);
	float grayscale = (c.r + c.g + c.b) / 3.0;
	COLOR = texture(palette, vec2(grayscale, 0.0));
}