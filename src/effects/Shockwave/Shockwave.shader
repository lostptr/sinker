shader_type canvas_item;
render_mode unshaded;

uniform float displacement_amount : hint_range(0.0, 1.0) = 0.02;

uniform float radius : hint_range(0.0, 50.0) = 0.0;
uniform float thickness : hint_range(0.1, 10.0) = 0.671;
uniform float hardness : hint_range(0.0, 10.0) = 1.5;
uniform float invert : hint_range(-1.0, 1.0) = 1.0;

uniform float center_x : hint_range(0.0, 1.0) = 0.5;
uniform float center_y : hint_range(0.0, 1.0) = 0.5;

uniform float size_x : hint_range(0.1, 100.0) = 16.0;
uniform float size_y : hint_range(0.1, 100.0) = 9.0;


void fragment() {
	vec4 c = vec4(0.0, 0.0, 0.0, 1.0);
	float dist = length(vec2(SCREEN_UV.x - center_x, SCREEN_UV.y - center_y) * vec2(size_x, size_y));
	
	float rd = thickness / 2.0;
	float rc = radius - rd;
	
	float circle = clamp((abs(dist - rc) / thickness), 0.0, 1.0);
	float circle_alpha = pow(circle, pow(hardness, 2.0));
	float a = (invert < 0.0) ? circle_alpha * invert : (1.0 - circle_alpha) * invert;	
	vec4 mask = vec4(a);
//	COLOR = mask;
	vec2 displacement_uv = UV + mask.rg * displacement_amount;
	vec4 distorted_color = texture(SCREEN_TEXTURE, displacement_uv);
	COLOR = distorted_color;
}