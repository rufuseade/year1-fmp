shader_type canvas_item;

uniform float amplitude = 20f;
uniform float speed = 2f;

void vertex(){
	VERTEX.x += amplitude * sin( (1f-UV.y) * speed * TIME);
}