#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
uniform vec4 color;
uniform float borderPulse;

uniform float gridSize = 1.0;

void main() {
    vec2 uv = (gl_FragCoord.xy - 0.5 * u_resolution.xy) / u_resolution.y;
    float dist = length(uv);
    float edge = borderPulse * 1.0;

    float fade = smoothstep(0.0, edge, dist);
    vec3 col = mix(vec3(0.0), color.rgb, fade);

    float xVal = abs(uv.x) + 0.001;
    float yVal = abs(uv.y) + 0.01;

    float xGrid = step(mod(pow(xVal * yVal, 0.1) * gridSize - u_time / 20.0, 0.1), 0.009);
    float yGrid = step(mod(yVal / xVal * gridSize - u_time / 6.0, pow(1.0, xGrid)), 0.03);

    gl_FragColor = vec4(col + 1.0 * (xGrid + yGrid), fade);
    gl_FragColor.a *= 2.0 - length(uv);
}
