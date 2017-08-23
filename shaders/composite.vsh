// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms
uniform vec3 upPosition;
uniform vec3 sunPosition;

// Time of day
// 0...11999 = day
// 12000...24000 = night
uniform int worldTime;

// Inputs / Outputs
out vec4 texcoord;
out vec3 upVector;
out vec3 sunVector;
out float worldTimef;

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

  // Calculate the UP vector
	upVector = normalize(upPosition);

  // Calculate the sun vector
  sunVector = normalize(sunPosition);

  // Cast world time as a float
  worldTimef = worldTime;
}