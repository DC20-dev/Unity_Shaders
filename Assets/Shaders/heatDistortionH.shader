// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/heatDistortionH"
{
	Properties{
        _Color("Main Color", Color) = (1,1,1,1)
		_NoiseTexture("Noise Texture", 2D) = "white" {}
		_FilterTexture("Filter Texture", 2D) = "white" {}
		_Speed("Heat Speed", float) = 0
		_Amplitude("Amplitude", Range(0,5)) = 1
	}

	Subshader
	{
        Tags{
            "RenderPipeline"="UniversalRenderPipeline" "Queue"="Transparent"
        }

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			BlendOp Add

			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma target 3.0

            #include "HLSLSupport.cginc"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			uniform half4 _Color;
			uniform float _Speed;
			uniform float _Amplitude;
			uniform sampler2D _CameraOpaqueTexture;
			uniform sampler2D _NoiseTexture;
			uniform sampler2D _FilterTexture;

			struct vertexInput
			{
                float4 vertex : POSITION;   //object space
				float4 texcoord : TEXCOORD0;
			};
			struct vertexOutput
			{
                float4 pos : SV_POSITION;
				float4 texcoord : TEXCOORD0;
				float4 texcoordGrab : TEXCOORD1;
			};

			float4 HeatOffset(float4 vIn, sampler2D noise, sampler2D filter)
			{
				float displacement = tex2Dlod(noise, vIn).x;
				float filterVal = tex2Dlod(filter, vIn).y;
				displacement = sin(displacement* _Time.y * _Speed) * (_Amplitude * filterVal );
				float displacement2 = sin(displacement* 0.5* _Time.x * _Speed*10) * (_Amplitude * filterVal );
				return float4(0, displacement+displacement2, 0, 0);
			}
			vertexOutput vert(vertexInput v)
			{
                vertexOutput o;
				o.texcoordGrab = ComputeScreenPos(mul(UNITY_MATRIX_MVP, v.vertex));	//[-w,w] => [0,w]
				v.vertex += HeatOffset(v.texcoord, _NoiseTexture, _FilterTexture);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);  //projection space
				o.texcoord = v.texcoord;
                return  o;
			}

			half4 frag(vertexOutput i): COLOR
			{
				//Auto mipmap index
				half4 texColor = tex2Dproj(_CameraOpaqueTexture, i.texcoordGrab);
				return texColor;
			}

			ENDHLSL
		}
	}
}