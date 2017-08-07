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

// Methods

// Main
void main(){
  // Calculate position
  vec4 position = gl_ModelViewMatrix * gl_Vertex;

  // Set the projected position
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