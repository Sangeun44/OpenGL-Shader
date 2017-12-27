#version 150

in vec2 fs_UV;

in vec4 gl_FragCoord;


out vec3 color;


uniform sampler2D u_RenderedTexture;

void main()
{
    vec4 diffuseColor = texture(u_RenderedTexture, fs_UV);

   float distance = sqrt(pow(960 - gl_FragCoord.x,2) + pow(640 - gl_FragCoord.y, 2));
   float vignette = distance * 0.0005;

   float greyRed = diffuseColor.x * 0.21;
   float greyGreen = diffuseColor.y * 0.72;
   float greyBlue = diffuseColor.z * 0.07;

   float grey = greyRed + greyGreen + greyBlue;

   color = vec3(grey-vignette, grey-vignette, grey-vignette);


}
