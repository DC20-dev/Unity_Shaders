// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/transparentShaderH"
{
	Properties{
        _Color("Main Color", Color) = (1,1,1,1)
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("BlendSRC", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("BlendDST", Float) = 1
		[Enum(UnityEngine.Rendering.BlendOp)] _BlendOp ("BlendOP", Float) = 1
	}

	Subshader
	{
        Tags{
            "RenderPipeline"="UniversalRenderPipeline" "Queue"="Transparent"
        }

		Pass
		{
			// ZWrite Off
			// Blend One One
			// BlendOp Add

			//MULTIPLY
			// Blend DstColor Zero
			// BlendOp Add

			//CLASSIC ALPHABLENDING
			// Blend SrcAlpha OneMinusSrcAlpha
			// BlendOp Add

			//CUSTOM
			Blend [_BlendSrc] [_BlendDst]
			BlendOp [_BlendOp]

			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma target 3.0

            #include "HLSLSupport.cginc"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			uniform half4 _Color;

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
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);  //projection space
                return  o;
			}

			half4 frag(vertexOutput i): COLOR
			{
				return _Color;
			}

			ENDHLSL
		}
	}
}