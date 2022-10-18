// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/grabPassH"
{
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("MainTexture", 2D) = "white" {}
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
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _CameraOpaqueTexture;

			
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
				half4 texColor = tex2D(_CameraOpaqueTexture, i.texcoord);
				return texColor * _Color;
			}

			ENDHLSL
		}
	}
}