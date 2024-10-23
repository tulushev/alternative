# alternative
Alternative CG Experiments

The goal of this project is to explore alternative ways of rendering GUI's, game graphics and generative art.

The current issues I see:

- [All shading languages suck](https://xol.io/blah/death-to-shading-languages/)
- GUI's are still rendered and/or composited on the CPU
- Game graphics still renders triangles, while raymarching and differential geometry tools are mostly unused
- Color representation is unaware of decades of scientific research in color perception and color appearance models

Some projects that I'm going to explore next:

- [x] Use a general purpose language (Rust through `rust-gpu` is chosen) to write shaders (Metal is chosen through SPIRV-Cross)
- [ ] Render GUI's solely in the fragment shader. Metal and macOS is chosen for convenience, but the idea is universal. 
- [ ] Explore raymarching for both GUI's and 3D rendering. Develop a simple 3D editor for SDF functions.
- [ ] Explore NURBS rendering by combining latest research on physical based rendering with purely NURBS renderers.
- [ ] Port CAM16 to Metal Shading Language or precompute CAM-UCS space into textures for shader interpolation. 

# Try it yourself

## Prerequisites
- `Rust` language (Install using [rustup](https://www.rust-lang.org/tools/install))
- `macOS` (I used 15.0.1 but may work on lower versions) running on M series architecture (I haven't tested this on Intel, but it may work)
- `homebrew` for installing `just` below
- `just` command runner (Install using `homebrew` with `brew install just`). Alternatively just copy paste all commands from the `justfile` and execute in your terminal of choice
- `Xcode` (I used version 16, but may work on lower versions)

## Running
- Clone the repo including submodules with `git clone --recurse-submodules -j8 git@github.com:tulushev/alternative.git` then `cd alternative`
- Run `just setup`. This will compile `rust-gpu` and `SPIRV-Cross` and will update the `shader` config to point to the correct directory of `rust-gpu`. This is done once
- Run `just build`. This will compile Rust `shaders` using `rust-gpu`, transpile them to Metal using `SPIRV-Cross`, and place them into the project directory
- Open alternative.xcodeproj, select `My Mac` as running target and hit the Play button, this will run the app
