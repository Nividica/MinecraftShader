// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform float frameTimeCounter;
uniform vec3 cameraPosition;

// Input / Output
out vec4 texcoord;
out vec4 vertexColor;
out vec4 lmcoord;
out vec4 relativePosition;
out vec3 worldPosition;

// Includes
#include "common/config.glsl"
#include "common/trig.glsl"
#include "common/vsh/world_curvature.glsl"

// Private variables

// Methods

// Main
void main(){
  // Calculate relativePosition, where the camera is the point of origin
  // This is not world relativePosition.
  relativePosition = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;
  worldPosition = relativePosition.xyz + cameraPosition.xyz;

  #ifdef WORLD_CURVATURE
    // Simulate a slight world curvature
    ApplyWorldCurvature(worldPosition, relativePosition);
    relativePosition.xyz = ( worldPosition - cameraPosition );
  #endif

  // Set the projected(screen space) relativePosition
  gl_Position = gl_ProjectionMatrix * gbufferModelView * relativePosition;
	
  // Set the fog coordinate
	gl_FogFragCoord = MagnitudeXYZ(relativePosition);
	
  // Calculate the texture coordinate
	texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;
	
  // Calculate the lightmap coodinate
	lmcoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
	
  // Get the vertex color
	vertexColor = gl_Color;
}