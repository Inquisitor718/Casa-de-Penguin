shader_type canvas_item;

uniform float fill : hint_range(0.0, 1.0, 0.1);
uniform float time;
uniform float wave_strength = 0.1;
uniform float wave_speed = 6.0;

void fragment() {
    // Water rises bottom → top
    float base_level = 1.0 - fill;

    // Splash / wave near the top edge
    float wave =
        sin(UV.x * 20.0 + time * wave_speed) *
        wave_strength *
        smoothstep(base_level - 0.06, base_level, UV.y);

    float water_level = base_level + wave;

    if (UV.y > water_level) {
        COLOR = vec4(0.1, 0.45, 0.9, 1.0);
    } else {
        discard;
    }
}
