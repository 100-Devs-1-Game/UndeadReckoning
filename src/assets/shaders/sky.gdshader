shader_type sky;

/* =========================
   ATMOSPHERE
   ========================= */
uniform vec3 zenith_color : source_color = vec3(0.02, 0.03, 0.06);
uniform vec3 horizon_color : source_color = vec3(0.07, 0.08, 0.11);
uniform vec3 night_tint : source_color = vec3(0.01, 0.01, 0.02);

uniform float atmosphere_density = 1.4;
uniform float exposure = 1.0;

/* =========================
   SUN / MOON
   ========================= */
uniform vec3 sun_direction = vec3(0.0, 1.0, 0.0);
uniform vec3 sun_color : source_color = vec3(0.7, 0.8, 1.0);
uniform float sun_intensity = 0.6;

/* =========================
   CLOUD CONTROLS
   ========================= */
uniform float cloud_scale = 1.0;
uniform float cloud_speed = 0.01;
uniform float cloud_density = 1.0;
uniform float cloud_darkness = 0.6;
uniform float cloud_coverage = 0.25;
uniform float cloud_opacity = 1.0;
uniform vec3 cloud_color : source_color = vec3(0.15, 0.16, 0.18);

/* =========================
   NOISE
   ========================= */
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 5; i++) {
        v += a * noise(p);
        p *= 2.0;
        a *= 0.5;
    }
    return v;
}

float worley(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float d = 1.0;

    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 cell = vec2(float(x), float(y));
            vec2 point = vec2(
                hash(i + cell),
                hash(i + cell + vec2(1.0))
            );
            d = min(d, length(cell + point - f));
        }
    }
    return d;
}

/* =========================
   CLOUD FIELD
   ========================= */
float cloud_field(vec2 uv) {
    // Domain warp to break cellular artifacts
    vec2 warp;
    warp.x = fbm(uv * 0.8 + 10.0);
    warp.y = fbm(uv * 0.8 - 10.0);
    uv += (warp - 0.5) * 0.6;

    // Main shapes
    float base = fbm(uv * 0.4);

    // Subtle erosion (no longer dominant)
    float erosion = worley(uv * 1.8);
    erosion = smoothstep(0.3, 0.7, erosion);

    // Horizontal stratification
    float height_mask = smoothstep(0.0, 0.4, uv.y) *
                        smoothstep(1.0, 0.6, uv.y);

    float clouds = base * mix(1.0, erosion, 0.35);
    clouds *= height_mask;

    // Coverage as bias
    clouds = clamp(
        (clouds - cloud_coverage) / max(1.0 - cloud_coverage, 0.001),
        0.0,
        1.0
    );

    return clouds;
}


/* =========================
   SKY
   ========================= */
void sky() {
    vec3 dir = normalize(EYEDIR);
    float altitude = clamp(dir.y * 0.5 + 0.5, 0.0, 1.0);

    // Atmosphere
    float atm = pow(altitude, atmosphere_density);
    vec3 sky_col = mix(horizon_color, zenith_color, atm);
    sky_col = mix(night_tint, sky_col, altitude);

    // Sun / moon glow
    float sun_dot = max(dot(dir, normalize(sun_direction)), 0.0);
    float sun_glow = pow(sun_dot, 512.0) * sun_intensity;
    sky_col += sun_color * sun_glow;

    // Spherical UVs
    vec2 uv = vec2(
        atan(dir.x, dir.z) / (2.0 * PI) + 0.5,
        asin(dir.y) / PI + 0.5
    );

    uv *= cloud_scale;
    uv += TIME * cloud_speed;

    // Clouds
    float clouds = cloud_field(uv) * cloud_density;

    // Fade near zenith
    float zenith_fade = smoothstep(0.0, 0.4, 1.0 - altitude);
    clouds *= zenith_fade;

    vec3 final_cloud_color = cloud_color * (1.0 - cloud_darkness);
    sky_col = mix(sky_col, final_cloud_color, clouds * cloud_opacity);

    COLOR = sky_col * exposure;
}
