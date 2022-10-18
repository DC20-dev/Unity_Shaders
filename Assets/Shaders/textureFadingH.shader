// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/textureFadingH"
{
	Properties{
        _Color("Main Color", Color) = (1,1,1,1)
		_TexA("Texture A", 2D) = "white" {}
		_TexB("Texture B", 2D) = "white" {}
		_Fading("Blend", Range(0,1)) = 0
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

			uniform half4 _Color;
			uniform sampler2D _TexA;
			uniform sampler2D _TexB;
			uniform float _Fading;
			uniform float4 _TexA_ST;
			uniform float4 _TexB_ST;

			struct vertexInput
			{
                float4 vertex : POSITION;   //object space
				float4 texcoord : TEXCOORD0;
			};
			struct vertexOutput
			{
                float4 pos : SV_POSITION;
				float4 texcoordA : TEXCOORD0;
				float4 texcoordB : TEXCOORD1;
			};

			vertexOutput vert(vertexInput v)
			{
                vertexOutput o;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);  //projection space
				o.texcoordA.xy = TRANSFORM_TEX(v.texcoord, _TexA).xy;
				o.texcoordB.xy = TRANSFORM_TEX(v.texcoord, _TexB).xy;
                return  o;
			}

			half4 frag(vertexOutput i): COLOR
			{
				half4 texColorA = tex2D(_TexA, i.texcoordA);
				half4 texColorB = tex2D(_TexB, i.texcoordB);
				return _Color * (texColorB * _Fading + texColorA * (1-_Fading));
			}

			ENDHLSL
		}
	}
}