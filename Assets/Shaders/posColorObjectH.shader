// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/posColorObjectH"
{
	Properties{
        //_Color("Main Color", Color) = (1,1,1,1)
        _ColorLeft("Left Color", Color) = (1,1,1,1)
        _ColorRight("Right Color", Color) = (0,0,0,1)
	}

	Subshader
	{
        Tags{
            "RenderPipeline"="UniversalRenderPipeline" "Queue"="Geometry"
        }

		Pass
		{
			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma target 3.0

            #include "HLSLSupport.cginc"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            //uniform half4 _Color;
			uniform half4 _ColorLeft;
			uniform half4 _ColorRight;

			struct vertexInput
			{
                float4 vertex : POSITION;   //object space
			};
			struct vertexOutput
			{
                float4 pos : SV_POSITION;
				float  xRange : DEPTH0;
			};

			vertexOutput vert(vertexInput v)
			{
                vertexOutput o;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);  //projection space
				o.xRange = smoothstep(-5,5,v.vertex.x);
                return  o;
			}

			half4 frag(vertexOutput i): COLOR
			{
                //return lerp(_ColorLeft,_ColorRight, i.xRange);
				return (_ColorLeft * i.xRange) + (_ColorRight * (1-i.xRange));
			}

			ENDHLSL
		}
	}
}