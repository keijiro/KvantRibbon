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
        _Color ("-", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        //Cull Back 
        
        CGPROGRAM

        #pragma surface surf Standard vertex:vert nolightmap addshadow
        #pragma target 3.0

        sampler2D _PositionTex;
        float4 _PositionTex_TexelSize;

        float _RibbonWidth;
        half4 _Color;
        half _Metallic;
        half _Smoothness;

        float2 _BufferOffset;

        struct Input { half dummy; };

        void vert(inout appdata_full v, out Input data)
        {
            UNITY_INITIALIZE_OUTPUT(Input, data);

            float4 uv = float4(v.texcoord + _BufferOffset, 0, 0);
            float4 duv = float4(_PositionTex_TexelSize.x, 0, 0, 0);

            float3 p1 = tex2Dlod(_PositionTex, uv).xyz;
            float3 p2 = tex2Dlod(_PositionTex, uv + duv).xyz;
            float3 p3 = tex2Dlod(_PositionTex, uv + duv * 2).xyz;

            float3 bn = normalize(cross(p3 - p2, p2 - p1));

            v.vertex.xyz = bn * v.vertex.x * _RibbonWidth + p1.xyz;
            v.normal = normalize(cross(bn, p2 - p1));
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = _Color;
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;
        }

        ENDCG

        //Cull Front
        
        CGPROGRAM

        #pragma surface surf Standard vertex:vert nolightmap addshadow
        #pragma target 3.0

        sampler2D _PositionTex;
        float4 _PositionTex_TexelSize;

        float _RibbonWidth;
        half4 _Color;
        half _Metallic;
        half _Smoothness;

        float2 _BufferOffset;

        struct Input { half dummy; };

        void vert(inout appdata_full v, out Input data)
        {
            UNITY_INITIALIZE_OUTPUT(Input, data);

            float4 uv = float4(v.texcoord + _BufferOffset, 0, 0);
            float4 duv = float4(_PositionTex_TexelSize.x, 0, 0, 0);

            float3 p1 = tex2Dlod(_PositionTex, uv).xyz;
            float3 p2 = tex2Dlod(_PositionTex, uv + duv).xyz;
            float3 p3 = tex2Dlod(_PositionTex, uv + duv * 2).xyz;

            float3 bn = normalize(cross(p3 - p2, p2 - p1));

            v.vertex.xyz = -bn * v.vertex.x * _RibbonWidth + p1.xyz;
            v.normal = -normalize(cross(bn, p2 - p1));
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = _Color;
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;
        }

        ENDCG
    }
}
