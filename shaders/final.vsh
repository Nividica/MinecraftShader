// Final shader, applies post-render, to the entire view-port.
// Author: Chris McGhee (Nividica)

#version 120

varying vec4 texcoord;

void main(){
  
	gl_Position = ftransform();

  // Get the texture coordinate
	texcoord = gl_MultiTexCoord0;

}