// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms
// Color of the scene thus far.
uniform sampler2D gcolor;

// Inputs / Outputs
// Texture coordinate
in vec4 texcoord;

// Includes

// Private variables

// Methods

// Main
void main(){
  vec3 color = texture2D(gcolor, texcoord.st).rgb;

  color = pow(color, vec3(0.4545));
  
  gl_FragData[0] = vec4(color,1.0);
}