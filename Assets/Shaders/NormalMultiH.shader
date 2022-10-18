// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/NormalMultiH"
{
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("MainTexture", 2D) = "white" {}
		_NormalMap("NormalMap", 2D) = "white" {}

		[KeywordEnum(Off,On)] _UseNormal("Use Normal Map", float) = 0
	}

	Subshader
	{
        Tags{
            "RenderPipeline"="UniversalRenderPipeline" "Queue"="Transparent"
        }

		Pass
		{
			//CLASSIC ALPHABLENDING
			Blend SrcAlpha OneMinusSrcAlpha
			BlendOp Add

			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma target 3.0

			#pragma shader_feature _USENORMAL_ON _USENORMAL_OFF

            #include "HLSLSupport.cginc"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Lighting.hlsl"

			uniform half4 _Color;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;			
			uniform sampler2D _NormalMap;
			uniform float4 _NormalMap_ST;

			struct vertexInput
			{
                float4 vertex : POSITION;   //object space
				float4 texcoord : TEXCOORD0;
				float4 normal : NORMAL;
				#if _USENORMAL_ON
				float4 tangent : TANGENT;
				#endif
			};
			struct vertexOutput
			{
                float4 pos : SV_POSITION;
				float4 texcoord : TEXCOORD0;
				float4 normalWorld : TEXCOORD1;
				#if _USENORMAL_ON
				float4 tangentWorld : TEXCOORD2;
				float3 binormalWorld : TEXCOORD3;
				float4 normalTexCoord : TEXCOORD4;
				#endif
			};

			vertexOutput vert(vertexInput v)
			{
                vertexOutput o;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);  //projection space
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex).xy;

				o.normalWorld = float4(TransformObjectToWorldNormal(v.normal.xyz), v.normal.w);
				#if _USENORMAL_ON
				o.normalTexCoord.xy = TRANSFORM_TEX(v.texcoord, _NormalMap);
				o.tangentWorld = float4(normalize(mul((float3x3)unity_ObjectToWorld, v.tangent.xyz)),v.tangent.w);

				o.binormalWorld = float3(normalize(cross(o.normalWorld, o.tangentWorld) * v.tangent.w));//UV Flipped?
				o.binormalWorld  *= unity_WorldTransformParams.w;	//Negative scale?
				#endif

                return  o;
			}

			half4 frag(vertexOutput i): COLOR
			{
				half4 finalColor = half4(1,1,1,1);
				#if _USENORMAL_ON
				half4 normalColor = tex2D(_NormalMap, i.normalTexCoord);
				//From normalcolor to tangent space normal
				float3 TSNormal = normalFromColor(normalColor);
				//Use normalWorld, tangentWorld, binormalWorld to build TBN Matrix
				float3x3 TBNWorld = float3x3(
					i.tangentWorld.x, i.binormalWorld.x, i.normalWorld.x,
					i.tangentWorld.y, i.binormalWorld.y, i.normalWorld.y,
					i.tangentWorld.z, i.binormalWorld.z, i.normalWorld.z
				);
				//From tangent space normal to WSNormalAtPixel
				float3 WSNormalAtPixel = normalize(mul(TBNWorld, TSNormal));	
				//debug
				//R not used(1), G=Y, B not used(same as G), A=X 

				finalColor = float4(WSNormalAtPixel.rgb,1);
				#else
				finalColor = float4(i.normalWorld.rgb,1);
				#endif
				return finalColor;
			}

			ENDHLSL
		}
	}
}