shader_type canvas_item;
render_mode blend_mix;

uniform float amount: hint_range(0.0, 20.0, 0.1) = 0;

void fragment() {
	if (amount > 0.0){
		vec2 uv = UV * 0.05;
		float a = fract(sin(dot(UV, vec2(12.9898, 78.233))) * 438.5453);
		vec4 col = texture(TEXTURE, UV);

		col.a *= pow(a, amount);

		COLOR = col;
	}
}
