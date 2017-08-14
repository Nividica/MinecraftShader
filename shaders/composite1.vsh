// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms

// Inputs / Outputs
out vec4 texcoord;

// Includes
#include "./common/vsh/positions.glsl"

// Private variables

// Methods

// Main
void main(){
  gl_Position = ClipPosition(RelativePosition());
	texcoord = gl_MultiTexCoord0;
}