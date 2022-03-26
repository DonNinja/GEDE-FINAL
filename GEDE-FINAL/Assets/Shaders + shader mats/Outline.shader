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
				//Cull Front
				//Blend One One

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
					gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex * 2;
				}

				#endif

				#ifdef FRAGMENT

				#define PI 3.1415926538

				uniform sampler2D _MainTex;
				varying vec2 TextureCoordinate;
				uniform vec4 _CP;
				uniform vec4 _LC;
				varying vec3 _LV;
				varying vec3 _LN;
				varying vec3 _VP;
				uniform float _width;
				uniform float _height;
				uniform float _outline_thickness;
				uniform vec3 sound_pos;
				uniform float sound_dist;
				uniform float max_outline;

				void main() {
					//discard;
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