shader_type canvas_item;

uniform float amount = 1.0;
uniform sampler2D offset_texture : hint_white;

void fragment() {
	vec4 texture_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 color = texture_color;
	float adjusted = texture(offset_texture, SCREEN_UV).r * amount / 100.0;
	color.r = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x + adjusted, SCREEN_UV.y)).r;
	color.b = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x - adjusted, SCREEN_UV.y)).b;
	COLOR = color;
}