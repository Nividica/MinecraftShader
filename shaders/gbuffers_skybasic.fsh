// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms

// Inputs / Outputs
in vec4 vertexColor;

// Includes

// Private variables

// Methods

// Main
void main() {
	// Get color
  vec4 color = vertexColor;

  // Calculate fog intensity
  float fogIntensity = clamp((gl_FogFragCoord - gl_Fog.start) * gl_Fog.scale, 0.0, 1.0);

  // Mix color with fog
  color.rgb = mix(color.rgb, gl_Fog.color.rgb, fogIntensity);

  // Set the frag color
	gl_FragData[0] = color;
}