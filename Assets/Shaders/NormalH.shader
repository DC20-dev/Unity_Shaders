// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/NormalH"
{
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("MainTexture", 2D) = "white" {}
		_NormalMap("NormalMap", 2D) = "white" {}
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

            #include "HLSLSupport.cginc"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

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
				float4 tangent : TANGENT;
			};
			struct vertexOutput
			{
                float4 pos : SV_POSITION;
				float4 texcoord : TEXCOORD0;
				float4 normalWorld : TEXCOORD1;
				float4 tangentWorld : TEXCOORD2;
				float3 binormalWorld : TEXCOORD3;
				float4 normalTexCoord : TEXCOORD4;
			};

			vertexOutput vert(vertexInput v)
			{
                vertexOutput o;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);  //projection space
				o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex).xy;

				o.normalTexCoord.xy = TRANSFORM_TEX(v.texcoord, _NormalMap);
				o.normalWorld = float4(TransformObjectToWorldNormal(v.normal.xyz), v.normal.w);

				o.tangentWorld = float4(normalize(mul((float3x3)unity_ObjectToWorld, v.tangent.xyz)),v.tangent.w);

				o.binormalWorld = float3(normalize(cross(o.normalWorld, o.tangentWorld) * v.tangent.w));//UV Flipped?
				o.binormalWorld  *= unity_WorldTransformParams.w;	//Negative scale?

                return  o;
			}

			float3 normalFromColor(float4 color)
			{
				#if defined(UNITY_NO_DXT5nm)
					//normal map is not compressed
					return color.rgb * 2 - 1;
				#else
					//normal map uses DXT5 compression
					float3 normalDecompressed;
					normalDecompressed = float3(
						color.a * 2 - 1,
						color.g * 2 - 1,
						0
					);
					normalDecompressed.z = sqrt(1-dot(normalDecompressed.xy, normalDecompressed.xy));
					return normalDecompressed;
				#endif
			}

			half4 frag(vertexOutput i): COLOR
			{
				half4 finalColor = half4(1,1,1,1);
				
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

				return finalColor;
			}

			ENDHLSL
		}
	}
}