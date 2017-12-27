#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;
uniform int u_Time;
uniform ivec2 u_Dimensions;

void main()
{
    mat3 horizontal;
    horizontal[0] = vec3(3, 10, 3);
    horizontal[1] = vec3(0, 0, 0);
    horizontal[2] = vec3(-3, -10,-3);

    mat3 vertical;
    vertical[0] = vec3(3, 0, -3);
    vertical[1] = vec3(10, 0, -10);
    vertical[2] = vec3(3, 0,-3);

    vec3 weighted_color_H;
    vec3 weighted_color_V;

    for(int i = 0; i < 3; i++){
        for(int j = 0; j < 3; j++){
            vec2 point_UV = vec2(clamp(fs_UV.x + (i - 3/2)/640.f, 0, 1), clamp(fs_UV.y + (j - 3/2)/480.f, 0, 1));
            vec4 curr_Color = texture(u_RenderedTexture, point_UV);

            weighted_color_H = weighted_color_H + (vec3(curr_Color) * horizontal[i][j]);
            weighted_color_V = weighted_color_V + (vec3(curr_Color) * vertical[i][j]);
        }
    }

    float color_X = (sqrt(pow(weighted_color_H.x,2) + pow(weighted_color_V.x,2)));
    float color_Y = (sqrt(pow(weighted_color_H.y,2) + pow(weighted_color_V.y,2)));
    float color_Z = (sqrt(pow(weighted_color_H.z,2) + pow(weighted_color_V.z,2)));

    color = vec3(color_X, color_Y, color_Z);
}
