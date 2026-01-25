shader_type canvas_item;

uniform sampler2D chocolate_texture;
uniform float fill : hint_range(0.0, 1.0);
uniform float time;

uniform float wave_strength = 0.015;   // thicker liquid
uniform float wave_speed = 2.5;        // slower motion
uniform float texture_scroll_speed = 0.03;

uniform vec4 tint_color : source_color = vec4(0.35, 0.18, 0.08, 1.0);
uniform float gloss_strength = 0.25;

void fragment() {
    // Chocolate fill level (bottom → top)
    float base_level = 1.0 - fill;

    // Slow, heavy surface movement
    float wave =
        sin(UV.x * 10.0 + time * wave_speed) *
        wave_strength *
        smoothstep(base_level - 0.08, base_level, UV.y);

    float liquid_level = base_level + wave;

    if (UV.y > liquid_level) {
        vec2 tex_uv = UV;

        // Very slow chocolate flow
        tex_uv.y += time * texture_scroll_speed;

        vec4 tex = texture(chocolate_texture, tex_uv);

        // Tint + richness
        vec4 chocolate = tex * tint_color;

        // Fake glossy highlight near surface
        float highlight =
            smoothstep(liquid_level - 0.02, liquid_level, UV.y)
            * gloss_strength;

        chocolate.rgb += highlight;

        COLOR = chocolate;
    } else {
        discard;
    }
}
