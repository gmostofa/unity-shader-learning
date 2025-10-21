Shader "Custom/NormalVisualizer"
{
   SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = normalize(v.normal * 0.5 + 0.5); // map from -1..1 to 0..1
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return fixed4(i.normal, 1.0);
            }
            ENDCG
        }
    }
}
