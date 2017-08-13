// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms
uniform sampler2D noisetex;

// Inputs / Outputs
in vec4 color;

// Includes

// Private variables

// Methods

// Main
void main() {
  /*vec3 wpos = vec3(0.0);
  float noise = texture2D(noisetex, wpos.xz).x;
	noise += texture2D(noisetex, wpos.xz * 2.0).x / 2.0;
	noise += texture2D(noisetex, wpos.xz * 4.0).x / 4.0;*/

	gl_FragData[0] = mix(color,vec4(0.0,1.0,0.0,1.0),0.5);
	
	gl_FragData[0].rgb = mix(gl_FragData[0].rgb, gl_Fog.color.rgb, clamp((gl_FogFragCoord - gl_Fog.start) * gl_Fog.scale, 0.0, 1.0));
}