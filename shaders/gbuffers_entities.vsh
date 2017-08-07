// 
// Author: Chris McGhee (Nividica)

#version 120

// Defines

// Uniforms
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform float frameTimeCounter;

// Varying
varying vec4 texcoord;
varying vec4 vertexColor;
varying vec4 lmcoord;


// Calculated values

// Imports
#include "common/vsh/world_curvature.glsl"

// Methods

// Main
void main(){
  // Calculate position, where the camera is effectively (0,0,0)
  // This is not world position.
  vec4 position = gl_ModelViewMatrix * gl_Vertex;

  // Simulate a slight world curvature
  ApplyWorldCurvature(position);

  // Set the projected(screen space) position
  gl_Position = gl_ProjectionMatrix * position;
	
  // Set the fog coordinate
	gl_FogFragCoord = sqrt(position.x * position.x + position.y * position.y + position.z * position.z);
	
  // Calculate the texture coordinate
	texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;
	
  // Calculate the lightmap coodinate
	lmcoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
	
  // Get the vertex color
	vertexColor = gl_Color;
}