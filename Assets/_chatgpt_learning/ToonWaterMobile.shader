// ToonWaterMobile.shader
// Lightweight, mobile-friendly toon-ish water shader for Unity (Built-in Render Pipeline)
// Features: vertex wave displacement, normalmap perturbation, toon lighting (banding), rim/fresnel highlight, scrolling UVs, simple foam mask.
// Usage: create a material with this shader, assign textures (albedo, normal, foam), tweak params.

Shader "Custom/ToonWaterMobile"
{
    Properties
    {
        _MainTex ("Albedo (RGBA)", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _FoamTex ("Foam Mask", 2D) = "white" {}

        _Color ("Water Color", Color) = (0.02,0.45,0.7,1)
        _SpecColor ("Specular Color", Color) = (1,1,1,1)

        _WaveScale ("Wave Scale", Float) = 0.1
        _WaveSpeed ("Wave Speed", Float) = 0.3
        _WaveHeight ("Wave Height", Float) = 0.05

        _UVScroll ("UV Scroll Speed", Vector) = (0.05, 0.02, 0, 0)

        _BandSteps ("Toon Bands", Range(1,8)) = 3
        _RimPower ("Rim Power", Range(0.1,8)) = 2
        _RimColor ("Rim Color", Color) = (0.6,0.9,1,1)

        _Specular ("Specular Intensity", Range(0,2)) = 0.8
        _Shininess ("Shininess", Range(1,64)) = 16

        _FoamScale ("Foam UV Scale", Float) = 2
        _FoamThreshold ("Foam Threshold", Range(0,1)) = 0.6
        _FoamStrength ("Foam Strength", Range(0,1)) = 0.8
    }

    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 200
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #pragma target 3.0

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _NormalMap;
            sampler2D _FoamTex;

            float4 _MainTex_ST;
            float4 _NormalMap_ST;
            float4 _FoamTex_ST;

            fixed4 _Color;
            fixed4 _SpecColor;

            float _WaveScale;
            float _WaveSpeed;
            float _WaveHeight;
            float4 _UVScroll;

            int _BandSteps;
            float _RimPower;
            fixed4 _RimColor;
            float _Specular;
            float _Shininess;

            float _FoamScale;
            float _FoamThreshold;
            float _FoamStrength;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 foamUv : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
                float3 worldNormal : TEXCOORD3;
                float3 viewDir : TEXCOORD4;
                UNITY_FOG_COORDS(5)
            };

            // Simple low-cost wave function (vertex displacement)
            float WaveHeightAt(float2 uv, float time)
            {
                // Combine two sin waves for a richer look
                float h = 0;
                h += sin((uv.x + time * _WaveSpeed) * 6.28318 * _WaveScale) * 0.5;
                h += cos((uv.y - time * _WaveSpeed*0.6) * 6.28318 * (_WaveScale*1.3)) * 0.5;
                return h * _WaveHeight;
            }

           v2f vert(appdata v)
            {
                v2f o;
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);

                float2 uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                float time = _Time.y * _UVScroll.x;
                float2 uvScroll = uv + _UVScroll.xy * _Time.y;

                float dh = WaveHeightAt(uvScroll, _Time.y);
                worldPos.y += dh;

                o.pos = UnityObjectToClipPos(v.vertex + float4(0, dh, 0, 0));
                o.uv = uvScroll;
                o.foamUv = uvScroll * _FoamScale;
                o.worldPos = worldPos.xyz;
                o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));

                float3 viewPos = _WorldSpaceCameraPos;
                o.viewDir = normalize(viewPos - o.worldPos);

                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }

            // Helper: decode normal map (assumed tangent-space normal map)
            float3 DecodeNormal(sampler2D nm, float2 uv, float3 worldNormal, float4 tangentWS)
            {
                // Sample normal map (RGBA) -> convert from [0,1] to [-1,1]
                float3 n = tex2D(nm, uv).rgb * 2 - 1;

                // Build TBN - cheap approximation: use provided tangent if available
                float3 t = normalize(mul((float3x3)unity_ObjectToWorld, tangentWS.xyz));
                float3 b = cross(worldNormal, t) * tangentWS.w;

                float3 worldN = normalize(n.x * t + n.y * b + n.z * worldNormal);
                return worldN;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Sample textures
                fixed4 albedo = tex2D(_MainTex, i.uv) * _Color;

                // Decode normal map to world normal (we passed object-space normal, use that for TBN)
                // We'll read tangent from _MainTex_ST.w? Not available here - so use a low-cost alternative: reconstruct tangent from world normal's orthogonals.
                // For mobile simplicity, we'll perturb using normal map in object-space trick: assume normal map is small and use it as normal perturbation in world space.
                float3 baseN = normalize(i.worldNormal);
                float3 nmap = tex2D(_NormalMap, i.uv).rgb * 2 - 1;
                // create a simple perturbation
                float3 worldN = normalize(baseN + nmap * 0.5);

                // Light direction (directional sun) - cheap: use _WorldSpaceLightPos0
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float ndotl = saturate(dot(worldN, lightDir));

                // Toon banding: quantize diffuse
                float bands = max(1, _BandSteps);
                float toonDiffuse = floor(ndotl * bands) / bands;

                // Rim / fresnel
                float fresnel = pow(saturate(1 - saturate(dot(i.viewDir, worldN))), _RimPower);

                // Specular - Blinn-Phong
                float3 halfDir = normalize(lightDir + i.viewDir);
                float spec = pow(saturate(dot(worldN, halfDir)), _Shininess);

                // Foam mask from foam texture - thresholded noise for edges
                float foamSample = tex2D(_FoamTex, i.foamUv).r;
                float foamMask = smoothstep(_FoamThreshold - 0.15, _FoamThreshold + 0.05, foamSample);

                // Compose
                fixed3 lit = albedo.rgb * toonDiffuse;
                // Add spec + rim
                lit += _SpecColor.rgb * spec * _Specular;
                lit = lerp(lit, _RimColor.rgb, fresnel * 0.6);

                // Add foam (lighter color near threshold)
                lit = lerp(lit, lerp(lit, fixed3(1,1,1), 0.8), foamMask * _FoamStrength);

                // Simple alpha based on foam and base color alpha
                float alpha = saturate(albedo.a);
                alpha = max(alpha, foamMask * 0.9);

                fixed4 outCol = fixed4(lit, alpha);

                UNITY_APPLY_FOG(i.fogCoord, outCol);
                return outCol;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
