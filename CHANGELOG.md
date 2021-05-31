Version History
---------------

### Changes in v2.5.3. (24.05.2021)

Major changes:

Improved:
-   Update Intel Denoise to v1.4.0.

Fixed:
-   NaN pixels.

Restrictions:
-   Discontinued support for 3D Max 2017.
-   So far only for 3ds Max 2020 - 2022.


### Changes in v2.5.2. (29.01.2021)

Major changes:
-   Added neural network Intel denoise.
-   Support 2022 3ds max. (26.04.2021)

Improved:
-   Multisampling for the rendering element: color and normal pass.
-   The normal pass takes into account the bump.

Fixed:
-   Incorrect color of the render element: normal pass.

Restrictions:
-   So far only for 3ds Max 2020 - 2022.


### Changes in v2.5.1. (03.12.2020)

Major changes:
-   Added "Vibrance" to the post process.

Improved:
-   Contrast and uniform contrast in a more correct color space.
-   Uniform Contrast works more gently, avoiding banding.

Fixed:
-   Incorrect locking GUI of the anisotropy.
-   In white balance, color distortion on bright areas.

Restrictions:


### Changes in 2.5 (25.05.2020)

Major changes:
- Plugin for 3ds max 2021.
- Anisotropic BRDF: Beckmann and TRGGX.
- Multiscattered GGX (reflections and refractions).
- Falloff.
- Blended box (triplanar mapping).
- Ambient occlusion (AO, dirt).
- DOF for IBPT and MMLT (there are still some small artifacts).
- Clamp for noise reduction.
- Support for disabling texture filtering (important for rotation anisotropy textures).

Improved:
- Hydra light stands out better.
- Contrast in the post process does not saturate the color.
- A large number of materials does not slow down the material editor.
- Displaying Back/Env in material editor.
- Output messages to the render console.
- Some fixes for broken polygons and vertexes, with warnings about this.

Fixed:
- When the render falls, max freezes.
- In the transparency of the material with the Back/Envir node, the background is not visible.
- Nan pixels with a normal map.
- Different brightness of the Hydra light in different system units of the scene.
- Max drops when the sun's Hydra rotates through the interface.
- Hydra light disappears in the viewport.
- All sorts of small bugs.

Restrictions:
- Falloff, blended box, and AO cannot be embedded in each other.
- The Blended box is displayed as a normal texture in the viewport.
- Blended box for relief (bump) in development.
- Only 2 AO cards with different parameters per material.
