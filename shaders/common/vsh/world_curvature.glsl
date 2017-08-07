// 
// Author: Chris McGhee (Nividica)

float HorizontalDistance(vec4 position){
  return (position.x * position.x) + (position.z * position.z);
}

void ApplyVerticalCurvature(inout vec4 position, float distanceFromCenter, float reduction){
  position.y += distanceFromCenter / reduction;
}

void ApplyWorldCurvature(inout vec4 positionRelativeToCamera){
  ApplyVerticalCurvature(positionRelativeToCamera, HorizontalDistance(positionRelativeToCamera), -2048);
}