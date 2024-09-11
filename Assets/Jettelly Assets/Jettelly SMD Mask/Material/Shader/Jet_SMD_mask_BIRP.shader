Shader "Jettelly/BIRP/SMD Mask/Jet_SDM_mask_BIRP"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MaskTex ("Mask Texture", 2D) = "black" {}
        [HideInInspector] _X ("X value", Float) = 0.0
        [HideInInspector] _Y ("Y Value", Float) = 0.0
        [HideInInspector] _S ("Mask Smooth", Range(0.01, 1.0)) = 0.01
        [HideInInspector] _R ("Mask Radius", Range(1.0, 5.0)) = 2.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Blend One OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag            
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv_mask : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 uv_mask : TEXCOORD2;
                float4 vertex_WP : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _MaskTex;
            float4 _MaskTex_ST;
            float _X;
            float _Y;
            float _S;
            float _R;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv_mask = TRANSFORM_TEX(v.uv_mask, _MaskTex);
                o.vertex_WP = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float circle (float2 uv, float2 r)
            {
                float c = length(uv - r);
                return c;
            }

            fixed4 frag (v2f i) : SV_Target
            {                
                fixed4 main = tex2D(_MainTex, i.uv);   
                fixed4 mask = tex2D(_MaskTex, i.uv_mask);  
                mask.rgb *= mask.a;

                float c = circle(i.vertex_WP.xy, float2(_X, _Y));
                c = smoothstep(c - _S, c + _S, _R);

                main *= 1 - c;
                mask *= c;
                main += mask;

                return main;
            }
            ENDCG
        }
    }
}
