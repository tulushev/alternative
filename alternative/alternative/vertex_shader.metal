#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct VertexOut {
    float4 position [[position]];
};

// Vertex shader for generating a full-screen triangle
vertex VertexOut main_vs(uint vertex_id [[vertex_id]]) {
    VertexOut out;

    // Calculate the position for the full-screen triangle
    float2 uv = float2(((vertex_id << 1) & 2), (vertex_id & 2));
    float2 pos = 2.0 * uv - float2(1.0);

    // Set the position for the vertex
    out.position = float4(pos, 0.0, 1.0);
    return out;
}
