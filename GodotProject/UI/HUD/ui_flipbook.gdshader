shader_type canvas_item;

uniform sampler2D Texture;
uniform ivec2 Tiles = ivec2(2,2);
uniform float FPS = 2;

//void fragment() {
	//int frame = 0;
	//ivec2 offset = ivec2(frame % Tiles.x);
	//vec2 sample_uv = UV / vec2(Tiles);
	//
	//COLOR = texture(Texture, sample_uv);
//}

vec2 flipbook(vec2 uv, vec2 size, float progress){
	progress = floor( mod(progress, (size.x * size.y)) );
	vec2 frame_size = vec2(1.0, 1.0) / vec2(size.x, size.y);
	vec2 frame = fract(uv / size) + frame_size;
	
	frame.x += ( (progress / size.x) - frame_size.x * floor(progress/size.x) * size.x ) - frame_size.x;
	frame.y += (frame_size.y * floor(progress/size.x) ) - frame_size.y ;
	
	return frame;
}

void fragment()
{
	vec2 flip_uv = flipbook(UV, vec2(Tiles), TIME * FPS);
	vec4 flip_texture = texture(Texture, flip_uv);
	COLOR = flip_texture;
}