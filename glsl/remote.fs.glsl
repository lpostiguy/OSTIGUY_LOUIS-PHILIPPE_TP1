precision highp float;

uniform int tvChannel;
uniform vec3 remotePosition;

  // Plus que la position y du controlleur est grande, plus la couleurs du 
  // controlleur est vive.

void main() {
  float t = clamp(remotePosition.y / 4.0, 0.3, 1.0);

  // Afin d'avoir une couleur différente par controlleur:
  const vec3 COLOR_MAP[3] = vec3[3](vec3(0.2, 0.2, 1.0), vec3(1.0, 0.2, 0.2), vec3(0.2, 1.0, 0.2));
  
  vec3 color = COLOR_MAP[tvChannel] * t;

  gl_FragColor = vec4(color, 1.0);
}
