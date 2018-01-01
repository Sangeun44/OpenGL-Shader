#version 330

uniform int u_Time;
uniform sampler2D u_Texture; // The texture to be read from by this shader

in vec3 fs_Pos;
in vec3 fs_Nor;
in vec3 fs_LightVec;
in vec2 fs_UV;

layout(location = 0) out vec3 out_Col;


float mod289(float x)
{return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x)
{return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x)
{return mod289(((x * 34.0) + 1.0) * x);}

float noise(vec3 p) {
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
    // Material base color (before shading)
    vec4 diffuseColor = texture(u_Texture, fs_UV);

    float diffuseTerm = dot(normalize(fs_Nor), normalize(fs_LightVec));

    diffuseTerm = clamp(diffuseTerm, 0, 1);

    float ambientTerm = 0.2;

    float lightIntensity = diffuseTerm + ambientTerm;


    float offset = 1.5f * atan(fs_Pos.x * 4.0f + fs_Pos.y * 2.0f + float(u_Time * 2.0f)) + 0.5;

    vec3 a1 = vec3(0.5,0.5,0.5);
    vec3 b1 = vec3(0.7,0.7,0.7);
    vec3 c1 = vec3(1.0,1.0,0.5);
    vec3 d1 = vec3(0.20,0.80,0.20);

    vec3 a2 = vec3(0.1,0.1,0.1);
    vec3 b2 = vec3(0.2,0.2,0.2);
    vec3 c2 = vec3(1.0,1.0,0.5);
    vec3 d2 = vec3(0.20,0.80,0.20);

    vec3 color1 = vec3(a1 + b1 * cos(2 * 3.14159 * (c1 * diffuseTerm + d1)));
    vec3 color2 = vec3(a2 + b2 * cos(2 * 3.14159 * (c2 * diffuseTerm + d2)));

    float noise1 = noise(color1);
    float noise2 = noise(color2);

    vec3 col = smoothstep(u_Time * color1, u_Time * color2, vec3(0,offset,noise1));

    out_Col = col;
}
