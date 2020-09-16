shader_type canvas_item;

void fragment() {
	vec4 c = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 a = texture(TEXTURE, UV);
	c.b = 1.0 - c.b;
	c.r = 1.0 - c.r;
	c.g = 1.0 - c.g;
	c.a = a.a;
	COLOR = c;
}