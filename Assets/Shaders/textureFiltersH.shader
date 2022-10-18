// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/textureFiltersH"
{
	Properties{
		_MainTex("MainTexture", 2D) = "white" {}
		_Frequency("Frequency",float) = 0
		_Phase("Phase",float) = 0
		_Amplitude("Amplitude",float) = 0

		[KeywordEnum(0_Gradient,1_Sin,2_YSimmetry,3_FlipY,4_Pixelate,5_Scan)] _Fx ("Fx", float) = 0
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
			uniform float _Phase;
			uniform float _Amplitude;
			uniform float _Fx;


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
				half4 texColor;

				if(_Fx == 0)
				{
					texColor = half4(tex2D(_MainTex,i.texcoord).xyz, i.texcoord.x);
				}
				if(_Fx == 1)
				{
					float seno = sin((i.texcoord.y *_Frequency) +_Phase)*_Amplitude;
					half4 Uv = half4(i.texcoord.x+seno, i.texcoord.yzw);
					texColor = tex2D(_MainTex, Uv);
				}
				if(_Fx == 2)
				{
					float x = i.texcoord.x;
					if(i.texcoord.x > _Phase)
						x = 1-(i.texcoord.x);

					half4 Uv = half4(x, i.texcoord.yzw);
					texColor = tex2D(_MainTex, Uv);
				}
				if(_Fx == 3)
				{
					float x = 1-i.texcoord.x;
					texColor = tex2D(_MainTex, half4(x, i.texcoord.yzw));
				}
				if(_Fx == 4)
				{
					float4 Uv = round(i.texcoord * _Frequency*10)/(_Frequency*10);
					texColor = tex2D(_MainTex,Uv);
				}
				if(_Fx == 5)
				{
					float y = round(i.texcoord.y*10/_Frequency*10);
					float ymod = fmod(y,2);
					half4 Uv;
					if(ymod == 0)
						Uv = half4(i.texcoord.x + _Amplitude, i.texcoord.yzw);
					else
						Uv = half4(i.texcoord.x - _Amplitude, i.texcoord.yzw);

					texColor = tex2D(_MainTex,Uv);
				}
				return texColor;
			}

			ENDHLSL
		}
	}
}