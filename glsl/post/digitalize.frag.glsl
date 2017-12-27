#version 150

uniform ivec2 u_Dimensions;
uniform int u_Time;

in vec2 fs_UV;
in vec4 gl_FragCoord;

out vec3 color;

uniform sampler2D u_RenderedTexture;

vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

float mod289(float x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}
vec4 mod289(vec4 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}
vec4 perm(vec4 x) {
    return mod289(((x * 34.0) + 1.0) * x);
}

float noise(vec3 p){
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}

void main()
{

    vec4 diffuseColor = texture(u_RenderedTexture, fs_UV);
    vec2 cellUV = fs_UV;
    cellUV *= 75;
    vec2 cells = floor(cellUV);
    vec2 local = 3*fract(cellUV);
    vec4 whorleyColor;
    float min_dist = 1.f;

    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
           vec2 neighbour = vec2(float(x),float(y));
           vec2 point = random2(cells + neighbour);
            point = 0.5 + 0.4 * cos(u_Time/9.5 + 12 * point);
            vec2 point_UV = vec2(point.x/2, point.y/2);

            vec2 dist = neighbour + point - local;
            float newdist = length(dist);
            min_dist = min(min_dist, newdist);
            if(newdist == min_dist) {
               whorleyColor = (texture(u_RenderedTexture, point));
                }
           }
       }
        color = vec3(whorleyColor + diffuseColor);
        color -= min_dist;


}
