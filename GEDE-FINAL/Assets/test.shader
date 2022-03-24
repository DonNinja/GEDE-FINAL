Shader "OutlineTest" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_LC("LC", Color) = (1,1,1,1)
		_LP("LP", Vector) = (1,1,1,1)

		// New stuff

		_LV("LV", Vector) = (1,1,1)
		_LN("LN", Vector) = (1,1,1)
		//max_outline("Max Outline", Range(0.0, 1.0)) = 0.0
	}

		SubShader{
			Tags { "Queue" = "Geometry" }

			Pass {

				GLSLPROGRAM

				#ifdef VERTEX

				const float SpecularContribution = 0.3;
				const float DiffuseContribution = 1.0 - SpecularContribution;

				uniform vec4 _LP;
				varying vec3 _LV;
				varying vec3 _LN;
				varying vec2 TextureCoordinate;
				//varying float max_outline;
				varying float LightIntensity;

				void main() {
					gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
					TextureCoordinate = gl_MultiTexCoord0.xy;

					vec3 ecPosition = vec3(gl_ModelViewMatrix * gl_Vertex);
					vec3 tnorm = normalize(gl_NormalMatrix * gl_Normal);
					vec3 lightVec = normalize(_LP.xyz - ecPosition);

					vec3 reflectVec = reflect(-lightVec, tnorm);
					vec3 viewVec = normalize(-ecPosition);
					float diffuse = max(dot(lightVec, tnorm), 0.0);

					float spec = 0.0;
					if (diffuse > 0.0) {
						spec = max(dot(reflectVec, viewVec), 0.0);
						spec = pow(spec, 16.0);
					}

					LightIntensity = 1;
					//DiffuseContribution * diffuse + SpecularContribution * spec;

				_LV = viewVec;
				_LN = tnorm;
			}

			#endif

			#ifdef FRAGMENT

			uniform sampler2D _MainTex;
			varying vec2 TextureCoordinate;
			uniform vec4 _LC;
			varying vec3 _LV;
			varying vec3 _LN;
			varying float LightIntensity;

			void main() {
				vec4 c;
				float max_outline = 0.3;
				if (dot(_LV, _LN) > max_outline || dot(_LV, _LN) < -max_outline) {
					c.xyz = vec3(0, 0, 0);
				}
				else {
					//discard;
					c.xyz = vec3(1, 1, 1);
					//texture2D(_MainTex, TextureCoordinate).xyz * _LC.xyz;
				}

				 c *= LightIntensity;
				 c.w = 1.0;
				 gl_FragColor = c;
			}

		#endif

		ENDGLSL
	}
		}
}