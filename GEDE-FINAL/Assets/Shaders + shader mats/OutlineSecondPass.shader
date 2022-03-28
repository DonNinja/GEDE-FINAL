Shader "Outline2" {

	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_LC("LC", Color) = (1,1,1,1)
		_CP("Camera Position", Vector) = (1,1,1)

		max_outline("Max Outline", Range(0.0, 0.01)) = 0.0
		sound_dist("Sound distance", Float) = 10.0
		sound_pos("Sound Position", Vector) = (1,1,1)
		player_pos("Player Position", Vector) = (1,1,1)
	}

		SubShader{
			Tags { "Queue" = "Geometry" }

			Pass {
				Name "SettingOutline"

				Cull Front

				GLSLPROGRAM

				#ifdef VERTEX

				uniform vec4 _CP;
				varying vec3 _LV;
				varying vec3 _LN;
				varying vec3 _VP;
				varying vec3 sound_pos;
				varying vec4 outline_offset;
				varying vec2 TextureCoordinate;
				uniform float max_outline;

				void main() {
					TextureCoordinate = gl_MultiTexCoord0.xy;

					vec3 ecPosition = vec3(gl_ModelViewMatrix * gl_Vertex);
					vec3 tnorm = normalize(gl_NormalMatrix * gl_Normal);
					vec3 viewVec = normalize(-ecPosition);

					_VP = ecPosition;
					_LV = viewVec;
					_LN = tnorm;
					vec3 norm_offset = tnorm * max_outline;
					gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex + vec4(norm_offset, -0.009);
				}

				#endif

				#ifdef FRAGMENT

				uniform vec4 _LC;
				varying vec3 _LV;
				varying vec3 _LN;
				varying vec3 _VP;
				uniform vec3 sound_pos;
				uniform vec3 player_pos;
				uniform float sound_dist;
				uniform float max_outline;

				void main() {
					if (max_outline == 0) {
						discard;
					}

					vec3 sound_offset = player_pos - sound_pos;

					// If it's out of range
					if (distance(_VP, sound_offset) > sound_dist) {
						//gl_FragColor = vec4(1, 0, 0, 1);
						//return;
						discard;
					}

					gl_FragColor = _LC;
				}
				#endif

				ENDGLSL
			}
		}
}