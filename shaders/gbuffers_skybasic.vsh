// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;

// Inputs / Outputs
out vec4 color;

// Includes
#include "common/trig.glsl"
#include "common/vsh/positions.glsl"

// Private variables

// Methods

// Main
void main(){
  // Calculate relative position
	vec4 position = RelativePosition();
  //RelativePosition();
	
  // Set clip position
	gl_Position = ClipPosition(position);
	
  // Set fog distance
	gl_FogFragCoord = MagnitudeXYZ(position);	
	
  // Get color
	color = gl_Color;
}