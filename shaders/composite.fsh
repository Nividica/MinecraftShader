// Composes with final.
// Author: Chris McGhee (Nividica)

#version 120
#extension GL_ARB_shader_texture_lod : enable

// Engine Flags And Settings ===========================

// Enable the noise texture
const int noiseTextureResolution = 1024;

const bool shadowHardwareFiltering = true;

// Set color channels? Just a guess
const int R11F_G11F_B10F = 0;
const int RGBA16 = 0;
const int RGBA8 = 0;

// Set the formats
const int compositeFormat = RGBA16;
const int gcolorFormat = RGBA16;

const float		sunPathRotation				= -40.0; //[-50.0 -40.0 -30.0 -20.0 -10.0 0.0 10.0 20.0 30.0 40.0 50.0]

// =====================================================

// Defines

#define IS_UNDERWATER (isEyeInWater == 1)
#define IS_UNDERLAVA  (isEyeInWater == 2)

// Uniforms

// Color of the scene thus far.
uniform sampler2D gcolor;

// Noise texture (randomness)
uniform sampler2D noisetex;

// Depth textures
uniform sampler2D gdepthtex;
uniform sampler2D depthtex1;

// Inverted projection matrix
uniform mat4 gbufferProjectionInverse;

// Inverted Model(world) matrix
uniform mat4 gbufferModelViewInverse;

// Position of the camera in the world
uniform vec3 cameraPosition;

// How many frames have gone by
uniform float frameTimeCounter;

// The percent strength of the rain
uniform float rainStrength;

// Is the camera in a liquid?
uniform int isEyeInWater;

// Time of day
// 0...11999 = day
// 12000...24000 = night
uniform int worldTime;
float timefract = worldTime;

// Inputs / Outputs

// Texture coordinate
in vec4 texcoord;

// Vector that points up in the world
in vec3 upVec;

// Private vars

// Includes

// Methods
/*
mat3 transform(float x, float y, float angle){
  return mat3(
    cos(angle), -sin(angle), x,
    sin(angle), cos(angle), y,
    0, 0, 1
  );
}
}*/

// Main
void main(){

  // Get the color rendered thus far
  vec3 color = texture2D(gcolor, texcoord.st).rgb;

  // Get the depth of this fragment
  // Depth is the nearest object, even if it's transparent.
  float fDepth = texture2D(gdepthtex, texcoord.st).x;
  
  // Get the depth of the furthest visible object
  // Depth is nearest object, excluding transparent objects.
  float vDepth = texture2D(depthtex1, texcoord.st).x;

  // Is the fragment part of the sky?
  if(vDepth == 1.0)
  {
    // Calculate the fragment position in the projection space
    vec4 projectionVector = gbufferProjectionInverse * vec4(vec3(texcoord.st, vDepth) * 2.0 - 1.0, 1.0);

    // Adjust if under water
	  if (IS_UNDERWATER){ projectionVector.xy *= 0.817; }

    // Map back to the pre-projection plane
    projectionVector /= projectionVector.w;

    // Normalize position
    projectionVector = normalize( vec4(projectionVector.xyz, 0.0) );
    // fPosition

    // Calculate the fragment position in the world space
    vec3 worldPosition = (gbufferModelViewInverse * projectionVector).xyz;
    // tPos

    // Normalize position
    vec3 worldVector = normalize(worldPosition);
    // wVec
    
    // Not really sure...
    // The dot product of the fragment position and the up vector.. What does this net us?
    float cosT = clamp( dot(projectionVector.xyz, upVec), 0.0, 1.0);

    // Simulate wind
    // frameTimeCounter * X: As X increases, so does movement.
    vec2 wind = abs(vec2(frameTimeCounter * 0.000025));

    // Calculate inverted rain strength
    float rainStrengthInverse = 1.0 - rainStrength;
    
    // The higher this value, the more coverage there is
    float cloudCoverage = 1;

    // Values > 1 Make clouds appear translucent in their centers.
    float cloudDensity = 1;// - (rainStrength * 0.5) ;
    
    int itterations = 3;

    const float cloudHeight = 600.0;
    
    // The higher this number, the more the clouds move as the camera does
    const float cameraOffsetMultiplier = ( cloudHeight / 240.0 );

    float height = (cloudHeight / worldVector.y);

    // Loop accumulators
    float totalcloud = 0;  
    float noise = 0;
    float density = 0;

    // Positions
    vec2 coord = vec2(0);
    vec3 cloudPosition = vec3(0.0);

    for (int i = 0; i < itterations; i++){

      // Calculate cloud position
      cloudPosition = worldVector * (height - ((i * 150) / itterations * (1.0 - pow(cosT, 20.0))));

      coord = (cloudPosition.xz + cameraPosition.xz * ( cloudHeight / 240.0 ) ) * 0.000005;
      coord += wind * (1 + ( 2 * ( itterations - 1 - i ) ) );

      
      // Start by building an additive noise map
      noise = texture2D(noisetex, coord - wind ).x;
      noise += texture2D(noisetex, coord  * 3.5).x / 3.0;
      noise += texture2D(noisetex, coord  * 6.125).x / 6.125;
      noise += texture2D(noisetex, coord * 12.25).x / 12.25;

      // Standard coverage amount
      // Remove gaps while raining
      noise /= 1.0 + ( rainStrengthInverse * (texture2D(noisetex, coord / 6.1).x - 1.0) );
      noise /= 0.23 * cloudCoverage;

      float cOpacity = max(noise - 0.1, 0.0) * 0.04;
      density = pow( max(1.0 - cOpacity * 2.5 , 0.0) , 2.0) / 90.0;
      density *= 2.0 * cloudDensity;

      totalcloud += density;
    }

    // While raining, max out density
    density *= rainStrengthInverse;

    // Take the average of all cloud itterations
    totalcloud /= itterations;

    // Adjust total cloud by density
    totalcloud = mix(totalcloud , 0.0, pow( 1.0 - density, 100.0 ) - rainStrength );

    vec3 cloudCol = vec3(1.0);
    cloudCol *= 1.0
    // Color amount based on density of the cloud
    + ( pow(1.0 - density, 25.0) * 10.0 )
    // Make cloud edges whiter
    * ( 1.0 + ( 3.0
      // As cloud density drops off, increase density exponentialy
      * pow(1.0 - totalcloud, 200.0)
      // Reduce this effect as rain starts to prevent very noticeable hard edges forming as the clouds collapse
      * rainStrengthInverse
      ));

    // The Y axis value
    float yHeight = clamp( pow( worldVector.y, 0.5 ), 0.0, 1.0 );

    color /= 1.0 + rainStrength;

    color = pow(mix(pow(color, vec3(2.2)), pow(cloudCol, vec3(2.2)), totalcloud * 0.25 * yHeight), vec3(0.4545));
    
  }
  
  

  

  //color = mix(color,vec3(totalcloud), totalcloud);
  
  gl_FragData[0] = vec4(color,1.0);
}