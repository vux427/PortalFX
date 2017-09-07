Shader "Effect/DistortionPostFX"
{
	Properties
	{
		[NoScaleOffset]_MainTex ("Color Texture", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)	
		_TintStrengthen("Tint Strengthen", float) = 1	
		_Rotate("Rotate Speed",float) = 1
		[NoScaleOffset]_DistortTex ("Distortion Texture(Normal Map)", 2D) = "bump" {}
		_Distort("Distort Intensity",range(0,100)) = 1
		_DistortRotate("Distortion Rotate Speed",float) = 1

		[NoScaleOffset]_ColorDistortTex (" Color Distort Texture", 2D) = "white" {}
		_ScrollSpeed("Scroll Speed",float) = 1
		_DistortColor("Color Map Distort Intensity",range(0,200)) = 1


	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
		Blend One OneMinusSrcAlpha
		Lighting Off
		Fog { Mode Off }
		ZWrite Off
		Cull Off

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			//#include "../../CGExtension.cginc"

			struct v2f
			{
				fixed4 uv : TEXCOORD0;
				fixed4 vertex : SV_POSITION;
				fixed4 screenPos : TEXCOORD1;
				fixed2 uv2 : TEXCOORD2;
			};

			sampler2D _MainTex,_DistortTex,_ColorDistortTex,_ScreenTex;
			fixed4 _MainTex_ST,_DistortTex_ST,_ColorDistortTex_ST,_ScreenTex_ST;
			fixed4 _MainTex_TexelSize,_DistortTex_TexelSize,_ScreenTex_TexelSize;
			fixed4 _Tint;

			fixed _DistortColor,_Rotate,_Distort,_DistortRotate,_ScrollSpeed,_TintStrengthen;
	
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				// Pivot
				fixed2 pivot = fixed2(.5,.5);
				// Rotation Matrix
				fixed cosAngle = cos(_Time * _Rotate);
				fixed sinAngle = sin(_Time * _Rotate);
				fixed2x2 rot = fixed2x2(cosAngle, -sinAngle, sinAngle, cosAngle);

				// Rotation consedering pivot
				o.uv.xy = mul(rot, v.texcoord.xy - pivot);
				o.uv.xy += pivot;

				//distort rotate
				cosAngle = cos(_Time * _DistortRotate);
				sinAngle = sin(_Time * _DistortRotate);
				rot = fixed2x2(cosAngle, -sinAngle, sinAngle, cosAngle);
				o.uv.zw = mul(rot, v.texcoord.xy - pivot);
				o.uv.zw += pivot;

				//scrolling
				o.uv2 = v.texcoord + _Time.x * _ScrollSpeed ;
				o.screenPos = ComputeScreenPos(o.vertex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 distortMap = UnpackNormal(tex2D(_DistortTex, i.uv.zw));
				fixed3 distortMap2 = tex2D(_ColorDistortTex, i.uv2);
				i.uv.xy += ((distortMap2.rg * 2) -1)  * _DistortColor * _ScreenTex_TexelSize.xy;
				fixed4 color = tex2D(_MainTex, i.uv.xy);

				i.screenPos.xy += (distortMap.rg) *_Distort * 10 * _ScreenTex_TexelSize.xy;
				fixed4 screenColor = tex2Dproj(_ScreenTex, i.screenPos);

				return (color.a * screenColor + _Tint * _TintStrengthen * color.r) *_Tint.a ;
			}
			ENDCG
		}
	}
}
