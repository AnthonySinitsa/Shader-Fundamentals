// Custom lighting shader for Unity
// Defines shader properties for material customization
Shader "Custom/My First Lighting Shader" {
    // Define shader properties for material customization
    Properties{
        _Tint("Tint", Color) = (1, 1, 1, 1)  // Tint color property with default value
        _MainTex("Albedo", 2D) = "white" {}   // Albedo texture property with default value
        [Gamma] _Metallic("Metallic", Range(0, 1)) = 0  // Metallic property with range and default value
        _Smoothness("Smoothness", Range(0, 1)) = 0.1   // Smoothness property with range and default value
    }

    // Define rendering passes for the shader
    SubShader{
        // Define a single pass for the subshader
        Pass{
            Tags{
                "LightMode" = "ForwardBase"  // Define light mode for the pass
            }

            CGPROGRAM  // Start of the Cg program section

            #pragma target 3.0  // Set the shader compilation target

            #pragma vertex MyVertexProgram  // Specify the custom vertex program
            #pragma fragment MyFragmentProgram  // Specify the custom fragment program

            #include "UnityPBSLighting.cginc"  // Include Unity's Physically Based Shading lighting model

            // Declare shader properties used in the program
            float4 _Tint;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Metallic;
            float _Smoothness;

            // Define a structure for interpolators used in the vertex program
            struct Interpolators{
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            // Define a structure for vertex data used in the vertex program
            struct VertexData{
                float4 position : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            // Custom vertex program for handling vertex transformations and interpolation
            Interpolators MyVertexProgram (VertexData v) {
                Interpolators i;
                i.position = UnityObjectToClipPos(v.position);  // Transform vertex position to clip space
                i.worldPos = mul(unity_ObjectToWorld, v.position);  // Transform vertex position to world space
                i.normal = UnityObjectToWorldNormal(v.normal);  // Transform vertex normal to world space
                i.uv = TRANSFORM_TEX(v.uv, _MainTex);  // Transform texture coordinates
                return i;  // Return the interpolated data
            }

            // Custom fragment program for handling pixel shading and lighting calculations
            float4 MyFragmentProgram (Interpolators i) : SV_TARGET {
                i.normal = normalize(i.normal);  // Normalize the interpolated normal vector
                float3 lightDir = _WorldSpaceLightPos0.xyz;  // Get the light direction in world space
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);  // Calculate the view direction
                float3 lightColor = _LightColor0.rgb;  // Get the light color

                float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;  // Calculate the adjusted albedo color
                float3 specularTint;
                float oneMinusReflectivity;
                albedo = DiffuseAndSpecularFromMetallic(
                    albedo, _Metallic, specularTint, oneMinusReflectivity
                );  // Calculate diffuse and specular reflection

                UnityLight light;  // Define a Unity light structure
                light.color = lightColor;  // Set the light color
                light.dir = lightDir;  // Set the light direction
                light.ndotl = DotClamped(i.normal, lightDir);  // Calculate the dot product of normal and light direction
                UnityIndirect indirectLight;  // Define a Unity indirect light structure
                indirectLight.diffuse = 0;  // Set the diffuse indirect light to 0
                indirectLight.specular = 0;  // Set the specular indirect light to 0

                return UNITY_BRDF_PBS(  // Calculate the Physically Based Shading BRDF
                    albedo, specularTint,
                    oneMinusReflectivity, _Smoothness,
                    i.normal, viewDir,
                    light, indirectLight
                );
            }

            ENDCG  // End of the Cg program section
        }
    }
}