shader_type canvas_item;

uniform float fill_alpha : hint_range(0.0, 1.0, 0.001) = 0.5;
uniform float grayed_multiplier : hint_range(0.0, 1.0, 0.001) = 0.125;

void fragment() {
	vec4 image = texture(TEXTURE, UV);
	vec4 image_grayed = vec4(image.rgb * grayed_multiplier, image.a);
	
	image = mix(image, image_grayed, float(UV.x >= fill_alpha));
	
	COLOR = image;
}
