Shader "MyShader/BasicColor"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1) // Default white color
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : POSITION;
            };

            float4 _Color; // This holds the color we defined in Properties

            v2f vert(appdata_t v)
            {
                v2f o;
                o.pos = v.vertex;
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                return _Color; // Returning the color defined in Properties
            }
            ENDCG
        }
    }
    FallBack "Diffuse" // Fallback shader in case it doesn't work
}
