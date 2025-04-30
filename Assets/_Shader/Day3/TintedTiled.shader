Shader "Custom/ScrollingUVFixed"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _TintColor("Tint Color", Color) = (1,1,1,1)
        _ScrollSpeed("Scroll Speed", Vector) = (0.2, 0, 0, 0)
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // Include Unity shader helpers
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;           // Tiling and Offset
            float4 _ScrollSpeed;          // XY for scroll direction
            fixed4 _TintColor;
            

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;

                // Transform position
                o.pos = UnityObjectToClipPos(v.vertex);

                // Apply tiling/offset
                float2 uv = TRANSFORM_TEX(v.uv, _MainTex);

                // Add time-based UV offset (scroll)
                uv += _Time.y * _ScrollSpeed.xy;

                o.uv = uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col * _TintColor;
            }

            ENDCG
        }
    }
}
