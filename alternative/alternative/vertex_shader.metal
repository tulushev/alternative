#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct _11
{
    float2 _m0;
    float _m1;
};

struct _13
{
    _11 _m0;
};

struct main_vs_out
{
    float4 gl_Position [[position]];
};

vertex main_vs_out main_vs(uint gl_VertexIndex [[vertex_id]])
{
    main_vs_out out = {};
    out.gl_Position = float4(fma(2.0, float((int(gl_VertexIndex) << 1) & 2), -1.0), fma(2.0, float(int(gl_VertexIndex) & 2), -1.0), 0.0, 1.0);
    return out;
}

