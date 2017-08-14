// Composes with final.
// Author: Chris McGhee (Nividica)

#version 130

// Defines
#define Rescale(c,a) clamp(c-a,0.0,1.0)*(1.0/(1.0-a))

// Uniforms
// Color of the scene thus far.
uniform sampler2D gcolor;

// Depth of the scene.
uniform sampler2D depthtex1;

// Noise texture generated by minecraft.
uniform sampler2D noisetex;

uniform mat4 gbufferProjectionInverse;

uniform mat4 gbufferModelViewInverse;

// The position of up.
uniform vec3 upPosition;

// The position of the sun.
uniform vec3 sunPosition;

// The position of the moon.
uniform vec3 moonPosition;

// Position of the camera in the world.
uniform vec3 cameraPosition;

// Increments once per frame (I think).
uniform float frameTimeCounter;

// How hard is it raining.
uniform float rainStrength;

// 0 = Not in liquid
// 1 = Under Water
// 2 = Under Lava
uniform int isEyeInWater;

// 0...11999 = day
// 12000...24000 = night
uniform int worldTime;


// Inputs / Outputs

// Texture coordinate
in vec4 texcoord;

// Includes

// Private variables
float pixeldepth2 = texture2D(depthtex1, texcoord.st).x;

// True When the camera is under water
bool IsEyeUnderWater = (isEyeInWater == 1);

// True When the camera is in lava
bool IsEyeUnderLava = (isEyeInWater == 2);

// True when the fragment is part of the sky.
// False otherwise.
bool skyFrag = (pixeldepth2 == 1.0);

// Vector pointing in the UP direction.
vec3 upVec = normalize(upPosition);

// Vector pointing at the sun.
vec3 sunVec = normalize(sunPosition);

// Vector pointing at the moon.
vec3 moonVec = normalize(moonPosition);

vec4 getFragpos2(){

	vec4 fragpos = gbufferProjectionInverse * vec4(vec3(texcoord.st, pixeldepth2) * 2.0 - 1.0, 1.0);
	if (IsEyeUnderWater)
		fragpos.xy *= 0.817;

	return (fragpos / fragpos.w);
}

vec4 fragpos2 = getFragpos2();

float timefract = worldTime;

mat2 time = mat2(vec2(
				((clamp(timefract, 23000.0f, 25000.0f) - 23000.0f) / 1000.0f) + (1.0f - (clamp(timefract, 0.0f, 2000.0f)/2000.0f)),
				((clamp(timefract, 0.0f, 2000.0f)) / 2000.0f) - ((clamp(timefract, 9000.0f, 12000.0f) - 9000.0f) / 3000.0f)),

				vec2(

				((clamp(timefract, 9000.0f, 12000.0f) - 9000.0f) / 3000.0f) - ((clamp(timefract, 12000.0f, 12750.0f) - 12000.0f) / 750.0f),
				((clamp(timefract, 12000.0f, 12750.0f) - 12000.0f) / 750.0f) - ((clamp(timefract, 23000.0f, 24000.0f) - 23000.0f) / 1000.0f))
);	//time[0].xy = sunrise and noon. time[1].xy = sunset and mindight.

float transition_fading = 1.0-(clamp((timefract-12000.0)/300.0,0.0,1.0)-clamp((timefract-13000.0)/300.0,0.0,1.0) + clamp((timefract-22000.0)/200.0,0.0,1.0)-clamp((timefract-23400.0)/200.0,0.0,1.0));


// Methods
vec4 getWorldSpace(vec4 fragpos){

	return gbufferModelViewInverse * fragpos;
}


float subSurfaceScattering(vec3 lPos, vec3 uPos, float size){
  return pow(clamp(dot(lPos, uPos),0.0,1.0),size);
}

void ApplyClouds(inout vec3 color, in vec3 fpos, in int itterations){
  if (!skyFrag){ return; }

  // Calculate the speed of the wind
  vec2 wind = abs(vec2(frameTimeCounter / 20000.0));

  //Cloud Generation Constants.
  const float cloudHeight = 600.0;
  const float sunsetTime = 12700.0;
  const float sunriseTime = 22700.0;
  
  float noise = 1.0;

  // Normalize fragment position. (Why?)
  vec4 fposition = normalize(vec4(fpos,0.0));

  // Convert to world space. (Why?)
  vec3 tPos = getWorldSpace(fposition).rgb;

  // Normalize world space. (Why?)
  vec3 wVec = normalize(tPos);
  
  // No idea
  float cosT = clamp(dot(fposition.rgb,upVec),0.0,1.0);

  // Again, no idea
  float cosSunUpAngle = clamp(smoothstep(-0.05,0.5,dot(sunVec, upVec)* 0.95 + 0.05) * 10.0, 0.0, 1.0);

  vec3 sunlight = vec3(1.0, 0.9, 0.0);
  vec3 moonlight = vec3(0.8,0.8,1.0);

  // Cloud color
  vec3 cloudCol = mix(mix(sunlight, moonlight, time[1].y), vec3(0.1) * (1.0 - time[1].y * 0.9), rainStrength) * (1.0 - (time[1].x + time[0].x) * 0.5);
  cloudCol *= mix(1.0, 0.5, rainStrength * time[1].y);

  float height = (cloudHeight / wVec.y);

  float weight = 0.0;
  float density = 0.0;
  float totalcloud = 0.0;

  vec3 cloudPosition = vec3(0.0);
  
  if (cosT <= 1.0) {
    for (int i = 0; i < itterations; i++){

      cloudPosition = wVec * (height - i * 150 / itterations * (1.0 - pow(cosT, 2.0)));

      vec2 coord = (cloudPosition.xz + cameraPosition.xz * 2.5) / 200000.0;
        coord += wind;

      noise = texture2D(noisetex, coord - wind * 0.25).x;
      noise += texture2D(noisetex, coord * 3.5).x / 3.5;
      noise += texture2D(noisetex, coord * 6.125).x / 6.125;
      noise += texture2D(noisetex, coord * 12.25).x / 12.25;
      noise /= clamp(texture2D(noisetex,coord / 3.1).x * 1.0,0.0,1.0);

      float CLOUD_COVERAGE = 1.0;
      noise /= (0.13 * CLOUD_COVERAGE);

      float cl = max(noise-0.7,0.0);
      cl = max(cl,0.)*0.04 * (1.0 - rainStrength * 0.5);
      density = pow(max(1-cl*2.5,0.),2.0) / 11.0 / 3.0;
      float CLOUD_DENSITY = 1.0;
      density *= 2.0 * CLOUD_DENSITY;

      totalcloud += density;
      if (totalcloud > (1.0 - 1.0 / itterations + 0.1)) break;

      weight++;
    }
  }

  totalcloud /= weight;
  totalcloud = mix(totalcloud,0.0,pow(1-density, 100.0));

  float sss = subSurfaceScattering(moonVec, fposition.rgb, 50.0) * (1.0 - rainStrength);

  cloudCol = mix(cloudCol, sunlight * 10.0,
  pow(cosT, 0.5) * subSurfaceScattering(sunVec, fposition.rgb, 15.0) * pow(1.0 - density, 100.0) * (1.0 - rainStrength) * cosSunUpAngle);
  
  cloudCol *= 1.0 + pow(1.0 - density, 25.0) * 5.0 * (1.0 + sss * 10.0 * pow(1.0 - totalcloud, 200.0) * transition_fading * (1.0 - rainStrength) * pow(cosT, 0.5));
  
  // Twilight effects
  /*
  float CIVIL_TWILIGHT_PERIOD = 2000;
  float sunsetTriangle = clamp(1.0 - abs((worldTime-sunsetTime)/CIVIL_TWILIGHT_PERIOD), 0.0, 1.0);
  float sunriseTriangle = clamp(1.0 - abs((worldTime-sunriseTime)/CIVIL_TWILIGHT_PERIOD), 0.0, 1.0);
  vec3 twiColor = clamp(tPos.rgb,0.0,1.0) * (1.0 - rainStrength);
  twiColor.b *= 0.5;
  cloudCol.rgb = mix(cloudCol.rgb, twiColor, (sunriseTriangle+sunsetTriangle)*0.9);*/

  color = pow(mix(pow(color, vec3(2.2)), pow(cloudCol, vec3(2.2)),totalcloud * cosT * 0.25), vec3(0.4545));

}

// Main
void main(){
  vec3 color = texture2D(gcolor, texcoord.st).rgb;

  ApplyClouds(color, fragpos2.rgb, 3);

  //color = pow(color, vec3(0.4545));
  
  gl_FragData[0] = vec4(color,1.0);
}