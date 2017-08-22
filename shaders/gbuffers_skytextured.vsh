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
#include "./common/vsh/coord_systems.glsl"

// Private variables

// Methods

// Main
void main(){
  // Calculate and set clipping position
  gl_Position = Coords_LocalToClip(gl_Vertex);

  // Set vertex color
  vertColor = gl_Color;

  // Calculate texture coordinate
	texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;
}