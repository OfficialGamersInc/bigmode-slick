shader_type spatial;

uniform sampler2D surface_texture : filter_nearest_mipmap;
uniform float surface_texture_scale : hint_range(0.0, 10.0, 0.01) = 1;
uniform sampler2D wave_noise_texture : filter_linear_mipmap;
uniform float wave_noise_scale : hint_range(0.0, 10.0, 0.01) = 0.5;
uniform float wave_frequency_x : hint_range(0.0, 16.0, 0.01) = 1;
uniform float wave_frequency_y : hint_range(0.0, 16.0, 0.01) = 1;
uniform float wave_speed : hint_range(0.0, 10.0, 0.01) = 0.5;
uniform float wave_height : hint_range(0.0, 1.0, 0.01) = 1;
uniform float tide_frequency : hint_range(0.0, 10.0, 0.01) = 1;
uniform float tide_height : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float alpha : hint_range(0.0, 1.0, 0.01) = 0.5;

varying vec3 frag_obj_pos;

void vertex(){
	frag_obj_pos = VERTEX;
	vec2 sample_uv = frag_obj_pos.xz * wave_noise_scale;
	
	float height = texture(wave_noise_texture, sample_uv + TIME * wave_speed).r;
	
	//VERTEX += vec3(0,sin(
		//(sample_uv.x + TIME * wave_frequency_x) +
		//(sample_uv.y + TIME * wave_frequency_y)
	//),0);
	float wave = height * wave_height + sin(TIME * tide_frequency) * tide_height * 0.5;
	VERTEX += vec3(sin(height * wave_height),wave,cos(height * wave_height));
}

void fragment(){
	vec2 wave_offset = vec2(sin(TIME * wave_frequency_x), cos(TIME * wave_frequency_y));
	vec2 sample_uv = frag_obj_pos.xz * surface_texture_scale + wave_offset;
	
	//ALBEDO = vec3(1,1,1);
	
	vec2 foam_sample_uv = frag_obj_pos.xz * wave_noise_scale;
	float height = texture(wave_noise_texture, foam_sample_uv + TIME * wave_speed).r;
	float height_alt = texture(wave_noise_texture, foam_sample_uv + vec2(TIME + 123.4, 0) * wave_speed).r;
	float tide = sin(TIME * tide_frequency) * 0.5 + 0.5;
	float foam = smoothstep(0.45, 0.75, height);
	float foam_alt = smoothstep(0.45, 0.75, height_alt);
	float foam_strength = smoothstep(-0.75, 1, tide);
	
	//ALBEDO = vec3(0,height * wave_height + sin(TIME * tide_frequency) * tide_height * 0.5,0).rgb;
	//ALBEDO = vec3(height);
	
	ALBEDO = texture(surface_texture, sample_uv).rgb + foam * foam_strength + foam_alt;
	ALPHA = mix(ALBEDO.r, 1, alpha);
}







// god damn it.