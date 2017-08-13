// Final shader, applies post-render, to the entire view-port.
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms
uniform sampler2D gcolor;

// Inputs / Outputs
in vec4 texcoord;

// Includes
#include "common/config.glsl"

// Private variables
#ifdef Tonemap
  vec3 TonemapTint = vec3(Tonemap_Red, Tonemap_Green, Tonemap_Blue);
#endif

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