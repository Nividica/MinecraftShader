// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms

// Inputs / Outputs

// Includes
#include "common/vsh/positions.glsl"

// Private variables

// Methods

// Main
void main(){
	
  // Set clip position
	gl_Position = ClipPosition(RelativePosition());
}