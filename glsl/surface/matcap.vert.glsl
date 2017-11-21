#version 150

uniform mat4 u_Model;
uniform mat3 u_ModelInvTr;
uniform mat4 u_View;
uniform mat4 u_Proj;

in vec4 vs_Pos;
in vec4 vs_Nor;
in vec2 vs_UV;

out vec2 fs_UV;
out vec3 fs_Nor;

void main()
{
    // TODO Homework 4
    vec3 normal = normalize(u_ModelInvTr * vec3(vs_Nor));
    normal = mat3(u_View) * normal;

    fs_UV = vs_UV;
    fs_Nor = normal;

    vec4 modelposition = u_Model * vs_Pos;
    gl_Position = u_Proj * u_View * modelposition;
}
