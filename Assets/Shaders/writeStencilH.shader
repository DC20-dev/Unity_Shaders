// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/writeStencilH"
{
	Properties{
	}

	Subshader
	{
        Tags{
            "RenderPipeline"="UniversalRenderPipeline" "Queue"="Geometry-1"
        }

		Pass
		{
			Stencil
			{
				Ref 1
				Comp always
				Pass replace
			}
			ColorMask 0
			ZWrite Off

			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma target 3.0

            #include "HLSLSupport.cginc"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

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
				return half4(1,1,1,1);
			}

			ENDHLSL
		}
	}
}