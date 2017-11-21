#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader

in vec2 fs_UV;
in vec3 fs_Nor;
layout(location = 0) out vec3 out_Col;

void main()
{
    // TODO Homework 4
    out_Col = texture(u_Texture, (0.5 * (fs_Nor.xy + vec2(1,1)))).rgb;

}
