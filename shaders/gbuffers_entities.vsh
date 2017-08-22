// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform vec3 cameraPosition;
uniform float frameTimeCounter;

// Inputs / Outputs
out vec4 texcoord;
out vec4 vertexColor;
out vec4 lmcoord;
//out vec4 relativePosition;
//out vec3 worldPosition;

// Includes
#include "common/config.glsl"
#include "common/trig.glsl"
#include "common/vsh/coord_systems.glsl"
#include "common/vsh/world_curvature.glsl"

// Private variables

// Methods

// Main
void main(){
  // Calculate view position
  vec4 viewPosition = Coords_LocalToView(gl_Vertex);

  #ifdef WORLD_CURVATURE
    // Calculate world position
    vec3 worldPosition = Coords_ViewToWorld(viewPosition);

    // Simulate world curvature
    ApplyWorldCurvature(viewPosition, worldPosition);

    // Convert from world back to view
    viewPosition = Coords_WorldToView(worldPosition);
  #endif

  // Convert view to clipping
  gl_Position = Coords_ViewToClip(viewPosition);
	
  // Set the fog distance
	gl_FogFragCoord = MagnitudeXYZ(viewPosition);
	
  // Calculate the texture coordinate
	texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;
	
  // Calculate the lightmap coodinate
	lmcoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
	
  // Get the vertex color
	vertexColor = gl_Color;
}