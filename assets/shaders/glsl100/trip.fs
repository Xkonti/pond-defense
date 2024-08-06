#version 330

// Input vertex attributes (from vertex shader)
in vec2 fragTexCoord;
in vec4 fragColor;

// Input uniform values
uniform sampler2D texture0;
uniform vec4 colDiffuse;

// Output fragment color
out vec4 finalColor;

// Custom uniforms
uniform float iTime;
uniform vec2 iResolution;

// Constants
const float PI = 3.14159265359;

// Pixelation factor (increase for more pixelation)
const float pixelSize = 15.0;

// Function to create a rotation matrix
mat2 rotate2D(float angle) {
    return mat2(cos(angle), -sin(angle),
                sin(angle), cos(angle));
}

// Function to generate a psychedelic pattern
vec3 psychedelicPattern(vec2 uv, float time) {
    vec2 p = uv * 2.0 - 1.0;
    vec2 q = p;
    
    float r = length(p);
    float angle = atan(p.y, p.x);
    
    // Rotate and scale
    q = rotate2D(time * 0.2) * q;
    q *= sin(time * 0.1) * 0.5 + 1.5;
    
    // Generate pattern
    float f = 0.0;
    for (int i = 0; i < 5; i++) {
        float n = float(i) * 1.1;
        f += sin(q.x * 10.0 * n + time + sin(q.y * 8.0 + time * 0.3) * PI);
        f += sin(q.y * 8.0 * n + time + sin(q.x * 6.0 + time * 0.5) * PI);
        q = rotate2D(PI / 4.0) * q;
    }
    
    // Color mapping
    vec3 col = vec3(sin(f * 0.5 + time) * 0.5 + 0.5,
                    sin(f * 0.4 + time * 1.1) * 0.5 + 0.5,
                    sin(f * 0.3 + time * 1.2) * 0.5 + 0.5);
    
    // Add some circular patterns
    col *= smoothstep(0.2, 0.21, abs(sin(r * 10.0 - time * 2.0)));
    col *= smoothstep(0.2, 0.21, abs(sin(angle * 5.0 + time * 1.5)));
    
    return col;
}

void main() {
    // Calculate pixelated UV coordinates
    vec2 pixelatedUV = floor(fragTexCoord * iResolution / pixelSize) * pixelSize / iResolution;
    
    // Generate psychedelic pattern with pixelated coordinates
    vec3 color = psychedelicPattern(pixelatedUV, iTime);
    
    // Mix with the original texture (also pixelated)
    vec4 texColor = texture(texture0, pixelatedUV);
    finalColor = vec4(mix(texColor.rgb, color, 0.8), texColor.a) * colDiffuse * fragColor;
}