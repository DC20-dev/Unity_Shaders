// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/textureOutlineSelectedH"
{
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("MainTexture", 2D) = "white" {}
		_Border("Border", Range(0,1)) = 0.20
		_HighlightSpeed("Highlight Speed", Range(0,360)) = 60
	}

	Subshader
	{
        Tags{
            "RenderPipeline"="UniversalRenderPipeline" "Queue"="Transparent"
        }

		Pass
		{
			ZWrite Off
			Cull Front

			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma target 3.0

            #include "HLSLSupport.cginc"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			uniform half4 _Color;
			uniform float _Border;
			uniform float _HighlightSpeed;

			struct vertexInput
			{
                float4 vertex : POSITION;   //object space
			};
			struct vertexOutput
			{
                float4 pos : SV_POSITION;
			};

			vertexOutput vert(vertexInput v)
			{
                vertexOutput o;
				float offset = sin(_Time * _HighlightSpeed) * _Border;
				float4x4 scaleM = float4x4(
					1+offset, 0, 0, 0,
					0, 1+offset, 0, 0,
					0, 0, 1+offset, 0,
					0, 0, 0, 1
				);
				float4 scaledObjPos = mul( scaleM ,v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, scaledObjPos);  //projection space
                return  o;
			}

			half4 frag(vertexOutput i): COLOR
			{
				return _Color;
			}

			ENDHLSL
		}
		
		Pass
		{
			//CLASSIC ALPHABLENDING
			Blend SrcAlpha OneMinusSrcAlpha
			BlendOp Add

			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma target 3.0

            #include "HLSLSupport.cginc"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			uniform half4 _Color;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;

			struct vertexInput
			{
                float4 vertex : POSITION;   //object space
				float4 texcoord : TEXCOORD0;
			};
			struct vertexOutput
			{
                float4 pos : SV_POSITION;
				float4 texcoord : TEXCOORD0;
			};

			vertexOutput vert(vertexInput v)
			{
                vertexOutput o;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);  //projection space
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex).xy;
                return  o;
			}

			half4 frag(vertexOutput i): COLOR
			{
				half4 texColor = tex2D(_MainTex, i.texcoord);
				return texColor * _Color;
			}

			ENDHLSL
		}
	}
}