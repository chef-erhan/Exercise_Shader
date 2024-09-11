Shader "Jettelly/BIRP/Game Fruits/Jet_fruits_HLSL"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _GlitTex ("Glitter Texture", 2D) = "black" {} 
        _GlitPow ("Glitter Power", Range(0, 1)) = 1
        [Space(10)]
        _SpecInt ("Specular Insensity", Range(0, 1)) = 1
        _SpecPow ("Specular Power", Range(1, 128)) = 64 
        [Space(10)]
        _FresInt ("Fresnel Intensity", Range(0, 1)) = 1
        _FresPow ("Fresnel Power", Range(1, 5)) = 3
        _FresCol ("Fresnel Color", Color) = (1, 1, 1, 1)
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Assets/JettellyCommon/CGinc/JettellyCommon.cginc"
            #include "Assets/JettellyCommon/CGinc/ShaderGraphNodes.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal: NORMAL;
                float4 tangent : TANGENT;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;                
                float3 vertex_pos : TEXCOORD2;
                float3 normal_dir : TEXCOORD3;
                float3 tangent_dir : TEXCOORD4;
                float3 bitangent_dir : TEXCOORD5;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _LightColor0;
            float _SpecInt;
            float _SpecPow;
            float _FresPow;    
            float _FresInt;
            float4 _FresCol;
            float _GlitPow;
                      
            Texture2D _GlitTex; 
            SamplerState sampler_GlitTex;               

            v2f vert (appdata v)
            {
                v2f o;      
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);          
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);               
                o.vertex_pos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normal_dir = UnityObjectToWorldNormal(v.normal);
                o.tangent_dir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 )).xyz );
                o.bitangent_dir = normalize(cross(o.normal_dir, o.tangent_dir) * v.tangent.w);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {                
                //half3 vertex_pos = mul(unity_ObjectToWorld, i.vertex_pos);
                half3 light_dir = normalize(_WorldSpaceLightPos0.xyz);
                half3 view_dir = normalize(_WorldSpaceCameraPos.xyz - i.vertex_pos);

                fixed4 col = tex2D(_MainTex, i.uv); 
                half4 fresnel = Unity_FresnelEffect(i.normal_dir, view_dir, _FresPow) * _FresCol;
                fresnel *= _FresInt;
                col.rgb += fresnel;    
                half specular = Jettelly_SpecularShading(_LightColor0.rgb, _SpecInt, i.normal_dir, light_dir, view_dir, _SpecPow );
                specular = 1 - smoothstep(specular - 0.025, specular + 0.025, 0.1);
                col.rgb += specular;  
                half3 glitter = Jettelly_Glitter(i.tangent_dir, i.bitangent_dir, i.normal_dir, view_dir, i.uv, _GlitTex, sampler_GlitTex, _GlitPow);
                col.rgb += glitter;
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
