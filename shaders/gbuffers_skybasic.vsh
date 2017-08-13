// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms

// Inputs / Outputs
out vec4 vertexColor;

// Includes
#include "common/trig.glsl"
#include "common/vsh/positions.glsl"

// Private variables

// Methods

// Main
void main(){
  // Calculate relative position
	vec4 relativePosition = RelativePosition();
	
  // Set clip position
	gl_Position = ClipPosition(relativePosition);
	
  // Set fog distance
	gl_FogFragCoord = MagnitudeXYZ(relativePosition);	
	
  // Get color
	vertexColor = gl_Color;
}