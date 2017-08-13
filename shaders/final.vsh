// Final shader, applies post-render, to the entire view-port.
// Author: Chris McGhee (Nividica)

#version 130
// Defines

// Uniforms

// Inputs / Outputs
out vec4 texcoord;

// Includes

// Private variables

// Methods

// Main
void main(){
  
	gl_Position = ftransform();

  // Get the texture coordinate
	texcoord = gl_MultiTexCoord0;

}