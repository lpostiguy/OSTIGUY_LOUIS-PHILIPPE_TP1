in vec3 interpolatedNormal;
uniform sampler2D fft;
uniform int tvChannel1, tvChannel2;
uniform vec3 intensity1, intensity2;

void main() {

	// On utilise une map des frequences, afin que le choix des 
	// TVChannels, soit dynamique
  const float FREQUENCE_MAP[3] = float[3](0.20, 0.40, 0.60);
  
  float x1 = FREQUENCE_MAP[tvChannel1];
	float x2 = FREQUENCE_MAP[tvChannel2];

  // Afin d'accéder à l'amplitude de la transformation de fourrier
  float amplitude1 = texture(fft, vec2(x1, 1.0)).x;
float amplitude2 = texture(fft, vec2(x2, 1.0)).x;

  // On limite l'amplitude entre 0.25 et 1.0 par rapport à l'intensité du 
	// controlleur
	float contrib1 = clamp(intensity1.y * amplitude1, 0.25, 1.0);
	float contrib2 = clamp(intensity2.y * amplitude2, 0.25, 1.0);

  gl_FragColor = vec4(normalize(interpolatedNormal) * vec3(contrib1, contrib2, contrib2), 1);
}
