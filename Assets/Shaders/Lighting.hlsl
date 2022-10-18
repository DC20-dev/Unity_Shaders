#ifndef LIGHTING
			#define LIGHTING
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
            half3 DiffuseLambert(float3 normalVal, float3 lightDir, half3 lightColor, float diffuseFactor, float attenuation)
			{
				return lightColor * diffuseFactor * attenuation * max(0,dot(normalVal, lightDir));
			}
#endif