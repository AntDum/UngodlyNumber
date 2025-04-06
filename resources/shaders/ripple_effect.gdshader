shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0, 0.01) = 0.0; 
uniform float num_cells: hint_range(2.0, 20.0, 1.0) = 10.0; 
uniform float smoothness: hint_range(0.5, 2.0, 0.01) = 1.0; 
uniform float angle: hint_range(0.0, 360.0) = 45.0;

float dissolve(vec2 uv, float feather) {
	return smoothstep(0.0, feather, uv.x);
}

float center_squaref(vec2 uv, float size) {
	vec2 uv_centered = abs(uv * 2.0 - 1.0);
	float dfx = step(size, uv_centered.x);
	float dfy = step(size, uv_centered.y);
	return max(dfx, dfy);
}

vec2 rotation(vec2 uv, vec2 center, float ang) {
	mat2 rotation = mat2(
		vec2(cos(ang), -sin(ang)), 
		vec2(sin(ang), cos(ang))
	);
	uv -= center; 
	uv *= rotation; 
	uv += center; 
	return uv;
}

void fragment() {
	
	vec2 igrid = floor(UV * num_cells) / num_cells;
	igrid = rotation(igrid, vec2(0.5), angle * PI / 180.0); 
	
	float animation_offset = mix(-2.0, 2.0, progress);
	igrid.x += animation_offset;
	
	vec2 fgrid = fract(UV * num_cells); 
	float rect_mask = dissolve(igrid, smoothness); 
	float grid_mask = 1.0-center_squaref(fgrid, rect_mask); 
	
	COLOR = vec4(COLOR.rgb, grid_mask);

}