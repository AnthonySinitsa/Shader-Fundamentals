# Normal-Mapping/Shader-Fundamentals

<div align="center">
  <img src="ball.gif" alt="rotating detailed ball">
</div>

#
 
The primary focus of this project is the; My First Lighting Shader.shader and My Lighting.cginc. 

Normal mapping is a technique used in computer graphics to enhance the visual detail of 3D surfaces without adding additional geometry. It achieves this by "engraving" the surface normals of a 3D model based on information stored in a texture called a "normal map."

In context of the shader files, the key aspects related to normal mapping are the following:

1. Normal Map Texture:

    - In the shader, the Properties section includes _NormalMap and _DetailNormalMap, which are textures used as normal maps.
    - Normal maps typically store information about surface normals in RGB values, where each color channel corresponds to a component of the 3D normal vector (X, Y, Z).

1. Vertex Program (MyVertexProgram):

    - The vertex program transforms the vertex data and calculates the interpolated normal for each fragment.
    - The BINORMAL_PER_FRAGMENT macro defines whether binormals are calculated per fragment or not.

1. Fragment Program (MyFragmentProgram):

    - The InitializeFragmentNormal function is called to blend the main and detail normal maps and initialize the tangent space normal in the fragment shader.
    - The fragment program then uses this modified normal in the lighting calculation.

1. Normal Blending:

    - The InitializeFragmentNormal function blends the main and detail normal maps to create a tangent space normal.
    - This blending adds finer details to the surface without the need for additional geometry.

1. Unity_BRDF_PBS Function:

    - The final lighting calculation in MyFragmentProgram utilizes the Unity BRDF (Bidirectional Reflectance Distribution Function) to compute the interaction of light with the surface.
    - The modified normal, along with other shading properties like albedo, metallic, and smoothness, affects the final appearance of the surface.

In summary, normal mapping is a technique that allows developers to simulate surface details on 3D models without increasing the model's geometric complexity.
