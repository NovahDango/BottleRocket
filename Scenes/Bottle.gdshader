shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0) = 0.4;
uniform float speed : hint_range(0.0, 2.0) = 0.333;
uniform vec2 screen_resolution = vec2(1280.0, 720.0); // Must be set from GDScript

void fragment() {
    float t = TIME * speed;
    vec3 col = vec3(0.0);

    // Calculate screen coordinates in the range [0,1] using FRAGCOORD.xy and then center them to [-1,1]
    vec2 pos = (FRAGCOORD.xy / screen_resolution) * 2.0 - 1.0;
    
    // Adjust the y coordinate to preserve the aspect ratio
    pos.y *= (screen_resolution.y / screen_resolution.x);
    
    // Scale up for a larger effect, as in the original shader
    pos *= 4.0;
    
    // Iterate to modify the position, creating a dynamic distortion effect
    for (float k = 1.0; k < 7.0; k += 1.0) {
        pos.x += strength * sin(2.0 * t + k * 1.5 * pos.y) + t * 0.5;
        pos.y += strength * cos(2.0 * t + k * 1.5 * pos.x);
    }
    
    // Compute the color based on time and the modified position
    col += 0.5 + 0.5 * cos(TIME + pos.xyx + vec3(0.0, 2.0, 4.0));
    
    // Apply gamma correction to the color
    col = pow(col, vec3(0.4545));
    
    // Output the final color with full opacity
    COLOR = vec4(col, 1.0);
}
