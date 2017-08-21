// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms

// Inputs / Outputs
out vec4 vertColor;

// Includes
#include "./common/trig.glsl"
#include "./common/vsh/coord_systems.glsl"

// Private variables

// Methods

// Main
void main(){
  // Calculate the view position
  vec4 viewPosition = Coords_LocalToView(gl_Vertex);
  
  // Calculate and set clipping position
  gl_Position = Coords_ViewToClip(viewPosition);

  // Calculate view distance
  gl_FogFragCoord = MagnitudeXYZ(viewPosition);

  // Set vertex color
  vertColor = gl_Color;
}