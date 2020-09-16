shader_type canvas_item;
render_mode unshaded;

uniform sampler2D displacement_mask : hint_white;
uniform float displacement_amount : hint_range(0.0, 1.0) = 0.0;


void fragment() {
	vec4 displ = texture(displacement_mask, UV);
	vec2 displ_uv = SCREEN_UV + displ.rg * displacement_amount;
	vec4 distorted_color = texture(SCREEN_TEXTURE, displ_uv);
	COLOR = distorted_color;
}