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
    int numCells = 30;
    vec2 cellUV = fs_UV * numCells; //ratio by num cells on each side
    ivec2 cellID = ivec2(cellUV); //get integer values for cell coord ranging from 0 to numcells
    vec2 localCellUV = fract(cellUV); // get the inside value for each cell coord

    vec4 whorleyColor;
    float min_dist = 1.f;

    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
           vec2 surr = vec2(float(x),float(y));
           vec2 boundary = cellID + surr;
           if(boundary.x >= 0 && boundary.y >= 0 && boundary.x <= numCells && boundary.y <= numCells){
               vec2 point = random2(cellID + surr);
               point = 0.5 + 0.4 * cos(u_Time/9.5 + 12 * point);
               vec2 point_UV = vec2((point + cellID)/float(numCells));

               vec2 diff = surr + point - localCellUV;
               float dist = length(diff);
               min_dist = min(min_dist, dist);
               if(dist <= min_dist) {
                   whorleyColor = texture(u_RenderedTexture, normalize(point_UV));
                }
           }
        }
    }
    //vec4 diffuseColor = texture(u_RenderedTexture, fs_UV);
    color = vec3(whorleyColor);
    //color = texture(u_RenderedTexture, (cellID + vec2(.5,.5)) / float(numCells)).rgb;
    //color *= min(length(localCellUV) + 0.4, 1.0);

}
