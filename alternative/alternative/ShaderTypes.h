#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

typedef struct {
    vector_float2 translation;
    float zoomLevel;
} ShaderState;

#endif /* ShaderTypes_h */
