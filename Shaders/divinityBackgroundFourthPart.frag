#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform vec4 color;
uniform float borderPulse;
uniform float gridSize;
uniform float colorVariance;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 randomColor(vec2 cell) {
    float r = color.r + (rand(cell + 1.0) - 0.5) * 2.0 * colorVariance;
    float g = color.g + (rand(cell + 2.0) - 0.5) * 1.5 * colorVariance;
    float b = color.b + (rand(cell + 3.0) - 0.5) * 2.0 * colorVariance;
    return clamp(vec3(r, g, b), 0.0, 1.0);
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    vec2 grid = floor(uv * gridSize / 2.0 * pow(sin(uv.x * 2.0), 1.5) + u_time / 5.0);

    vec3 col = randomColor(grid);

    gl_FragColor = vec4(col * 1.4, 1.0);
}
