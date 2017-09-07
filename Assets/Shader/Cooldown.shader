// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/Cooldown"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Rotate("Rotate Speed",range(-2,1)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
		Blend srcAlpha one

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"


			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _Rotate;
			v2f_img vert (appdata_base v)
			{
				v2f_img o;
				fixed2 pivot = fixed2(.5,.5);

				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);


				return o;
			}
			
			fixed4 frag (v2f_img i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed angle = -atan2(i.uv.y - 0.5,i.uv.x - 0.5) / UNITY_PI;

	
				col.a *= smoothstep(0,1,distance(angle,_Rotate));
	

				return col;
			}
			ENDCG
		}
	}
}
