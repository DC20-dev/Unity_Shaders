// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/textureNormalsH"
{
	Properties{
		_MainTex("MainTexture", 2D) = "white" {}
		_Frequency("Frequency", float) = 1
		_Speed("Speed", float) = 1
		_Amplitude("Amplitude", float) = 1
		_StartFrom("StartFrom", Range(0,1)) = 0

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
			uniform float _Frequency;
			uniform float _Speed;
			uniform float _Amplitude;
			uniform float _StartFrom;

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
				//vIn.xyz += _Amplitude * vNormal.xyz;
				vIn.xyz += sin((vNormal.xyz - _Time.y * _Speed) *_Frequency) * _Amplitude * vNormal.xyz;
				return vIn;
			}

			vertexOutput vert(vertexInput v)
			{
                vertexOutput o;
				v.vertex = normalMovement(v.vertex, v.normal);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);  //projection space
				o.texcoord.xy = v.texcoord; // TRANSFORM_TEX(v.texcoord, _MainTex).xy;
                return  o;
			}

			half4 frag(vertexOutput i): COLOR
			{
				half4 texColor = tex2D(_MainTex, i.texcoord);
				return texColor;
			}

			ENDHLSL
		}
	}
}