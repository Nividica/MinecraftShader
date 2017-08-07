// 
// Author: Chris McGhee (Nividica)

uniform float curve_strengths[ 4 ] = {-4096, -2048, -1024, -512};

float HorizontalDistance(vec4 position){
  return (position.x * position.x) + (position.z * position.z);
}

void ApplyVerticalCurvature(inout vec4 position, float distanceFromCenter, float reduction){
  position.y += distanceFromCenter / reduction;
}

void ApplyWorldCurvature(inout vec4 positionRelativeToCamera){
  float strength = curve_strengths[WORLD_CURVATURE_AMOUNT];
  ApplyVerticalCurvature(positionRelativeToCamera, HorizontalDistance(positionRelativeToCamera), strength);
}