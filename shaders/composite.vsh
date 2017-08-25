// 
// Author: Chris McGhee (Nividica)

#version 130

// Defines

// Uniforms
uniform vec3 upPosition;
uniform vec3 sunPosition;

// Time of day
uniform int worldTime;

// Inputs / Outputs
out vec4 texcoord;
out vec3 upVector;
out vec3 sunVector;
out float worldTimef;
out float solarAttenuation;

// Includes
#include "./common/vsh/coord_systems.glsl"
#include "./common/time.glsl"

// Private variables

// Methods

// Calculate a trapezoid-ish 'curve' based on the time of day
// The curve is 0.0 during night, 1.0 during the day and transitions
// during sunrise and sunset
float SolarAttenuation(){

  // Calculate time skew
  float skew = DayLength - TimeSunrise;

  // Because sunrise is at 23000 we need to wrap the time
  // so that if the slope crosses the day boundary we get a smooth transition
  float adjustedTime = mod( worldTimef + skew, DayLength );

  // Grows
  float incline = ( adjustedTime / RiseSetTransitionTime );

  // Shrinks
  float decline = ( mod( ( TimeSunset + skew ), DayLength ) / RiseSetTransitionTime ) - incline;

  // Clamp them both so that they are never <0 nor >1
  incline = clamp( incline, 0.0, 1.0 );
  decline = clamp( decline, 0.0, 1.0 );

  // The final curve is produced multiplying them both together, such that:
  // @ (sunrise)          = 0.0
  // @ (sunrise + length) = 1.0
  // @ Day                = 1.0
  // @ (sunset - length)  = 1.0
  // @ (sunset)           = 0.0
  // @ Night              = 0.0
  return incline * decline;
}

// Main
void main(){
  // Vertex projection
	gl_Position = Coords_LocalToClip(gl_Vertex);

  // Get the texture coordinate
	texcoord = gl_MultiTexCoord0;

  // Calculate the UP vector
	upVector = normalize(upPosition);

  // Calculate the sun vector
  sunVector = normalize(sunPosition);

  // Cast world time as a float
  worldTimef = worldTime;

  // Calculate attenuation
  solarAttenuation = SolarAttenuation();

  
}