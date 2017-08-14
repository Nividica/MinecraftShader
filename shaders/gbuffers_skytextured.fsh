// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms

// Inputs / Outputs

// Includes

// Private variables
uniform vec4 None = vec4(0.0,0.0,0.0,1.0);

// Methods

// Main
void main() {
  // Set buffers to colorless
	gl_FragData[0] = None;
	gl_FragData[1] = None;
	gl_FragData[2] = None;
}