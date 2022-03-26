Shader "OutlineTest" {
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

				void main() {
					TextureCoordinate = gl_MultiTexCoord0.xy;

					vec3 ecPosition = vec3(gl_ModelViewMatrix * gl_Vertex);
					vec3 tnorm = normalize(gl_NormalMatrix * gl_Normal);
					vec3 viewVec = normalize(-ecPosition);

					//vec3 lightVec = normalize(_CP.xyz - ecPosition);
					//vec3 reflectVec = reflect(-lightVec, tnorm);

					_VP = ecPosition;
					_LV = viewVec;
					_LN = tnorm;
					gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex + vec4(gl_Normal, 0) * 0.01;
				}

			#endif

			#ifdef FRAGMENT

			#define PI 3.1415926538

				//uniform sampler2D _MainTex;
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

					// If it's out of range
					if (distance(_VP, sound_pos) > sound_dist) {
						discard;
					}

					if (!gl_FrontFacing) {
						discard;
					}

					vec4 c;
					float minSeparation = 1.0;
					float maxSeparation = 3.0;
					float minDistance = 0.5;
					float maxDistance = 2.0;
					float far = 10;
					float near = 1;
					int   size = 5;
					vec3  colorModifier = vec3(0.522, 0.431, 0.349);

					vec2 texSize = textureSize(_MainTex, 1).xy;
					vec2 texCoord = TextureCoordinate;

					vec4 position = texture(_MainTex, texCoord);
					vec4 positionTemp = position;
					vec4 fragColor = vec4(0.0);
					vec2 fragCoord = gl_FragCoord.xy;

					vec3 rgb_normal = _LN * 0.5 + 0.5;

					float depth = clamp(1.0 - ((far - position.y) / (far - near)) , 0.0 , 1.0);

					float separation = mix(maxSeparation, minSeparation, depth);
					float count = 1.0;
					float mx = 0.0;

					c.xyz = vec3(0, 0, 0);

					for (int i = -size; i <= size; ++i) {
						for (int j = -size; j <= size; ++j) {
							texCoord = (vec2(i, j) * separation + fragCoord) / texSize;

							positionTemp = texture(_MainTex, texCoord);

							if (positionTemp.y <= 0.0) {
								positionTemp.y = far;

							}

							mx = max(mx, abs(position.y - positionTemp.y));
						}
					}
					float diff = smoothstep(minDistance, maxDistance, mx);

					vec3 lineColor = _LC.rgb;
					lineColor *= colorModifier;

					gl_FragColor.rgb = mix(c.rgb, lineColor.rgb, clamp(diff, 0.0, 1.0));
					gl_FragColor.a = 1.0;
				}

			#endif

			ENDGLSL
		}

		Pass{

		}
		}
}