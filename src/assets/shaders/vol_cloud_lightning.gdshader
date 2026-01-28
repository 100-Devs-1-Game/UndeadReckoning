shader_type spatial;

uniform float time_scale = 1.0;
uniform vec3 cloud_color : source_color = vec3(0.12, 0.14, 0.18);
uniform vec3 lightning_color : source_color = vec3(0.4, 0.7, 1.0);

varying vec3 v_world_pos;

const int MARCH_STEPS = 48;
const float STEP_SIZE = 0.5;

/* ---------------- Vertex ---------------- */

void vertex() {
	v_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

/* ---------------- Time ---------------- */

float ttime() {
	return TIME * time_scale;
}

/* ---------------- Noise ---------------- */

float hash(float n) {
	return fract(sin(n) * 43758.5453);
}

vec3 hash33(vec3 p) {
	p = fract(p * 0.1031);
	p += dot(p, p.yzx + 33.33);
	return fract((p.xxy + p.yzz) * p.zyx);
}

float noise(vec3 p) {
	vec3 i = floor(p);
	vec3 f = fract(p);
	vec3 u = f * f * (3.0 - 2.0 * f);

	return mix(
		mix(
			mix(dot(hash33(i + vec3(0,0,0)), f),
			    dot(hash33(i + vec3(1,0,0)), f - vec3(1,0,0)), u.x),
			mix(dot(hash33(i + vec3(0,1,0)), f - vec3(0,1,0)),
			    dot(hash33(i + vec3(1,1,0)), f - vec3(1,1,0)), u.x),
			u.y),
		mix(
			mix(dot(hash33(i + vec3(0,0,1)), f - vec3(0,0,1)),
			    dot(hash33(i + vec3(1,0,1)), f - vec3(1,0,1)), u.x),
			mix(dot(hash33(i + vec3(0,1,1)), f - vec3(0,1,1)),
			    dot(hash33(i + vec3(1,1,1)), f - vec3(1,1,1)), u.x),
			u.y),
		u.z);
}

/* ---------------- Clouds ---------------- */

float cloud_density(vec3 p) {
	p *= 0.35;
	p.y += ttime() * 0.2;

	float d = noise(p);
	d += 0.5 * noise(p * 2.0);
	return clamp(d - 0.3, 0.0, 1.0);
}

/* ---------------- Lightning ---------------- */

float lightning(vec3 p) {
	float n = noise(p * 3.0 + ttime() * 2.0);
	return smoothstep(0.78, 0.9, n);
}

/* ---------------- Fragment ---------------- */

void fragment() {
	vec3 ray_origin = CAMERA_POSITION_WORLD;
	vec3 ray_dir = normalize(v_world_pos - ray_origin);

	vec3 col = vec3(0.0);
	vec3 emit = vec3(0.0);

	vec3 pos = ray_origin;

	for (int i = 0; i < MARCH_STEPS; i++) {
		pos += ray_dir * STEP_SIZE;

		float d = cloud_density(pos);
		col += d * cloud_color * 0.04;

		float l = lightning(pos);
		emit += l * lightning_color * 0.2;
	}

	ALBEDO = col;
	EMISSION = emit;
}
