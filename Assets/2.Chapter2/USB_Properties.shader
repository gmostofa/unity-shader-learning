Shader "Unlit/USB_Properties"
{
    Properties
    {
        [Header(Properties)]
        _MainTex ("Texture", 2D) = "white" {}
         _Specular ("Specular", Range(0.0, 1.1)) = 0.3
        _Factor ("Color Factor", Float) = 0.3
        _Cid ("Color id", Int) = 2
         _Color ("Tint", Color) = (1, 1, 1, 1)
        _VPos ("Vertex Position", Vector) = (0, 0, 0, 1)
        _Reflection ("Reflection", Cube) = "black" {}
        _3DTexture ("3D Texture", 3D) = "white" {}
        
         [Space(20)]
         // declare drawer Toggle
        [KeywordEnum(Off, Red, Blue)]
        _Options ("Color Options", Float) = 0
        
         [Enum(Off, 0, Front, 1, Back, 2)]
          _Face ("Face Culling", Float) = 0
        
        [Toggle] _Enable ("Enable ?", Float) = 0
        
         [Space(20)]
        
         [PowerSlider(3.0)]
        _Brightness ("Brightness", Range (0.01, 1)) = 0.08
        
        [IntRange]
        _Samples ("Samples", Range (0, 255)) = 100
    }
	
	
    SubShader
    {
        Pass
        {
            CGPROGRAM
            // declare pragma
            #pragma shader_feature _ENABLE_ON
            #pragma multi_compile _OPTIONS_OFF _OPTIONS_RED _OPTIONS_BLUE
            
            ENDCG
        }
    }
}
