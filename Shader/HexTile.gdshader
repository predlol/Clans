shader_type spatial;
render_mode unshaded, blend_mix, cull_back;

uniform vec3 edge_color : source_color = vec3(0.1, 0.1, 0.1); // sehr dunkles Grau
uniform float edge_thickness = 0.01;      // dünner Rand
uniform float alpha_strength = 0.03;      // fast unsichtbar

void fragment() {
    float dist = length(UV - vec2(0.5));
    
    float edge = smoothstep(0.5 - edge_thickness, 0.5, dist) *
                 (1.0 - smoothstep(0.5, 0.5 + edge_thickness, dist));

    ALBEDO = edge_color;
    ALPHA = edge * alpha_strength;
}
