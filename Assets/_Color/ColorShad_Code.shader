// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/ColorShad_Code"
{
   Properties
   {
      _Color ("Main Color", Color) = (1,1,1,1)
   }
   SubShader
   {
      Pass
      {
         CGPROGRAM
         #pragma vertex vertFunction
         #pragma fragment fragFunction
         
         uniform half4 _Color;
         
         struct vertextInput
         {
            float4 vertex : POSITION;
         };

         struct vertextOutput
         {
            float4 position : SV_POSITION;
         };

         vertextOutput vertFunction(vertextInput v)
         {
            vertextOutput o;
            o.position = UnityObjectToClipPos(v.vertex);
            return o;
         }

         half4 fragFunction(vertextOutput i) : COLOR
         {
            return _Color;
         }
         
         ENDCG
      }
   }
}
