// Methods to simulate the curvature of a sphear as applied to the world plane.
// Author: Chris McGhee (Nividica)

#ifndef __NIV_WORLDCURVE__
  #define __NIV_WORLDCURVE__()

  #include "../trig.glsl"

  // Apparently uniforms have better performance than consts
  uniform float curve_strengths[ 4 ] = {-4096, -2048, -1024, -512};

  // ApplyYCurvature
  //  Linearly adjusts the Y component of position based on the distance.
  //  The amount of change can be reduced via reduction.
  // Arguments:
  //  position: The vector to adjust.
  //  distance: How far the vector is from the origin.
  //  reduction: How much to divide the amount of change by.
  #define ApplyYCurvature(position,distance,reduction) position.y += (distance / reduction)

  // ApplyWorldCurvature
  //   Applies a linear curvature to the Y component of worldPosition that is based on
  //   the distance from the camera.
  // Arguments:
  //   relativePosition: Position the vertex is from the camera. This value is modified.
  #define ApplyWorldCurvature(viewPosition, worldPosition) ApplyYCurvature(worldPosition, max(SquareMagnitudeXZ(viewPosition) - WC_FLAT_ZONE, 0), curve_strengths[WC_AMOUNT])

#endif
