
#define Tonemap
  #define Tonemap_Red 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0] Red Intensity
  #define Tonemap_Green 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0] Green Intensity
  #define Tonemap_Blue 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0] Blue Intensity

#define FOG_THICKNESS 1.0 // [0.125 0.25 0.5 1.0 2.0 4.0 8.0 16.0]
#define FOG_DISTANCE 1.0 // [0.125 0.25 0.5 1.0 1.25 1.5 1.75 2.0]

#define WORLD_CURVATURE // Enable world curvature
  #define WC_AMOUNT 1 // [0 1 2 3] World curvature amount. 0: Minimal 3: Extreme
  #define WC_FLAT_ZONE 400 //[0 200 400 800 1600] Area around the player that will not be world curved.