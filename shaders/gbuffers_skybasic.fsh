// Draws the sky, minus textured objects like the sun or moon.
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms

// Inputs / Outputs
in vec4 vertColor;

// Includes

// Private variables
uniform vec4 None = vec4(0.0,0.0,0.0,1.0);

// Methods

// Main
void main(){
  vec4 color = vertColor;
  color.rgb = mix(color.rgb, gl_Fog.color.rgb, clamp((gl_FogFragCoord - gl_Fog.start) * gl_Fog.scale, 0.0, 1.0));

  gl_FragData[0] = color;
	gl_FragData[1] = None;
	gl_FragData[2] = None;
}