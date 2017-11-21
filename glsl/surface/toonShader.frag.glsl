#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader

in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec2 fs_UV;

layout(location = 0) out vec3 out_Col;//This is the final output color that you will see on your screen for the pixel that is currently being processed.

void main()
{
    // Material base color (before shading)
    vec4 diffuseColor = texture(u_Texture, fs_UV);

    // Calculate the diffuse term for Lambert shading
    float diffuseTerm = dot(normalize(fs_Nor), normalize(fs_LightVec));
    // Avoid negative lighting values
    diffuseTerm = clamp(diffuseTerm, 0, 1);

    float ambientTerm = 0.2;

    float lightIntensity = diffuseTerm + ambientTerm;

    vec4 color;

    vec4 colorIn = diffuseColor;

    if(diffuseColor.r > 0.9 && diffuseColor.g > 0.9 && diffuseColor.b> 0.9){
        colorIn.r = 1.0;
        colorIn.g = 1.0;
        colorIn.b = 1.0;
    }
    else if(diffuseColor.r > 0.75 && diffuseColor.g < 0.3){
        colorIn.r = 1.0;
    }
    else if(diffuseColor.g > 0.75){
        colorIn.g = 1.0;
    }
    else if(diffuseColor.b > 0.8){
        colorIn.b = 1.0;
    }

    if(diffuseTerm > 0.99){
        color = colorIn * vec4(1.0, 1.0, 1.0, 1.0);
    }
    else if(diffuseTerm > 0.85){
        color = colorIn * vec4(0.9, 0.9, 0.9, 1.0);
    }
    else if(diffuseTerm > 0.5){
        color = colorIn * vec4(0.7, 0.7, 0.7, 1.0);
    }
    else{
        color = colorIn * vec4(0.1, 0.1, 0.1, 1.0);
    }

    //gl_FragColor = vec3(color.rgb * lightIntensity);
    out_Col = vec3(color.rgb);
//    out_Col = normalize(abs(fs_Nor));
}
