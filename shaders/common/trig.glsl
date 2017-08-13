// Common trig functions
// Author: Chris McGhee (Nividica)

#ifndef __NIV_TRIG__
  #define __NIV_TRIG__()

  // ========== Square Magnitude / Distance ==========
  // Squared-magnitude requires less computation the magnitude as a SquareRoot operation does not need to be performed.

  // SquareMagnitudeTwo
  //   The magnitude, or distance, from the origin, squared.
  // Arguments:
  //   c1: Coordinate 1
  //   c2: Coordinate 2
  #define SquareMagnitudeTwo(c1,c2) ((c1*c1)+(c2*c2))

  // SquareMagnitudeThree
  //   The magnitude, or distance, from the origin, squared.
  // Arguments:
  //   c1: Coordinate 1
  //   c2: Coordinate 2
  //   c3: Coordinate 2
  #define SquareMagnitudeThree(c1,c2,c3) ((c1*c1)+(c2*c2)+(c3*c3))

  // SquareMagnitudeXY
  //   The magnitude, or distance, from the origin, squared.
  // Arguments:
  //   v: Vector, having X and Y components
  #define SquareMagnitudeXY(v) SquareMagnitudeTwo(v.x,v.y)

  // SquareMagnitudeXZ
  //   The magnitude, or distance, from the origin, squared.
  // Arguments:
  //   v: Vector, having X and Z components
  #define SquareMagnitudeXZ(v) SquareMagnitudeTwo(v.x,v.z)

  // SquareMagnitudeYZ
  //   The magnitude, or distance, from the origin, squared.
  // Arguments:
  //   v: Vector, having Y and Z components
  #define SquareMagnitudeYZ(v) SquareMagnitudeTwo(v.y,v.z)

  // SquareMagnitudeXYZ
  //   The magnitude, or distance, from the origin, squared.
  // Arguments:
  //   v: Vector, having X, Y and Z components
  #define SquareMagnitudeXYZ(v) SquareMagnitudeThree(v.x,v.y,v.z)

  // ========== Magnitude / Distance ==========
  // Magnitude requires more computation than squared-magnitude as a SquareRoot operation does need to be performed.

  // MagnitudeTwo
  //   The magnitude, or distance, from the origin.
  // Arguments:
  //   c1: Coordinate 1
  //   c2: Coordinate 2
  #define MagnitudeTwo(c1,c2) sqrt(SquareMagnitudeTwo(c1,c2))

  // MagnitudeThree
  //   The magnitude, or distance, from the origin.
  // Arguments:
  //   c1: Coordinate 1
  //   c2: Coordinate 2
  //   c3: Coordinate 2
  #define MagnitudeThree(c1,c2,c3) sqrt(SquareMagnitudeThree(c1,c2,c3))

  // MagnitudeXY
  //   The magnitude, or distance, from the origin.
  // Arguments:
  //   v: Vector, having X and Y components
  #define MagnitudeXY(v) MagnitudeTwo(v.x,v.y)

  // MagnitudeXZ
  //   The magnitude, or distance, from the origin.
  // Arguments:
  //   v: Vector, having X and Z components
  #define MagnitudeXZ(v) MagnitudeTwo(v.x,v.z)

  // MagnitudeYZ
  //   The magnitude, or distance, from the origin.
  // Arguments:
  //   v: Vector, having Y and Z components
  #define MagnitudeYZ(v) MagnitudeTwo(v.y,v.z)

  // MagnitudeXYZ
  //   The magnitude, or distance, from the origin.
  // Arguments:
  //   v: Vector, having X, Y and Z components
  #define MagnitudeXYZ(v) MagnitudeThree(v.x,v.y,v.z)
  
#endif
