#version 150

uniform ivec2 u_Dimensions;
uniform int u_Time;

in vec2 fs_UV;
in vec4 gl_FragCoord;

out vec3 color;

uniform sampler2D u_RenderedTexture;


void main()
{
    vec4 frag_color = texture(u_RenderedTexture, fs_UV);

    float x = gl_FragCoord.x;
    float y = gl_FragCoord.y;

    float offsetr = 1.5f * sin(x * 4.0f + y * 2.0f + float(u_Time * 2.0f)) + 0.3;
    float offsetg = 1.5f * sin(x * 4.0f + y * 2.0f + float(u_Time * 2.0f)) + 0.4;
    float offsetb = 1.5f * sin(x * 4.0f + y * 2.0f + float(u_Time * 2.0f)) + 0.5;

    float radius = 3 * u_Time;
    float result = pow(x - 960/2, 2) + pow(y - 640/2, 2);

    if(result < radius * radius){
        color = vec3(frag_color.x + offsetr, frag_color.y + offsetg, frag_color.z + offsetb);
    }

}
