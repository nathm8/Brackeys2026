shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 camera_pos;
uniform vec2 mouse_pos;
uniform bool enabled;

// https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line#Line_defined_by_two_points
// distance to the line between mouse and camera
float distance_to_line(vec2 p) {
    return abs((mouse_pos.y - camera_pos.y)*p.x - (mouse_pos.x - camera_pos.x)*p.y + mouse_pos.x*camera_pos.y - mouse_pos.y*camera_pos.x)/sqrt(pow(mouse_pos.y - camera_pos.y, 2) + pow(mouse_pos.x - camera_pos.x, 2));
}

// Blurs the screen in the X-direction.
void fragment() {
    if (enabled) {
        float dist_to_line = distance_to_line(SCREEN_UV);
        float dist_to_mouse = distance(SCREEN_UV, mouse_pos);
        float dist_to_camera = distance(SCREEN_UV, camera_pos);

        // https://www.geeksforgeeks.org/dsa/minimum-distance-from-a-point-to-the-line-segment-using-vectors/
        // mouse_pos A
        // camera_pos B
        // SCREEN_UV E
        float dist = 0.0;
        float dist_cutoff = 0.0;
        vec2 ab = camera_pos - mouse_pos;
        vec2 be = SCREEN_UV - camera_pos;
        float ab_dot_be = dot(ab, be);

        vec2 ae = SCREEN_UV - mouse_pos;
        float ab_dot_ae = dot(ab, ae);

        if (ab_dot_be > 0.0) {
            dist = dist_to_camera;
            dist_cutoff = 0.055;
        } else if (ab_dot_ae < 0.0) {
            dist = dist_to_mouse;
            dist_cutoff = 0.07 * dist_to_camera + 0.05;
        } else {
            dist = dist_to_line;
            dist_cutoff = 0.07 * dist_to_camera + 0.05;
        }
        if (dist > dist_cutoff) {
            vec3 col = texture(screen_texture, SCREEN_UV).xyz * 0.16;
            col += texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.15;
            col += texture(screen_texture, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.15;
            col += texture(screen_texture, SCREEN_UV + vec2(2.0 * SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.12;
            col += texture(screen_texture, SCREEN_UV + vec2(2.0 * -SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.12;
            col += texture(screen_texture, SCREEN_UV + vec2(3.0 * SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.09;
            col += texture(screen_texture, SCREEN_UV + vec2(3.0 * -SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.09;
            col += texture(screen_texture, SCREEN_UV + vec2(4.0 * SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.05;
            col += texture(screen_texture, SCREEN_UV + vec2(4.0 * -SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 0.05;
            COLOR.xyz = col;
        } else {
            // original colour
            COLOR.xyz = texture(screen_texture, SCREEN_UV).xyz;
        }
    }
}