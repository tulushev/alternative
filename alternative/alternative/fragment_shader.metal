#include <metal_stdlib>
#include <simd/simd.h>
#include "ShaderTypes.h"

using namespace metal;

// Output color struct for the fragment shader
struct FragmentOut {
    float4 color [[color(0)]];
};

// Fragment shader
fragment FragmentOut main_fs(constant ShaderState& state [[buffer(0)]], float4 fragCoord [[position]]) {
    FragmentOut out;

    // Adjust fragment coordinates using zoom and translation
    float2 adjustedPosition = fragCoord.xy * state.zoomLevel + state.translation;

    // Check if the fragment is inside or outside the region
    if (adjustedPosition.x > 100.0 || adjustedPosition.x < -100.0 ||
        adjustedPosition.y > 100.0 || adjustedPosition.y < -100.0) {
        out.color = float4(0.0, 0.0, 0.0, 1.0); // Outside region
    } else {
        out.color = float4(1.0, 1.0, 1.0, 1.0); // Inside region
    }

    return out;
}
