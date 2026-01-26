shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

/* Color Grade */
uniform vec4 color_grade : source_color = vec4(1.0);

/* Optics */
uniform float chromatic_aberration = 0.6;
uniform float distortion = 0.15;

/* Film */
uniform float film_grain = 0.15;
uniform float film_compression = 0.4;
uniform float film_breath = 0.25;
uniform float gate_weave = 0.15;

/* Effects */
uniform float scanline = 0.2;
uniform float vignette = 0.4;
uniform float bloom = 0.3;
uniform float halation = 0.35;

/* Anti-aliasing */
uniform float edge_aa = 0.0;

/* Debug */
uniform bool false_color = false;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

vec3 film_curve(vec3 c) {
    c = max(c, vec3(0.0));
    return pow(c, vec3(1.0 / (1.0 + film_compression)));
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 centered = uv * 2.0 - 1.0;

    /* Gate Weave */
    vec2 weave = vec2(
        sin(TIME * 1.3),
        cos(TIME * 1.7)
    ) * gate_weave * 0.002;
    uv += weave;

    /* Distortion */
    float r2 = dot(centered, centered);
    vec2 distorted_uv = uv + centered * r2 * distortion * 0.1;

    /* Chromatic Aberration */
    vec2 ca = vec2(
        sin(TIME + uv.y * 20.0),
        cos(TIME + uv.x * 20.0)
    ) * chromatic_aberration * 0.002;

    float r = texture(SCREEN_TEXTURE, distorted_uv + ca).r;
    float g = texture(SCREEN_TEXTURE, distorted_uv).g;
    float b = texture(SCREEN_TEXTURE, distorted_uv - ca).b;

    vec3 color = vec3(r, g, b);

    /* Halation */
    float luma = dot(color, vec3(0.299, 0.587, 0.114));
    vec3 halo = color * smoothstep(0.6, 1.0, luma) * halation;
    color += halo * vec3(1.0, 0.4, 0.2);

    /* Bloom */
    vec3 bloom_col = max(color - 0.7, vec3(0.0));
    color += bloom_col * bloom;

    /* Film Breath */
    float breath = sin(TIME * 0.8) * film_breath * 0.05;
    color += breath;

    /* Film Compression */
    color = film_curve(color);

    /* Color Grade */
    color = mix(color, color * color_grade.rgb, color_grade.a);

    /* Edge AA */
    if (edge_aa > 0.0) {
        vec2 px = SCREEN_PIXEL_SIZE;

        vec3 cx = texture(SCREEN_TEXTURE, uv + vec2(px.x, 0.0)).rgb;
        vec3 cy = texture(SCREEN_TEXTURE, uv + vec2(0.0, px.y)).rgb;

        float edge =
            length(color - cx) +
            length(color - cy);

        float aa = smoothstep(0.05, 0.2, edge) * edge_aa;

        vec3 blurred = (color + cx + cy) / 3.0;
        color = mix(color, blurred, aa);
    }

    /* Scanline */
    float scan = sin(uv.y / SCREEN_PIXEL_SIZE.y * 0.5) * 0.5 + 0.5;
    color -= scan * scanline * 0.1;

    /* Film Grain */
    float noise = rand(uv * TIME);
    color += (noise - 0.5) * film_grain * 0.2;

    /* Vignette */
    float vig = smoothstep(1.1, 0.3, length(centered));
    color *= mix(1.0, vig, vignette);

    /* False Color */
    if (false_color) {
        color = vec3(luma, 1.0 - luma, 0.0);
    }

    COLOR = vec4(color, 1.0);
}
