#version 150

uniform int u_Time;

uniform mat4 u_Model;

uniform mat3 u_ModelInvTr;

uniform mat4 u_View;        // The matrix that defines the camera's transformation.
uniform mat4 u_Proj;        // The matrix that defines the camera's projection.

in vec4 vs_Pos;             // The array of vertex positions passed to the shader

in vec4 vs_Nor;             // The array of vertex normals passed to the shader

in vec2 vs_UV;              // The array of vertex texture coordinates passed to the shader

out vec4 fs_Pos;
out vec4 fs_Nor;            // The array of normals that has been transformed by u_ModelInvTr. This is implicitly passed to the fragment shader.
out vec4 fs_LightVec;       // The direction in which our virtual light lies, relative to each vertex. This is implicitly passed to the fragment shader.
out vec2 fs_UV;             // The UV of each vertex. This is implicitly passed to the fragment shader.


void main()
{
    fs_UV = vs_UV;    // Pass the vertex UVs to the fragment shader for interpolation

    fs_Nor = normalize(vec4(u_ModelInvTr * vec3(vs_Nor), 0));

    float offsetScale = 0.5f * sin((vs_Pos.y + float(u_Time * 0.5f) * 0.25f) * 1.75f) + 0.5f;
    float offsetScale2 = 0.2f * sin((vs_Pos.x + float(u_Time * 0.3f) * 0.25f)* 1.75f) + 0.5f;
    float offsetScale3 = 4.0f * 0.5f *sin(vs_Pos.x + float(u_Time * 0.3f) * 0.25f);
    float offsetScale4 = mod(cos(u_Time), 0.5);
    float offsetScale5 = 0.2f * sin((vs_Pos.x + float(u_Time * 0.3f) * 0.25f)* 1.75f) + 0.5f;



    vec4 offsetPos = vs_Pos + vec4(offsetScale2, offsetScale4, offsetScale4, 0);
    fs_Pos = offsetPos;
    vec4 modelposition = u_Model * offsetPos;   // Temporarily store the transformed vertex positions for use below

    fs_LightVec = (inverse(u_View) * vec4(0,0,0,1)) - modelposition;  // Compute the direction in which the light source lies



    gl_Position = u_Proj * u_View * modelposition;// gl_Position is a built-in variable of OpenGL which is
                                                  // used to render the final positions of the geometry's vertices
}
