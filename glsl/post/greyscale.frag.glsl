#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;

void main()
{
    // Material base color (before shading)
    vec4 diffuseColor = texture(u_RenderedTexture, fs_UV);
    float grey = diffuseColor.r * 0.21 + diffuseColor.g * 0.72 + diffuseColor.b * 0.07;

    // Calculate the distance between a certain point in the texture and center
    // Max distance is half diagnol length
    float maxDis = 0.5 * length(vec2(1,1) - vec2(0,0));
    // calculate the ratio of distance in (0,1)
    float darkness = length(fs_UV - vec2(0.5, 0.5)) / maxDis;

    color = vec3(grey) * (1 - darkness);
}
