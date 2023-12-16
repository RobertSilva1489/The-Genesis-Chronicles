shader_type canvas_item;

uniform float move = 0.5;

void fragment() {
	COLOR = texture(TEXTURE, vec2(UV.x + TIME * move, UV.y));
}
