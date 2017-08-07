// Final shader, applies post-render, to the entire view-port.
// Author: Chris McGhee (Nividica)

#version 120

// Defines
#define Tonemap
  #define Tonemap_Red 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0] Red Intensity
  #define Tonemap_Green 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0] Green Intensity
  #define Tonemap_Blue 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0] Blue Intensity

// Uniforms
uniform sampler2D gcolor;

// Varying
varying vec4 texcoord;

// Calculated values
#ifdef Tonemap
  vec3 TonemapTint = vec3(Tonemap_Red, Tonemap_Green, Tonemap_Blue);
#endif

// Imports

// Methods

// Main
void main(){
  // Get the existing color out of the frame buffer
  vec3 color = texture2D(gcolor, texcoord.st).rgb;

  #ifdef Tonemap
    color *= TonemapTint;
  #endif

  // Set the buffer color
  gl_FragColor = vec4(clamp(color, 0.0, 1.0), 1.0);
}