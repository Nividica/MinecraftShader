// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms
uniform float frameTimeCounter;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform vec3 upPosition;

// X = id, Y = renderType, Z = meta
attribute vec4 mc_Entity;

// Input / Output
out vec4 texcoord;
out vec4 vertexColor;
out vec4 lmcoord;
out vec4 block;

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
  block = mc_Entity;

  #ifdef WORLD_CURVATURE
    // // Calculate world position
    vec3 worldPosition = Coords_ViewToWorld(viewPosition);

    // // Simulate world curvature
    ApplyWorldCurvature(viewPosition, worldPosition);

    // //vec3 upVector = normalize(upPosition);
    // vec3 staticPoint = cameraPosition;//vec3(19.0, 72.0, 256.0);
    // vec3 dirVector = vec3( 0.0, 1.0, 0.0 );
    // float angle = (MagnitudeXZ( (worldPosition - staticPoint) ) * 0.5 ) * 0.1274533;

    // float u = dirVector.x;
    // float v = dirVector.y;
    // float w = dirVector.z;
    
    // float u2 = u*u;
    // float v2 = v*v;
    // float w2 = w*w;

    // float uv = u*v;
    // float uw = u*w;
    // float vw = v*w;

    // float sinT = sin(angle);
    // float cosT = cos(angle);

    // float cosT1 = 1.0 - cosT;
    // float uvCosT1= uv * cosT1;
    // float uSinT = u * sinT;
    // float vSinT = v * sinT;
    // float wSinT = w * sinT;

    // float cx = cameraPosition.x;
    // float cy = cameraPosition.y;
    // float cz = cameraPosition.z;
    

    // mat4 transform = mat4(
    //   (u2 + ( ( 1.0 - u2 ) * cosT ) ), ( uvCosT1 - wSinT  ),             ( ( uw * cosT1 ) + vSinT ),        0,
    //   ( uvCosT1 + wSinT ),             ( v2 + ( ( 1.0 - v2 ) * cosT ) ), ( ( vw * cosT1 ) - uSinT ),        0,
    //   ( ( uw * cosT1 ) - vSinT ),      ( ( vw * cosT1 ) + uSinT ),       ( w2 + ( ( 1.0 - w2 ) * cosT ) ),  0,
    //   0,                               0,                                0,                                 1
    // );

    // worldPosition -= staticPoint;

    // worldPosition.xyz = (transform * vec4(worldPosition.xyz, 1.0)).xyz;

    // worldPosition += staticPoint;

    //vec2 staticPoint = vec2(worldPosition .x - 20.0, worldPosition.z - 260.0);
    //float spOff = 1.0 + 0.01 * sin(frameTimeCounter + (MagnitudeXY(staticPoint) / 10.0) );
    //float zOff = sin(frameTimeCounter + (worldPosition.y / 3.0));
    //worldPosition.x += spOff;
    //worldPosition.z += zOff;

    // // Convert from world back to view
    viewPosition = Coords_WorldToView(worldPosition);
  #endif

  // Convert view to clipping
  gl_Position = Coords_ViewToClip(viewPosition);
	
  // Set the fog coordinate
	gl_FogFragCoord = MagnitudeXYZ(viewPosition);
	
  // Calculate the texture coordinate
	texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;
	
  // Calculate the lightmap coodinate
	lmcoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
	
  // Get the vertex color
	vertexColor = gl_Color;
}