#version 460 core

precision mediump float;

uniform float time; 

const vec3 day_color = vec3(1.0, 1.0, 1.0);
const vec3 night_color = vec3(0.2, 0.2, 0.5);

out vec4 fragColor;

void main() {
    fragColor = vec4(mix(day_color, night_color, time), 1);

}
