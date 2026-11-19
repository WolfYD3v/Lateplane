shader_type spatial;
render_mode cull_front, unshaded; // Important : inverse les faces et ignore la lumière

uniform float outline_width : hint_range(0.0, 0.3) = 0.02;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void vertex() {
    // L'outline ne subit PLUS la déformation (pas de sin/TIME)
    // On se contente d'élargir le mesh original
    VERTEX += NORMAL * outline_width;
}

void fragment() {
    ALBEDO = outline_color.rgb;
}