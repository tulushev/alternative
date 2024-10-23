#![cfg_attr(target_arch = "spirv", no_std)]

use spirv_std::glam::{vec2, vec4, Vec2, Vec4, Vec4Swizzles};
use spirv_std::spirv;

const WHITE: Vec4 = vec4(1.0, 1.0, 1.0, 1.0);

#[derive(Copy, Clone)]
#[repr(C)]
pub struct ShaderState {
    pub translation: Vec2,
    pub zoom_level: f32,
}

#[spirv(fragment)]
pub fn main_fs(
    #[spirv(frag_coord)] in_frag_coord: Vec4,
    #[spirv(push_constant)] constants: &ShaderState,
    output: &mut Vec4,
) {
    let adjusted_position = in_frag_coord.xy() * constants.zoom_level + constants.translation;

    *output = make_ui().color(adjusted_position);
}

fn make_ui() -> impl Entity {
    Combine::new(
        Move::new(
            Vec2::new(10.0, 10.0),
            Rect::new(WHITE, Vec2::new(50.0, 20.0)),
        ),
        Move::new(
            Vec2::new(100.0, 100.0),
            Rect::new(WHITE, Vec2::new(10.0, 40.0)),
        ),
    )
}

trait Entity: Copy + Sized {
    fn color(&self, coord: Vec2) -> Vec4;
}

#[derive(Copy, Clone)]
struct Move<E: Entity> {
    amount: Vec2,
    entity: E,
}

impl<E: Entity> Move<E> {
    fn new(amount: Vec2, entity: E) -> Self {
        Self { amount, entity }
    }
}

impl<E: Entity> Entity for Move<E> {
    fn color(&self, coord: Vec2) -> Vec4 {
        self.entity.color(coord - self.amount)
    }
}

#[derive(Copy, Clone)]
struct Combine<A: Entity, B: Entity> {
    top: A,
    bottom: B,
}

impl<A: Entity, B: Entity> Combine<A, B> {
    fn new(top: A, bottom: B) -> Self {
        Self { top, bottom }
    }
}

impl<A: Entity, B: Entity> Entity for Combine<A, B> {
    fn color(&self, coord: Vec2) -> Vec4 {
        let a_color = self.top.color(coord);
        if a_color == Vec4::ZERO {
            self.bottom.color(coord)
        } else {
            a_color
        }
    }
}

#[derive(Copy, Clone)]
struct Rect {
    color: Vec4,
    size: Vec2,
}

impl Rect {
    fn new(color: Vec4, size: Vec2) -> Self {
        Self { color, size }
    }
}

impl Entity for Rect {
    fn color(&self, coord: Vec2) -> Vec4 {
        if coord.x >= 0.0 && coord.x <= self.size.x && coord.y >= 0.0 && coord.y <= self.size.y {
            self.color
        } else {
            Vec4::ZERO
        }
    }
}

#[spirv(vertex)]
pub fn main_vs(#[spirv(vertex_index)] vert_idx: i32, #[spirv(position)] builtin_pos: &mut Vec4) {
    // Create a "full screen triangle" by mapping the vertex index.
    // ported from https://www.saschawillems.de/blog/2016/08/13/vulkan-tutorial-on-rendering-a-fullscreen-quad-without-buffers/
    let uv = vec2(((vert_idx << 1) & 2) as f32, (vert_idx & 2) as f32);
    let pos = 2.0 * uv - Vec2::ONE;

    *builtin_pos = pos.extend(0.0).extend(1.0);
}
