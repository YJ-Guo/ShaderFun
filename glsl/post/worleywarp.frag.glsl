#version 150

uniform ivec2 u_Dimensions;
uniform int u_Time;

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;

vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)),
                 dot(p, vec2(269.5,183.3))))* 43758.5453);
}

float WorleyNoise(vec2 uv) {
    uv *= 10; // Change the space to 10 * 10
    vec2 uvInt = floor(uv);
    vec2 uvFract = fract(uv);
    float minDist = 1.0; // Minimum distance initialized to max.
    for(int y = -1; y <= 1; ++y) {
        for(int x = -1; x <= 1; ++x) {
            vec2 neighbor = vec2(float(x), float(y)); // Direction in which neighbor cell lies
            vec2 point = random2(uvInt + neighbor); // Get the Voronoi centerpoint for the neighboring cell
            vec2 diff = neighbor + point - uvFract; // Distance between fragment coord and neighbor’s Voronoi point
            float dist = length(diff);
            minDist = min(minDist, dist);
        }
    }
    return minDist;
}

// Make the noise moving like snow based on IQ's Implementation
float snow(vec2 p) {
    return pow(cos(WorleyNoise(p * 1.6 + 0.0026 * u_Time)), 100);
}

float snow2(vec2 p) {
    return pow(cos(WorleyNoise(p * 0.8 + 0.0031 * u_Time)), 100);
}

float snow3(vec2 p) {
    return pow(cos(WorleyNoise(p * 0.4 + 0.0036 * u_Time)), 100);
}

float snow4(vec2 p) {
    return pow(cos(WorleyNoise(p * 0.2 + 0.0041 * u_Time)) , 100);
}

void main()
{
    // Use tangent to make the object flash
    vec2 shift = random2(fs_UV) * 0.02 * tan(u_Time * 0.022);
    vec4 baseColor = vec4(0.f);
    // Use if conditions to make the pic shake
    if (u_Time % 4 == 0) {
        baseColor = texture(u_RenderedTexture, vec2(fs_UV.x + shift.x, fs_UV.y));
    } else if (u_Time % 4 == 1) {
        baseColor = texture(u_RenderedTexture, vec2(fs_UV.x, fs_UV.y + shift.y));
    } else if (u_Time % 4 == 2) {
        baseColor = texture(u_RenderedTexture, vec2(fs_UV.x - shift.x, fs_UV.y));
    } else if (u_Time % 4 == 3) {
        baseColor = texture(u_RenderedTexture, vec2(fs_UV.x, fs_UV.y - shift.y));
    }

    // 4 layers of snow
    float snowSum = 0.845566 + snow(fs_UV) + snow2(fs_UV) + snow3(fs_UV) + snow4(fs_UV);

    color = vec3(baseColor) * snowSum;
}
