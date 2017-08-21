// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms

// Inputs / Outputs
out vec4 texcoord;

// Includes
#include "./common/vsh/coord_systems.glsl"

// Private variables

// Methods

// Main
void main(){
  // Vertex projection
	gl_Position = Coords_LocalToClip(gl_Vertex);

  // Get the texture coordinate
	texcoord = gl_MultiTexCoord0;
}