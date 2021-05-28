#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader
uniform int u_Time;

in vec3 fs_Pos;
in vec3 fs_Nor;

layout(location = 0) out vec3 out_Col;

float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

float noise(vec3 p) {
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}

void main()
{
    // HW4: Use nosie result of dynamic nor as t
    // Initialize normal as given value
    vec3 dynamicNor = fs_Nor;
    dynamicNor.x *= u_Time * abs(cos(u_Time * 0.0345)) + 0.560;
    dynamicNor.y *= u_Time * abs(sin(u_Time * 0.0345)) + 0.460;
    dynamicNor.z *= fract(u_Time * pow((u_Time * 0.345), 3)) + 3.5445;

    float t = abs(cos(u_Time * 0.049823));
    t *= noise(dynamicNor);
    t = clamp(t, 0, 1);

    vec3 a = vec3(0.888, 0.548, 0.648);
    vec3 b = vec3(0.541, 0.883, 0.895);
    vec3 c = vec3(1.402, 1.414, 1.605);
    vec3 d = vec3(0.587, 2.017, 2.287);
    const float PI = 3.1415926;

    out_Col = a + b * cos(2.f * PI * (c * t + d));
    //out_Col = vec3(0, 0, 0);
}
