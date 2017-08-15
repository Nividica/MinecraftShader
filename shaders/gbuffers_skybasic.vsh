// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms

// Inputs / Outputs
out vec4 vertColor;

// Includes
#include "./common/trig.glsl"
#include "./common/vsh/positions.glsl"

// Private variables

// Methods

// Main
void main(){
  vec4 relativePosition = RelativePosition();
  gl_Position = ClipPosition(relativePosition);
  gl_FogFragCoord = MagnitudeXYZ(relativePosition);
  vertColor = gl_Color;
}