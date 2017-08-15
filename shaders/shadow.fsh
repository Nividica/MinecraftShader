#version 120

varying vec4 texcoord;
varying vec4 color;
varying vec3 worldpos;

varying float iswater;
varying float isTransparent;

uniform sampler2D tex;
uniform sampler2D noisetex;

uniform float frameTimeCounter;

void main() {

	vec4 fragcolor = texture2D(tex,texcoord.xy) * color;
	
	fragcolor.rgb = mix(vec3(0.0), mix(vec3(0.0),fragcolor.rgb, fragcolor.a), isTransparent) * 0.1;
	
/* DRAWBUFFERS:0 */	

	gl_FragData[0] = vec4(0.0);
}