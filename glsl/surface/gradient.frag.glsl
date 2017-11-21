#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader

in vec4 fs_Nor;
in vec4 fs_LightVec;

layout(location = 0) out vec3 out_Col;

void main()
{
    // TODO Homework 4    
    vec3 normal = vec3(fs_Nor.xyz);
    vec3 LightVec = vec3(fs_LightVec.xyz);
    float diffuseTerm = dot(normalize(normal), normalize(LightVec));
    diffuseTerm = clamp(diffuseTerm, 0, 1);

    vec3 a = vec3(0.5,0.5,0.5);
    vec3 b = vec3(0.5,0.5,0.5);
    vec3 c = vec3(1.0,1.0,0.5);
    vec3 d = vec3(0.80,0.20,0.20);
    vec3 color = vec3(a + b * cos(2 * 3.14159 * (c * diffuseTerm + d)));

    out_Col = color;

}
