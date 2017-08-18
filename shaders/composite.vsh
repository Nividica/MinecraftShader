// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms
uniform vec3 upPosition;

// Inputs / Outputs
out vec4 texcoord;
out vec3 upVector;

// Includes
#include "./common/vsh/positions.glsl"

// Private variables

// Methods

// Main
void main(){
  gl_Position = ClipPosition(RelativePosition());
	texcoord = gl_MultiTexCoord0;
	upVector = normalize(upPosition);
}