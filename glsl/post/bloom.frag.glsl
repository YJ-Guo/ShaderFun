#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;
uniform int u_Time;
uniform ivec2 u_Dimensions;

// Hard code the Kernel of sigma = 9.0 and size = 11 x 11
uniform float gaussian[11 * 11] = float[](
0.006849,  0.007239,  0.007559,  0.007795,  0.007941,  0.00799,   0.007941,  0.007795,  0.007559,  0.007239,  0.006849,
0.007239,  0.007653,  0.00799,   0.00824,   0.008394,  0.008446,  0.008394,  0.00824,   0.00799,   0.007653,  0.007239,
0.007559,  0.00799,   0.008342,  0.008604,  0.008764,  0.008819,  0.008764,  0.008604,  0.008342,  0.00799,   0.007559,
0.007795,  0.00824,   0.008604,  0.008873,  0.009039,  0.009095,  0.009039,  0.008873,  0.008604,  0.00824,   0.007795,
0.007941,  0.008394,  0.008764,  0.009039,  0.009208,  0.009265,  0.009208,  0.009039,  0.008764,  0.008394,  0.007941,
0.00799,   0.008446,  0.008819,  0.009095,  0.009265,  0.009322,  0.009265,  0.009095,  0.008819,  0.008446,  0.00799,
0.007941,  0.008394,  0.008764,  0.009039,  0.009208,  0.009265,  0.009208,  0.009039,  0.008764,  0.008394,  0.007941,
0.007795,  0.00824,   0.008604,  0.008873,  0.009039,  0.009095,  0.009039,  0.008873,  0.008604,  0.00824,   0.007795,
0.007559,  0.00799,   0.008342,  0.008604,  0.008764,  0.008819,  0.008764,  0.008604,  0.008342,  0.00799,   0.007559,
0.007239,  0.007653,  0.00799,   0.00824,   0.008394,  0.008446,  0.008394,  0.00824,   0.00799,   0.007653,  0.007239,
0.006849,  0.007239,  0.007559,  0.007795,  0.007941,  0.00799,   0.007941,  0.007795,  0.007559,  0.007239,  0.006849);

void main()
{
    // Calculate the interval between each pixel in X and Y
    float intervalX = 1.f / u_Dimensions.x;
    float intervalY = 1.f / u_Dimensions.y;
    vec4 resColor = vec4(0);

    for (int i = -5 ; i < 6; ++i) {
        for (int j = -5; j < 6; ++j) {
        // use (i,j) = (0,0) as center of the distribution
        // Calculate the surrounding postion at given i and j
            vec2 surPos = vec2 (fs_UV.x + i * intervalX, fs_UV.y + j * intervalY);
            surPos = clamp(surPos, 0, 1);
            vec4 surColor = texture(u_RenderedTexture, surPos);
            // RGB Luminance value = 0.3 R + 0.59 G + 0.11 B
            float luminance = surColor.r * 0.3 + surColor.g * 0.59 + surColor.b * 0.11;
            // Set the threshold as 0.3 for HW guide
            if (luminance >= 0.3) {
                 resColor += surColor * gaussian[11 * (i + 5) + (j + 5)];
            }
        }
    }

    color = vec3(resColor + texture(u_RenderedTexture, fs_UV));
}
