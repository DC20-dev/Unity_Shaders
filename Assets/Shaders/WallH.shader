// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/WallH"
{
	Properties{
        _Color("Main Color", Color) = (0.5,0.5,0.5,1)
	}

	Subshader
	{
        Tags{
            "Queue"="Geometry" "Object"="Wall"
        }

		Pass
		{
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
                //i.pos = screen space
                return _Color;
			}

			ENDHLSL
		}
	}
}