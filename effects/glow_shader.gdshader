shader_type canvas_item;
render_mode blend_mix;

uniform float glow_width : hint_range(0.001, 2000) = 30;
uniform float glow_intensity : hint_range(0.0, 10.0) = 1.0;
uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float inner_glow : hint_range(0.0, 1.0) = 0;
uniform bool pulse = false;
uniform float pulse_speed : hint_range(0.1, 5.0) = 1.0;

void fragment() {
    vec2 pixel_delta = glow_width * SCREEN_PIXEL_SIZE;
    
    float center_a = texture(TEXTURE, UV).a;
    float left_a = texture(TEXTURE, UV - vec2(pixel_delta.x, 0.0)).a;
    float right_a = texture(TEXTURE, UV + vec2(pixel_delta.x, 0.0)).a;
    float up_a = texture(TEXTURE, UV - vec2(0.0, pixel_delta.y)).a;
    float down_a = texture(TEXTURE, UV + vec2(0.0, pixel_delta.y)).a;
    
    float edge_x = abs(left_a - right_a) + abs(center_a - left_a) + abs(center_a - right_a);
    float edge_y = abs(up_a - down_a) + abs(center_a - up_a) + abs(center_a - down_a);
    float edge_strength = (edge_x + edge_y) * 0.5;
    
    vec4 original_tex = texture(TEXTURE, UV);
    
    vec3 final_color = original_tex.rgb;
    if (edge_strength > 0.01 || original_tex.a > 0.01) {
        float glow_amount = edge_strength * glow_intensity + (original_tex.a * inner_glow);
        final_color += glow_color.rgb * glow_amount;
        
        if (pulse) {
            float pulse_val = 1.0 + 0.3 * sin(TIME * pulse_speed);
            final_color *= pulse_val;
        }
    }
    
    COLOR = vec4(final_color, original_tex.a);
}