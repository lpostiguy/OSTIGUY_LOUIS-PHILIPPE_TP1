uniform vec3 remotePosition;
uniform float xoff;

void main() {
    // On bouge le controlleur sur l'axe de y par rapport à la position calculé 
    // lorsqu'on apuit sur "q", "w" ou "e" / "a", "s" ou "d" .
    vec3 translatedPosition = position + vec3(xoff, remotePosition.y, 0.0);

    gl_Position = projectionMatrix * modelViewMatrix * vec4( translatedPosition, 1.0);
}
