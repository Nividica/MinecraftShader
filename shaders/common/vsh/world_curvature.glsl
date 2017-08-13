// 
// Author: Chris McGhee (Nividica)

uniform float curve_strengths[ 4 ] = {-4096, -2048, -1024, -512};

float HorizontalDistance(vec3 position){
  return (position.x * position.x) + (position.z * position.z);
}

void ApplyVerticalCurvature(inout vec3 position, float distanceFromCenter, float reduction){
  position.y += distanceFromCenter / reduction;
}

void ApplyWorldCurvature(inout vec3 worldPosition, in vec4 relativePosition){
  float strength = curve_strengths[WC_AMOUNT];
  float distanceH = max(HorizontalDistance(relativePosition.xyz) - WC_FLAT_ZONE, 0);
  ApplyVerticalCurvature(worldPosition, distanceH, strength);
}