﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/CaptureDepth" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
        _Blend ("Blend", Range(0,1)) = 0
	}
	SubShader {
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v) {
                float2 uvFromBottom = v.uv;
                if (_ProjectionParams.x < 0)
                    uvFromBottom.y = 1 - uvFromBottom.y;

				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = float4(v.uv, uvFromBottom);
				return o;
			}
			
			sampler2D _MainTex;
            sampler2D _CameraDepthTexture;
            float _Blend;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv.xy);
				float d = Linear01Depth(tex2D(_CameraDepthTexture, i.uv.zw).x);
				return lerp(col, d, _Blend);
			}
			ENDCG
		}
	}
}
