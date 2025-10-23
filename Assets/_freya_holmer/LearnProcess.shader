Shader "Custom/LearnProcess"
{
    Properties
    {
        [MainColor] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque"}

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct VertexInput
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            

            VertexOutput vert(VertexInput input)
            {
                VertexOutput output;
                output.positionHCS = UnityObjectToClipPos(input.positionOS);
                output.uv = input.uv;
                return output;
            }

            half4 frag(VertexOutput input) : SV_Target
            {
                float2 coords = input.uv;
                float time = _Time.y;
               return frac(coords.y + time);
            }
            ENDHLSL
        }
    }
}
