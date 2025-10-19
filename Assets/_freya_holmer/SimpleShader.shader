Shader "Unlit/SimpleShaderFreyaHolmer"
{
    Properties
    {
        _Color( "Color" , Color ) = (1,1,1,1)
        _Gloss ("Gloss" , Float) = 1
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
                float3 worldPos : TEXCOORD2;
            };

            float4 _Color;
            float _Gloss;
            

            vertextOutput vert (vertextInput v)
            {
                vertextOutput o;
                o.uv = v.uv;
                o.normal = v.normal;
                o.worldPos = mul( unity_ObjectToWorld,v.vertex );
                o.vertex = UnityObjectToClipPos( v.vertex );
                return o;
            }

            fixed4 frag (vertextOutput i) : SV_Target
            {
                //Lighting
                //direct Diffuse Light
                float3 lightDir = _WorldSpaceLightPos0.xyz; //normalize(float3(1, 1, 1));
                float3 lightColor = _LightColor0.rgb; // float3(0.9,0.82,0.7);
                float3 normal = normalize(i.normal);
                float lightFalloff = saturate(dot(lightDir, normal));
                float3 directDiffuseLight = lightFalloff * lightColor;

                //Ambient Light
                float3 ambientLight = float3(0.1,0.1,0.1);
                
                //direct specular Light
                float3 camPos = _WorldSpaceCameraPos;
                float3 fragToCam = camPos - i.worldPos;
                float3 viewDir =  normalize(fragToCam);

                float3 viewReflect =  reflect(-viewDir, normal);
                float specularFalloff = max(0, dot( viewReflect, lightDir));

                specularFalloff = pow(specularFalloff, _Gloss);
                
                return float4(specularFalloff.xxx, 0);

                
                // phong
                
                //Composite Light
                float3 diffuseLight = ambientLight + directDiffuseLight;
                float3 finalSurfaceColor = diffuseLight * _Color.rgb + specularFalloff;
                
                return float4( finalSurfaceColor ,0);
            }
            ENDCG
        }
    }
}
