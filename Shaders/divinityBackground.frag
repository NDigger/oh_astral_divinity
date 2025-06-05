#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform vec4 color;

float gridSize = 0.8;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vec2 uv = (gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;

    float dist = length(uv * 0.5 - vec2(0.0, 0.0));
    float radius = 0.05;
    float fade = smoothstep(radius, 1, dist);
	
    float xVal = abs(uv.x) + 0.001;
    float yVal = abs(uv.y) + 0.01;
    float xGrid = step(mod(pow(xVal, -0.1) * gridSize - u_time / 40.0, 0.1), 0.003);
    float yGrid = step(mod(yVal / xVal * gridSize - u_time / 12.0, 1.0), 0.01);
    gl_FragColor = vec4(vec3(xGrid + yGrid) * color.rgb, fade);
}
