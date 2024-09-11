Shader "Jettelly/BIRP/Tape Measure"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MetalTex("Metal Texture", 2D) = "white" {}

        [HideInInspector] _uLength ("U Length", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}        

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            ZTest LEqual

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"
            #include "HLSLSupport.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 texcoord : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float4 vertex : SV_POSITION;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            sampler2D _MetalTex;
            float4 _MainTex_ST;     
            float _uLength;

            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.texcoord1 = v.texcoord1;
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half4 col = tex2D(_MainTex, i.texcoord);
                
                float2 uv = float2(i.texcoord1.x * _uLength - (_uLength - 1),  i.texcoord1.y);
                half4 met = tex2D(_MetalTex, uv);

                col.rgb *= 1 - met.a;
                met.rgb *= met.a;
                col += met;

                return saturate(col);
            }
            ENDCG
        }

        Pass
        {
            Blend One OneMinusSrcAlpha
            ZWrite Off
            ZTest GEqual

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"
            #include "HLSLSupport.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 texcoord : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float4 vertex : SV_POSITION;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            sampler2D _MetalTex;
            float4 _MainTex_ST;
            float _uLength;

            v2f vert(appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.texcoord1 = v.texcoord1;
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                half4 col = tex2D(_MainTex, i.texcoord);

                float2 uv = float2(i.texcoord1.x * _uLength - (_uLength - 1),  i.texcoord1.y);
                half4 met = tex2D(_MetalTex, uv);

                col.rgb *= 1 - met.a;
                met.rgb *= met.a;
                col += met;

                half3 red = half3(1.0, 0.6, 0.6);
                col.rgb *= red;

                return saturate(col);
            }
            ENDCG
        }
    }
}
