// Common position calculations
// Author: Chris McGhee (Nividica)

#ifndef __NIV_POS__
  #define __NIV_POS__()

  // RelativePosition
  //   Position where the camera is the origin.
  #define RelativePosition() (gl_ModelViewMatrix * gl_Vertex)
    
  // WorldPosition
  //   Position where the world coord (0,0,0) is the origin.
  // Requires:
  //   uniform vec3 cameraPosition;
  // Arguments:
  //   relativePosition: Relative Position, can be calculated with the RelativePosition macro.
  #define WorldPosition(relativePosition) (relativePosition.xyz + cameraPosition.xyz)

  // ClipPosition
  //   Position in the clipping space. This will most commonly be used to set gl_Position.
  // Requires:
  //   uniform mat4 gbufferModelView;
  // Arguments:
  //   relativePosition: Relative Position, can be calculated with the RelativePosition macro.
  #define ClipPosition(relativePosition) (gl_ProjectionMatrix * relativePosition)

#endif
