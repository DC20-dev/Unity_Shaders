// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/XRay_View"
{
	Properties{
	}

	Subshader
	{
		
        Tags{
            "Queue"="Geometry" "Object"="Floor"
        }

		Pass
		{
			
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
                //i.pos = screen space
				half4 _FColor = half4(0.3,0.3,0.3,1);
                return _FColor;
			}

			ENDHLSL
		}
	}
		Subshader
	{
        Tags{
            "Queue"="Transparent" "Object"="Wall"
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
				half4 _WColor = half4(0.5,0.5,0.5,0.8);
                return _WColor;
			}

			ENDHLSL
		}
	}
		Subshader
	{
        Tags{
            "Queue"="Transparent+100" "Object"="Enemy"
        }

		Pass
		{

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
                //i.pos = screen space
				half4 _EColor = half4(1,0,0,1);
                return _EColor;
			}

			ENDHLSL
		}
	}
		Subshader
	{
        Tags{
            "Queue"="Geometry" "Object"="Friend"
        }

		Pass
		{
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
                //i.pos = screen space
				half4 _FColor = half4(0,1,0,1);
                return _FColor;
			}

			ENDHLSL
		}
	}
}