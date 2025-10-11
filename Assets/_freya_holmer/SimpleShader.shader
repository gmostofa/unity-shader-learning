Shader "Unlit/SimpleShaderFreyaHolmer"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct vertextInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct vertextOutput
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            vertextOutput vert (vertextInput v)
            {
                vertextOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = v.normal;
                return o;
            }

            fixed4 frag (vertextOutput i) : SV_Target
            {
                float3 lightDir = _WorldSpaceLightPos0.xyz; //normalize(float3(1, 1, 1));
                float3 lightColor = _LightColor0.rgb; // float3(0.9,0.82,0.7);
                
                float3 normal = i.normal;
                float lightFalloff = saturate(dot(lightDir, normal));
                float3 diffuseLight = lightFalloff * lightColor;

                float3 ambientLight = float3(0.5,0.3,0.3);
                
                return float4(ambientLight + diffuseLight,0);
            }
            ENDCG
        }
    }
}
