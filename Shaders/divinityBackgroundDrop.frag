#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform vec4 color;

float softCircle(vec2 uv, vec2 center, float radius) {
    float d = length(uv - center);
    return smoothstep(radius, radius * 0.5, d);
}

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    vec3 col = vec3(1.0);

    const int COUNT_X = 2;
    const int COUNT_Y = 2;

    for (int y = 0; y < COUNT_Y; y++) {
        for (int x = 0; x < COUNT_X; x++) {
            vec2 grid = vec2(float(x), float(y));
            vec2 pos = grid / vec2(float(COUNT_X), float(COUNT_Y));
            float t = u_time * 8.0 + hash(grid) * 10.0;
            pos.x += mod(t, 3.0) - 1.5;
            float r = 0.32 + 0.05 * hash(grid + 1.3);
            float circle = softCircle(uv, pos, r) * 0.2;

            vec3 offset = vec3(
                hash(grid + 0.1),
                hash(grid + 0.2),
                hash(grid + 0.3)
            ) * 0.2 - 0.1;

            vec3 cloudColor = clamp(color.rgb + offset, 0.0, 1.0);
            col = mix(col, cloudColor, circle);
        }
    }

    gl_FragColor = vec4(col, 1.0);
}
