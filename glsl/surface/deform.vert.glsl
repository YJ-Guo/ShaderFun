#version 150

uniform mat4 u_Model;
uniform mat3 u_ModelInvTr;
uniform mat4 u_View;
uniform mat4 u_Proj;

uniform int u_Time;

in vec4 vs_Pos;
in vec4 vs_Nor;

out vec3 fs_Pos;
out vec3 fs_Nor;

void main()
{
    // HW4: use smoothstep to modify vertex position
    fs_Nor = normalize(u_ModelInvTr * vec3(vs_Nor));

    // Initialize the dynamicPosition to current position
    vec4 dynamicPosition = vs_Pos;

    // Set up the translation sphere parameter
    float theta = u_Time * 0.0337;
    float phi = u_Time * 0.0682;

    // The sphere controling circle translation
    vec4 sphere1 = vec4(8.2389 * sin(theta) * cos(phi), 6.29386 * sin(theta) * sin(phi), 2.685 * cos(theta), 1.f);

    // The sphere controling expansion
    vec4 sphere2 = vec4(15.568 * cos(u_Time * 0.035) * cos(u_Time * 0.035)
                        * normalize(dynamicPosition.xyz), 1.f);

    // Apply expansion and translation
    dynamicPosition = mix(dynamicPosition, sphere2, 0.5);
    dynamicPosition = mix(dynamicPosition, sphere1, 0.5);

    // vec4 modelposition = u_Model * vs_Pos;
    vec4 modelposition = u_Model * dynamicPosition;
    fs_Pos = vec3(modelposition);
    gl_Position = u_Proj * u_View * modelposition;
}
