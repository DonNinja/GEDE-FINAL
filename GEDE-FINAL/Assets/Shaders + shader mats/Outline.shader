Shader "Outline" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_LC("LC", Color) = (1,1,1,1)
		_CP("Camera Position", Vector) = (1,1,1)

		max_outline("Max Outline", Range(0.0, 1.0)) = 0.0
		sound_dist("Sound distance", Float) = 10.0
		sound_pos("Sound Position", Vector) = (1,1,1)
	}

		SubShader{
			Tags { "Queue" = "Geometry" }

			Pass {
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

					vec3 lightVec = normalize(_CP.xyz - ecPosition);
					vec3 viewVec = normalize(-ecPosition);
					vec3 reflectVec = reflect(-lightVec, tnorm);

					_VP = ecPosition;
					_LV = viewVec;
					_LN = tnorm;
					gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				}

				#endif

				#ifdef FRAGMENT

				uniform vec4 _LC;

				void main() {
					gl_FragColor = _LC;
				}

				#endif

				ENDGLSL
			}

			Pass {
				Cull Front

				GLSLPROGRAM

				#ifdef VERTEX

				uniform vec4 _CP;
				varying vec3 _LV;
				varying vec3 _LN;
				varying vec3 _VP;
				varying vec3 sound_pos;
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
				uniform float sound_dist;
				uniform float max_outline;

				void main() {
					if (max_outline == 0) {
						discard;
					}

					// If it's out of range
					if (distance(_VP, sound_pos) > sound_dist) {
						discard;
					}

					gl_FragColor = _LC;
				}
				#endif

				ENDGLSL
			}
		}
}