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

struct main_fs_out
{
    float4 m_3 [[color(0)]];
};

fragment main_fs_out main_fs(constant _13& _12 [[buffer(0)]], float4 gl_FragCoord [[position]])
{
    main_fs_out out = {};
    float _52 = fma(gl_FragCoord.x, _12._m0._m1, _12._m0._m0.x);
    float _54 = fma(gl_FragCoord.y, _12._m0._m1, _12._m0._m0.y);
    bool _60;
    if (_52 > 100.0)
    {
        _60 = true;
    }
    else
    {
        _60 = _52 < (-100.0);
    }
    bool _65;
    if (_60)
    {
        _65 = true;
    }
    else
    {
        _65 = _54 > 100.0;
    }
    bool _70;
    if (_65)
    {
        _70 = true;
    }
    else
    {
        _70 = _54 < (-100.0);
    }
    if (_70)
    {
        out.m_3 = float4(0.0, 0.0, 0.0, 1.0);
    }
    else
    {
        out.m_3 = float4(1.0);
    }
    return out;
}

