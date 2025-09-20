precision highp float;
precision highp sampler2D;

out vec3 interpolatedNormal;
uniform vec3 intensity0;
uniform int tvChannel0;

uniform int time;
uniform sampler2D fft;

// Fonction qui retourne un vecteur pseudo aléatoire inspiré par 
// (https://thebookofshaders.com/11/)
float random(vec3 p) {
    return fract(sin(dot(p, vec3(127.1,311.7,74.7))) * 43758.5453123);
}

// Fonction qui retourne une position float d'un point dans une cellule 
float noise(in vec3 st) {
	// On vient prendre les positions dans la cellule
    vec3 i = floor(st);
    vec3 f = fract(st);

    // On doit avoir 8 coints aléatoires puisqu'on est en 3D (seulement 4 si on 
	// génère du bruit en 2D comme dans l'exemple ici: 
	// https://thebookofshaders.com/11/)
	float c000 = random(i + vec3(0.0, 0.0, 0.0));
    float c100 = random(i + vec3(1.0, 0.0, 0.0));
    float c010 = random(i + vec3(0.0, 1.0, 0.0));
	float c110 = random(i + vec3(1.0, 1.0, 0.0));
    float c001 = random(i + vec3(0.0, 0.0, 1.0));
	float c101 = random(i + vec3(1.0, 0.0, 1.0));
	float c011 = random(i + vec3(0.0, 1.0, 1.0));
	float c111 = random(i + vec3(1.0, 1.0, 1.0));

	// On rend ça smooth pour chaque axes, pour pas que la différence soi 
	// trop visible entre les positions
	vec3 u = smoothstep(vec3(0.0), vec3(1.0), f);

	// On interpole pour x y et z
	float x00 = mix(c000, c100, u.x);
	float x10 = mix(c010, c110, u.x);
	float x01 = mix(c001, c101, u.x);
	float x11 = mix(c011, c111, u.x);
	float y0  = mix(x00,  x10,  u.y);
	float y1  = mix(x01,  x11,  u.y);
	float n   = mix(y0,   y1,   u.z);

	// On retourne un résultat entre 0.0 et 1.0
    return n;
}


void main() {
	
	// On va ensuite envoyer la interpolatedNormal au fragment shader
    interpolatedNormal = normal;

	// On utilise une map des frequences, afin que le choix des 
	// TVChannels, soit dynamique
	const float FREQUENCE_MAP[3] = float[3](0.20, 0.40, 0.60);

	float x = FREQUENCE_MAP[tvChannel0];

	// Afin d'accéder à l'amplitude de la transformation de fourrier
	float amp = texture(fft, vec2(x, 0.5)).x;

	// On limite l'amplitude entre 0.0 et 1.0 par rapport à l'intensité du 
	// controlleur
	float contrib = clamp(intensity0.y / 20.0 * amp, 0.0, 1.0);

	// On utilise la variable de temps pour ajouter du pseudo aléatoire
    float t = float(time) * 0.001;

	// Utilisation de la variable de temps:
	vec3 offset = vec3(t*0.2);

	// Utilisation de la fonction noise pour créer un offset sur la géométrie 
	// des points
	float n = noise(position * 8.0 + offset);

	// Pour finir on utilise la position courrante et on y additionne le
	// déplacement aléatoire.
   	vec3 newPos = position + normalize(normal) * (contrib * n);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(newPos, 1.0);
}
