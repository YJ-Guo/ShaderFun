#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader

in vec2 fs_UV;

layout(location = 0) out vec3 out_Col;

void main()
{
    // HW4: Use normal to texture mapping for color
    vec4 diffuseColor = texture(u_Texture, fs_UV);
    out_Col = diffuseColor.rgb;
}
