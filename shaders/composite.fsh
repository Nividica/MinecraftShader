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

// The higher this value, the more coverage there is
#define CloudCoverage 1

// Values > 1 Make clouds appear translucent in their centers.
#define CloudDensity 1

// The perceived height the clouds are above the camera.
#define CloudHeight 600.0

// Number of times to generate clouds
// Each pass changes the plane the clouds are generated on slightly.
#define CloudPasses 3

// True if the camera is under water
#define IsUnderwater (isEyeInWater == 1)

// True if the camera is under lava
#define IsUnderLava  (isEyeInWater == 2)

// How much to refract they sky by while under water
#define WaterRefractionIndex 0.817

// Time constants
#define TimeSunrise 0.0
#define TimeNoon 6000.0
#define TimeSunset 12000.0

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

// Position of the sun in the world
//uniform vec3 sunPosition;

// How many frames have gone by
uniform float frameTimeCounter;

// The percent strength of the rain
uniform float rainStrength;

// Is the camera in a liquid?
uniform int isEyeInWater;

// Inputs / Outputs

// Texture coordinate
in vec4 texcoord;

// Vector that points up in the world
in vec3 upVector;

// Vector that points toward the sun
in vec3 sunVector;

// World time
in float worldTimef;

// Private vars

// Includes
#include "./common/config.glsl"

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

vec4 CalculateProjectionVector(float vDepth){
  // Calculate the fragment position in the projection space
  vec4 projectionVector = gbufferProjectionInverse * vec4( ( vec3(texcoord.st, vDepth) * 2.0 ) - 1.0, 1.0 );

  // Adjust if under water
  if (IsUnderwater){ projectionVector.xy *= WaterRefractionIndex; }

  // Map back to the pre-projection plane
  projectionVector /= projectionVector.w;

  // Normalize position
  return normalize( vec4(projectionVector.xyz, 0.0) );
}

// Attenuate the brightness of the bloom based on time of day.
// Graph: https://www.desmos.com/calculator/vsqt87vjno
// 2022.5 comes from: https://www.wolframalpha.com/input/?i=solve+6000+-+pow(++(+12000-6000+)+%2F+x,+8+)  
float SkyBrightnessAttenuationBasedOnTime() { // Boy thats a mouthfull
  return ( 
    (
      // Subtract 6000 to invert the curve ( 6000 @ noon, 0 at sunrise and sunset )
      TimeNoon - pow( 
        (
          // Clamp the time between sunrise and sunset
          abs( clamp( worldTimef, TimeSunrise, TimeSunset ) - TimeNoon )
          // Divide by the magic number such that the result of pow is 
          // 6000 @ sunrise and sunset, and 0 at noon.
          / 2022.5
        )
      , 8)
    )
    // Normalize such that 1.0 @ noon, 0.0 at sunrise and sunset
    / TimeNoon
  );
}

float AddClouds(inout vec3 color, float vDepth, vec3 worldVector, float skyDome){
  // Simulate wind
  // frameTimeCounter * X: As X increases, so does movement.
  vec2 wind = abs(vec2(frameTimeCounter * 0.000025));

  // Calculate inverted rain strength
  float rainStrengthInverse = 1.0 - rainStrength;
  
  // The higher this number, the more the clouds move as the camera does
  const float CameraMovementStrength = ( CloudHeight / 240.0 );

  float height = (CloudHeight / worldVector.y);

  // Loop accumulators
  float totalcloud = 0;  
  float noise = 0;
  float density = 0;

  // Positions
  vec2 coord = vec2(0);
  vec3 cloudPosition = vec3(0.0);

  for (int i = 0; i < CloudPasses; i++){

    // Calculate cloud position
    cloudPosition = worldVector * (height - ((i * 150) / CloudPasses * (1.0 - pow(skyDome, 20.0))));

    // Calculate the base coordinate to sample the noise texture from
    coord = ( cloudPosition.xz
      // As the camera moves, move the clouds in the opposite direction
      + ( cameraPosition.xz * CameraMovementStrength )
    ) * 0.000005;

    // Add wind
    coord += wind * (1 + ( 
      // Earlier cloud passes get more wind
      ( CloudPasses - 1 - i )
      // Wind multipler for layers
      * 2
    ));

    // Build an additive noise map
    noise = texture2D(noisetex, coord - wind ).x;
    noise += texture2D(noisetex, coord  * 3.5).x / 3.0;
    noise += texture2D(noisetex, coord  * 6.125).x / 6.125;
    noise += texture2D(noisetex, coord * 12.25).x / 12.25;

    // Sample the noise map to produce a 'coverage' map
    // High noise value decrease coverage, and low values increase it
    noise /= 1.0 + (
    // Remove gaps while raining
      rainStrengthInverse
      * (texture2D(noisetex, coord / 6.1).x - 1.0)
    );

    // Adjust coverage
    noise /= 0.23 * CloudCoverage;

    float cOpacity = max(noise - 0.1, 0.0) * 0.04;
    density = pow( max(1.0 - cOpacity * 2.5 , 0.0) , 2.0) / 90.0;
    density *= 2.0 * CloudDensity;

    totalcloud += density;
  }

  // While raining, max out density
  density *= rainStrengthInverse;

  // Take the average of all cloud CloudPasses
  totalcloud /= CloudPasses;

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

  // Mix in clouds
  vec3 powedColor = pow(cloudCol, vec3(2.2));
  color = pow(mix(pow(color, vec3(2.2)), powedColor, totalcloud * 0.25 * skyDome ), vec3(0.4545));

  return ( (90 * density) + rainStrength );
}

void AddCelestialObjects(inout vec3 color, vec4 projectionVector, float translucent, float cloudDensity, float skyDome, float timeAttenuation){
  float sunPositionIntensity = dot( projectionVector.xyz, sunVector );
  const float sunSize = 0.0015;

  // The disk in the sky
  float sunCoreOpacity = float(sunPositionIntensity > 1.0 - sunSize);

  // Don't draw core on top of translucent objects
  sunCoreOpacity *= 1.0 - ( 0.5 * translucent );
    
  // Sky brightness around the core
  float sunBloomOpacity = timeAttenuation * (sunPositionIntensity / 2.0 );
  
  // Hide the sun behind clouds
  cloudDensity *= skyDome;
  sunCoreOpacity *= 1.0 - clamp( pow(cloudDensity + 0.2, 5) , 0.0, 1.0);
  sunBloomOpacity *= 1.0 - cloudDensity;

  // Hide the sun behind the horizon
  skyDome = clamp( log(skyDome * 30.0), 0.0, 1.0 );

  // Base color
  vec3 sunColor = vec3( 1.0, 1.0, 0.95 );

  color = mix( color, sunColor, skyDome * clamp(sunCoreOpacity + sunBloomOpacity, 0.0, 1.0) );
}

// Main
void main(){

  // Get the color rendered thus far
  vec3 color = texture2D(gcolor, texcoord.st).rgb;

  // Fragment Depth
  // Depth is the nearest object, even if it's transparent.
  float fDepth = texture2D(gdepthtex, texcoord.st).x;
  
  // View Depth
  // Depth is nearest object, excluding transparent objects.
  float vDepth = texture2D(depthtex1, texcoord.st).x;

  // Is the fragment part of the sky?
  if(vDepth == 1.0)
  {
    // Calculate the projection vector
    vec4 projectionVector = CalculateProjectionVector(vDepth);

    // Calculate the fragment position in the world space
    vec3 worldPosition = (gbufferModelViewInverse * projectionVector).xyz;

    #ifdef WORLD_CURVATURE
      worldPosition.y += 0.1 * WC_AMOUNT;
    #endif

    // Normalize world position
    vec3 worldVector = normalize(worldPosition);

    // Calculate attenuation
    float timeAttenuation = SkyBrightnessAttenuationBasedOnTime();

    // Calculate sky dome opacity
    // These produce simular numbers.
    //  Where the 'higher' in the sky (more above the players head) the higher the value
    //  1.0 Directly above the players head, and 0.0 at/near the horizon
    //float cosT = clamp( dot(projectionVector.xyz, upVector), 0.0, 1.0);
    //float yHeight = min(max(worldVector.y - 0.2, 0.0 ) * 5, 1.0); // 5 = 1 / 0.2
    float skyDome = clamp(worldVector.y, 0.0, 1.0);

    // Is this fragment behind a translucent object?
    float translucent = float(vDepth > fDepth);

    // Draw clouds and get the density of the clouds at this point
    float cloudDensity = AddClouds(color, vDepth, worldVector, skyDome);

    // Draw sun, moon, etc
    AddCelestialObjects(color, projectionVector, translucent, cloudDensity, skyDome, timeAttenuation);
    
  }

  //color.r = texcoord.t;
  
  gl_FragData[0] = vec4(color,1.0);
}