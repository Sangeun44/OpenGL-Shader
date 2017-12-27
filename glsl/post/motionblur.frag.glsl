#version 150
#define M_PI 3.1415926535897932384626433832795

in vec2 fs_UV;
in vec4 gl_FragCoord;

out vec3 color;

uniform sampler2D u_RenderedTexture;
uniform int u_Time;
uniform ivec2 u_Dimensions;

void main()
{
    // TODO Homework 5
    float d_X = 11; //x of kernel
    float d_Y = 11; //y of kernel
    float frag_X = gl_FragCoord.x; //current coord.x
    float frag_Y = gl_FragCoord.y; //current coord.y

    vec3 weighted_Color; //color

    float sigma = 3;

    for(int i = 0; i < d_X; i++){
        for(int j = 0; j < d_Y; j++){

            float first = 1/(2 * 3.141592 * pow(sigma,2));
            float e_value = pow(2.71828, (-1 * ((pow(i - d_X / 2, 2) + pow(j - d_Y / 2, 2))/(2 * pow(sigma,2)))));
            float weight = first * e_value;

            vec2 point_UV = vec2(clamp(fs_UV.x + (i-2)/640.f, 0, 1), clamp(fs_UV.y + (i-2)/480.f, 0, 1));

            vec4 curr_Color = texture(u_RenderedTexture, point_UV);
            weighted_Color = weighted_Color + (weight * vec3(curr_Color));
        }
    }

    color = weighted_Color;
}
