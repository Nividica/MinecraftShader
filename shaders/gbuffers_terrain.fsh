// 
// Author: Chris McGhee (Nividica)

#version 130
#extension GL_ARB_shader_texture_lod : enable

// Defines
#include "common/config.glsl"

// Uniforms
uniform sampler2D texture;
uniform sampler2D lightmap;
uniform float frameTimeCounter;

// Inputs / Outputs
in vec4 texcoord;
in vec4 vertexColor;
in vec4 lmcoord;
in float mat;
in vec4 relativePosition;
in vec3 worldPosition;

// Includes

// Private variables
uniform vec4 flatWhite = vec4(1.0);

// Methods

// Main
void main(){

  // vec2 tsize = textureSize(texture,0);
  //vec2 uvPerTex = vec2(0.0, tsize.y / 16384); // 0.015625, 0.03125 :: 1/64, 1/32 :: tsize.x / 65536.0, tsize.y / 16384.0

  // Get the texture color
  vec4 textureColor = texture2D(texture, texcoord.st);

  // Get the lightmap color
  vec4 lightmapColor = texture2D(lightmap, lmcoord.st);

  vec3 ARP = relativePosition.xyz;// + (frameTimeCounter/70.0);

  // Calculate overall color
  vec4 color = textureColor* lightmapColor * vertexColor;
  
  //color.rg = normalize(tsize.st);
  //color.b = 0.5;

  // Get fog color
  vec3 fogColor = gl_Fog.color.rgb;

  // Calculate fog intensity 0: No Fog, 1: Full Fog
  float fogIntensity = clamp((gl_FogFragCoord - (gl_Fog.start * FOG_DISTANCE)) * gl_Fog.scale * FOG_THICKNESS, 0.0, 1.0);

  // Mix with fog
  color.rgb = mix(color.rgb, fogColor, fogIntensity);

  // Set the frame color
	gl_FragData[0] = color;
}