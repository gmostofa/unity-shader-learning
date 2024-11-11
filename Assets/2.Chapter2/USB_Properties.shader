Shader "Unlit/USB_Properties"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
         _Specular ("Specular", Range(0.0, 1.1)) = 0.3
        _Factor ("Color Factor", Float) = 0.3
        _Cid ("Color id", Int) = 2
         _Color ("Tint", Color) = (1, 1, 1, 1)
        _VPos ("Vertex Position", Vector) = (0, 0, 0, 1)
        _Reflection ("Reflection", Cube) = "black" {}
        _3DTexture ("3D Texture", 3D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            
            ENDCG
        }
    }
}
