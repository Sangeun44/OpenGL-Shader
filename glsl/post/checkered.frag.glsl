#version 150

in vec2 fs_UV;

in vec4 gl_FragCoord;


out vec3 color;


uniform sampler2D u_RenderedTexture;

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

    float x = gl_FragCoord.x;
        float y = gl_FragCoord.y;

        float new_x1 = x - 1;
        float new_y1 = y - 1;

        float new_x2 = x + 1;
        float new_y2 = y + 1;

        float noise1x = noise(vec3(new_x1));
        float noise2x = noise(vec3(new_x2));

        float noise1y = noise(vec3(new_y1));
        float noise2y = noise(vec3(new_y1));

        vec4 diffuseColor = texture(u_RenderedTexture, fs_UV.xy);

        vec3 a = vec3(0.5,0.5,0.5);
        vec3 b = vec3(0.5,0.5,0.5);
        vec3 c = vec3(1.0,1.0,0.5);
        vec3 d = vec3(0.80,0.20,0.20);
        vec3 gradient1 = vec3(a + b * cos(2 * 3.14159 * (c * noise1y + d)));
        vec3 gradient2 = vec3(a + b * cos(2 * 3.14159 * (c * noise1x + d)));

        color = diffuseColor.xyz + gradient1 + gradient2;


}
