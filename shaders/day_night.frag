#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec2 sunDirection; // Direction of the sun
uniform float time; // Time in seconds

out vec4 fragColor;

void main() {
    vec2 pos = FlutterFragCoord().xy;
    vec2 uv = pos / uSize;
    
    // Calculate day-night cycle based on time
    // float dayNightFactor = abs(sin(time)); // Example: Simulate day-night cycle using sine function
    
    // Calculate sun color based on time and sun direction
    vec3 sunColor = vec3(1.0, 1.0, 0.9); // Example sun color
    
    // Calculate sky color based on day-night cycle and sun direction
    vec3 skyColor = mix(vec3(0.0, 0.0, 0.5), vec3(0.5, 0.5, 0.8), time); // Example: Blend between night and day sky colors
    
    // Calculate final color by blending sky and sun colors based on sun direction
    vec3 finalColor = mix(skyColor, sunColor, dot(normalize(sunDirection), vec2(0.0, -1.0)));
    
    // Output final color
    fragColor = vec4(finalColor, 0.5);

}
