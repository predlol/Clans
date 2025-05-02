shader_type spatial;
render_mode unshaded;

uniform vec3 moss_color : source_color = vec3(0.1, 0.3, 0.1); // dunkleres Moosgrün
uniform float noise_scale = 25.0;
uniform float brightness_variation = 0.08; // deutlichere Unterschiede

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = UV * noise_scale;
    float noise = rand(floor(uv));
    float brightness = noise * brightness_variation;
    ALBEDO = moss_color + vec3(0.0, brightness, 0.0); // nur G-Kanal beeinflussen
}
