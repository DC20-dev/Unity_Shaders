// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/explosionH"
{
	Properties{
		_MainTex("MainTexture", 2D) = "white" {}
		_Amplitude("Amplitude", Range(1,5)) = 1
		_StartFade("StartFade", Range(1,5)) = 1
		_EndFade("EndFade", Range(1,5)) = 1
	}

	Subshader
	{
        Tags{
            "RenderPipeline"="UniversalRenderPipeline" "Queue"="Transparent"
        }

		Pass
		{
			ZWrite Off
			//CLASSIC ALPHABLENDING
			Blend SrcAlpha OneMinusSrcAlpha
			BlendOp Add

			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma target 3.0

            #include "HLSLSupport.cginc"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _Amplitude;
			uniform float _StartFade;
			uniform float _EndFade;

			struct vertexInput
			{
                float4 vertex : POSITION;   //object space
				float4 texcoord : TEXCOORD0;
				float4 normal : NORMAL;
			};
			struct vertexOutput
			{
                float4 pos : SV_POSITION;
				float4 texcoord : TEXCOORD0;
			};

			float4 normalMovement(float4 vIn, float4 vNormal)
			{
				vIn += vNormal * (_Amplitude-1);
				vIn.w = 1;
				return vIn;
			}

			vertexOutput vert(vertexInput v)
			{
                vertexOutput o;
				v.vertex = normalMovement(v.vertex, v.normal);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);  //projection space
				o.texcoord.xy = v.texcoord;
                return  o;
			}

			half4 frag(vertexOutput i): COLOR
			{
				half4 texColor = tex2D(_MainTex, i.texcoord);
				texColor.w = smoothstep(_EndFade, _StartFade, _Amplitude);
				return texColor;
			}

			ENDHLSL
		}
	}
}