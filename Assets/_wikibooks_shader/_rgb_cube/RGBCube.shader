Shader "Custom/RGBCube"
{
    SubShader { 
      Pass { 
         CGPROGRAM 
 
         #pragma vertex vert 
         #pragma fragment frag
         
         struct vertexOutput
         {
            float4 pos : SV_POSITION;
            float4 col : TEXCOORD0;
         };
 
         vertexOutput vert(float4 vertexPos : POSITION) 
         {
            vertexOutput output;
            output.pos = UnityObjectToClipPos(vertexPos);
            output.col = vertexPos;
            return output;
         }
 
         float4 frag(vertexOutput input) : COLOR // fragment shader
         {
            return normalize(input.col); 
         }
         ENDCG  
      }
   }
}
