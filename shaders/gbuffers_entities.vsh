// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform float frameTimeCounter;

// Inputs / Outputs
out vec4 texcoord;
out vec4 vertexColor;
out vec4 lmcoord;
out vec4 relativePosition;
out vec3 worldPosition;

// Includes
#include "common/config.glsl"
#include "common/trig.glsl"
#include "common/vsh/positions.glsl"
#include "common/vsh/world_curvature.glsl"

// Private variables

// Methods

// Main
void main(){
  relativePosition = RelativePosition();
  worldPosition = WorldPosition(relativePosition);

  #ifdef WORLD_CURVATURE
    // Simulate a slight world curvature
    ApplyWorldCurvature(worldPosition, relativePosition);

    // Adjust relative position
    relativePosition.xyz = ( worldPosition - cameraPosition );
  #endif

  // Set the projected(screen space) position
  gl_Position = ClipPosition(relativePosition);
	
  // Set the fog distance
	gl_FogFragCoord = MagnitudeXYZ(relativePosition);
	
  // Calculate the texture coordinate
	texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;
	
  // Calculate the lightmap coodinate
	lmcoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
	
  // Get the vertex color
	vertexColor = gl_Color;
}