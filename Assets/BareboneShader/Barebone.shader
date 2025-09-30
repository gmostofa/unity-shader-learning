Shader "Unlit/Barebone"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            //#pragma fragment frag
            

            struct vertextInput
            {
            };

            struct vertextOutput
            {
            };

            
            vertextOutput vert (vertextInput v)
            {
            }

            /*fixed4 frag (vertextOutput i) 
            {
            }*/
            ENDCG
        }
    }
}
