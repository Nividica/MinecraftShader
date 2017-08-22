// Common transformation calculations between spatial coordinate systems.
// Author: Chris McGhee (Nividica)

// Spaces
//   Local:  Coordinate system local to the object. Origin is often the objects center.
//   World:  Coordinate system that determines position in the world. This is what F3 shows.
//   View:   Coordinate system as seen from the camera.
//   Clip:   Coordinate system that determines what is visible based on a projection matrix.
//   Screen: Coordinate system that represents position on scren.

#ifndef __NIV_POS__
  #define __NIV_POS__()

  /**
   *  Local To View
   *  Arguments:
   *    localCoord: vec4
   *  Returns: vec4
   *  Example:
   *    vec4 vCoord = LocalToView(gl_Vertex)
   */
  #define Coords_LocalToView(localCoord) (gl_ModelViewMatrix * localCoord)

  /**
   *  View To Clipping
   *  Arguments:
   *    viewCoord: vec4
   *  Returns: vec4
   *  Example:
   *    gl_Position = ViewToClip(vCoord)
   */
  #define Coords_ViewToClip(viewCoord) (gl_ProjectionMatrix * viewCoord)

  /**
   *  Local To Clipping
   *  Arguments:
   *    localCoord: vec4
   *  Returns: vec4
   *  Example:
   *    gl_Position = LocalToClip(gl_Vertex)
   */
  #define Coords_LocalToClip(localCoord) Coords_ViewToClip(Coords_LocalToView(localCoord))

  /**
   *  View To World
   *  Arguments:
   *    viewCoord: vec4
   *  Returns: vec3
   *  Requires:
   *    uniform mat4 gbufferModelViewInverse
   *    uniform vec3 cameraPosition
   *  Example:
   *    vec3 worldPos = Coords_ViewToWorld(vCoord)
   */
  #define Coords_ViewToWorld(viewCoord) ((gbufferModelViewInverse * viewCoord).xyz + cameraPosition.xyz)

  /**
   *  World To View
   *  Arguments:
   *    worldCoord: vec3
   *  Returns: vec4
   *  Requires:
   *    uniform mat4 gbufferModelView
   *    uniform vec3 cameraPosition
   *  Example:
   *    vec3 vCoord = Coords_ViewToWorld(worldPos)
   */
  #define Coords_WorldToView(worldCoord) (gbufferModelView * vec4((worldCoord.xyz - cameraPosition.xyz).xyz, 1.0))

#endif
