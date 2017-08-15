// Draws the sky, minus textured objects like the sun or moon.
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms
uniform sampler2D texture;

// Inputs / Outputs
// Texture coordinate
in vec4 texcoord;
in vec4 vertColor;

// Includes

// Private variables
uniform vec4 None = vec4(0.0,0.0,0.0,1.0);

// Methods

// Main
void main(){
  vec4 color = texture2D(texture, texcoord.st) * vertColor;

  gl_FragData[0] = color;
	gl_FragData[1] = None;
	gl_FragData[2] = None;
}