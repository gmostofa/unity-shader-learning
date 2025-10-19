Shader "Custom/BasicColor"
{
  SubShader
  { 
      Pass
      { 
         CGPROGRAM 

         #pragma vertex vert 
         #pragma fragment frag

         float4 vert(float4 vertexPos : POSITION) : SV_POSITION 
         {
           return UnityObjectToClipPos(float4(1.0, 1, 1.0, 1.0) * vertexPos);
         }

         float4 frag(void) : COLOR // fragment shader
         {
             return float4(0.6, 1.0, 0.0, 1.0); 
         }

         ENDCG
      }
   }
}
