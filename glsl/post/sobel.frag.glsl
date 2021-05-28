#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;
uniform int u_Time;
uniform ivec2 u_Dimensions;

uniform int[3 * 3] horizontal = int[](  3, 0, -3,
                                       10, 0, -10,
                                        3, 0, -3);

uniform int[3 * 3] vertical = int[](  3, 10,   3,
                                      0,  0,   0,
                                     -3, -10, -3);

void main()
{
    float intervalX = 1.f / u_Dimensions.x;
    float intervalY = 1.f / u_Dimensions.y;

    // initialize the Results container
    vec3 horResCol = vec3(0);
    vec3 verResCol = vec3(0);
    vec3 resCol = vec3(0);

    // Iterate the 3*3 for each value
    for (int i = -1; i < 2; ++i) {
        for (int j = -1; j < 2; ++j) {
            vec2 surPos = vec2 (fs_UV.x + i * intervalX, fs_UV.y + j * intervalY);
            horResCol += vec3(texture(u_RenderedTexture, surPos)) * horizontal[(i + 1) * 3 + (j + 1)];
            verResCol += vec3(texture(u_RenderedTexture, surPos)) * vertical[(i + 1) * 3 + (j + 1)];
        }
    }

    resCol = horResCol * horResCol + verResCol * verResCol;

    // HW4: Compute gradiant for recoloring
    color = sqrt(resCol);
}
