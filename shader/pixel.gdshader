shader_type canvas_item;

uniform float pixel_size : hint_range(1, 100) = 10.0;

void fragment() {
    vec2 pixelatedUV = floor(FRAGCOORD.xy / pixel_size) * pixel_size;
    vec2 uv = pixelatedUV / SCREEN_PIXEL_SIZE.xy;
    COLOR = texture(TEXTURE, uv);
}
