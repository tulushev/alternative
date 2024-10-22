# alternative
Alternative CG Experiments

The goal of this project is to explore alternative ways of rendering GUI's, game graphics and generative art.

The current issues I see:

- GUI's are still rendered and/or composited on the CPU
- Game graphics still renders triangles, while raymarching and differential geometry tools are mostly unused
- Color representation is unaware of decades of scientific research into color perception and color appearance models

Some projects that I'm going to explore next:

- [ ] Render GUI's solely in the fragment shader. Metal and macOS is chosen for convenience, but the idea is universal. 
- [ ] Explore raymarching for both GUI's and 3D rendering. Develop a simple 3D editor for SDF functions.
- [ ] Explore NURBS rendering by combining latest research on physical based rendering with purely NURBS renderers.
- [ ] Port CAM16 to Metal Shading Language or precompute CAM-UCS space into textures for shader interpolation. 
