//
// Surface shader for Ribbon
//
// Texture format:
//
// _PositionTex.xyz = position
// _PositionTex.w   = random number
//
Shader "Custom/Ribbon"
{
    Properties
    {
        _PositionTex ("-", 2D) = ""{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        CGPROGRAM

        #pragma surface surf Standard vertex:vert nolightmap addshadow
        #pragma target 3.0

        sampler2D _PositionTex;
        float4 _PositionTex_TexelSize;

        float2 _BufferOffset;

        struct Input { half dummy; };

        void vert(inout appdata_full v, out Input data)
        {
            UNITY_INITIALIZE_OUTPUT(Input, data);

            float4 uv = float4(v.texcoord + _BufferOffset, 0, 0);
            float4 uv2 = uv + float4(_PositionTex_TexelSize.x, 0, 0, 0);

            float3 p1 = tex2Dlod(_PositionTex, uv).xyz;
            float3 p2 = tex2Dlod(_PositionTex, uv2).xyz;

            float3 n = normalize(cross(p1, p2));

            v.vertex.xyz = n * v.vertex.x * 0.1 + p1.xyz;
            v.normal = n;
            //v.vertex.xyz += p.w;
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = half4(1, 0.8, 0.8, 1);
            o.Metallic = 0.85;
            o.Smoothness = 0.85;
        }

        ENDCG
    }
}
