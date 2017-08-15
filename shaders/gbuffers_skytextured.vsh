// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms

// Inputs / Outputs
out vec4 texcoord;
out vec4 vertColor;

// Includes
#include "./common/trig.glsl"
#include "./common/vsh/positions.glsl"

// Private variables

// Methods

// Main
void main(){
  gl_Position = ClipPosition(RelativePosition());
	texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;
  vertColor = gl_Color;
}