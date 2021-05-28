#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader

in vec3 fs_Nor;
in vec3 fs_LightVec;

layout(location = 0) out vec3 out_Col;

void main()
{
    // HW4: Update the gradient color with t from dot product
    float t = dot(normalize(fs_Nor), normalize(fs_LightVec));
    t = clamp(t, 0, 1);

    vec3 a = vec3(0.888, 0.548, 0.648);
    vec3 b = vec3(0.541, 0.883, 0.895);
    vec3 c = vec3(1.402, 1.414, 1.605);
    vec3 d = vec3(0.587, 2.017, 2.287);
    const float PI = 3.1415926;

    out_Col = a + b * cos(2.f * PI * (c * t + d));
    // out_Col = vec3(0, 0, 0);
}
