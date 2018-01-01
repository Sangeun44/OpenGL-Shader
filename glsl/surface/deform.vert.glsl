#version 150

uniform int u_Time;

uniform mat4 u_Model;

uniform mat3 u_ModelInvTr;

uniform mat4 u_View;        // The matrix that defines the camera's transformation.
uniform mat4 u_Proj;        // The matrix that defines the camera's projection.
uniform vec4 u_Eye;

in vec4 vs_Pos;             // The array of vertex positions passed to the shader

in vec4 vs_Nor;             // The array of vertex normals passed to the shader

in vec2 vs_UV;              // The array of vertex texture coordinates passed to the shader

out vec3 fs_Pos;
out vec3 fs_Nor;            // The array of normals that has been transformed by u_ModelInvTr. This is implicitly passed to the fragment shader.
out vec3 fs_LightVec;       // The direction in which our virtual light lies, relative to each vertex. This is implicitly passed to the fragment shader.
out vec2 fs_UV;             // The UV of each vertex. This is implicitly passed to the fragment shader.


void main()
{
    fs_UV = vs_UV;    // Pass the vertex UVs to the fragment shader for interpolation
    fs_Nor = normalize(u_ModelInvTr * vec3(vs_Nor));

    float change = 2.f / sqrt(vs_Pos.x * vs_Pos.x + vs_Pos.z * vs_Pos.z);
    float chX = vs_Pos.x * change - vs_Pos.x;
    float chZ = vs_Pos.z * change - vs_Pos.z;
    vec4 changePos = vs_Pos + vec4(chX * (cos(u_Time * 0.1) + 1) / 2, 0, chZ * (cos(u_Time * 0.1) + 1) / 2, 0);

    //moves all the vertices to be 3 units from the y-axis AKA cylinder
    //cube -> rectangular prism

//    float offsetScale = 0.5f * sin((vs_Pos.y + float(u_Time * 0.5f) * 0.25f) * 1.75f) + 0.5f;
//    fs_Pos = offsetPos;

    vec4 modelposition = u_Model * changePos;   // Temporarily store the transformed vertex positions for use below
    fs_Pos = vec3(modelposition);
    fs_LightVec = (u_Eye - modelposition).xyz;  // Compute the direction in which the light source lies
    gl_Position = u_Proj * u_View * modelposition;// gl_Position is a built-in variable of OpenGL which is
                                                  // used to render the final positions of the geometry's vertices
}
