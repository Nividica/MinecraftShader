// Final shader, applies post-render, to the entire view-port.
// Author: Chris McGhee (Nividica)

#version 130
// Defines

// Uniforms
uniform vec3 cameraPosition;

// Inputs / Outputs
//in vec4 gl_MultiTexCoord0;
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