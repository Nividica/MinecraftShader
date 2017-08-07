// 
// Author: Chris McGhee (Nividica)

#version 120
#extension GL_ARB_shader_texture_lod : enable

// Defines
#include "common/config.glsl"

// Uniforms
uniform sampler2D texture;
uniform sampler2D lightmap;

// Varying
varying vec4 texcoord;
varying vec4 vertexColor;
varying vec4 lmcoord;
varying float mat;

// Calculated values

// Imports

// Methods

// Main
void main(){

  // Get the texture color
  vec4 textureColor = texture2D(texture, texcoord.st);

  // Get the lightmap color
  vec4 lightmapColor = texture2D(lightmap, lmcoord.st);

  // Calculate overall color
  vec4 color = textureColor * lightmapColor * vertexColor;

  // Get fog color
  vec3 fogColor = gl_Fog.color.rgb;

  // Calculate fog intensity 0: No Fog, 1: Full Fog
  float fogIntensity = clamp((gl_FogFragCoord - (gl_Fog.start * FOG_DISTANCE)) * gl_Fog.scale * FOG_THICKNESS, 0.0, 1.0);

  // Mix with fog
  color.rgb = mix(color.rgb, fogColor, fogIntensity);

  // Set the frame color
	gl_FragData[0] = color;
}