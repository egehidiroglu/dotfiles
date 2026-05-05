// crt.glsl — evangelion-neon CRT shader.
// More aggressive than the v1: heavier scanlines, brighter aberration, magenta-cyan ghosting,
// stronger barrel curve. Tuned to scream cyberpunk without being unreadable.

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;

    // ── Barrel distortion (stronger curve) ───────────────────────────────
    vec2 cc = uv - 0.5;
    float dist = dot(cc, cc);
    uv = uv + cc * dist * 0.020;       // ↑ from 0.012 — more bulge

    // Hard black border outside the curve to sell the CRT illusion
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }

    // ── Chromatic aberration — louder, magenta/cyan split ────────────────
    float aberration = 0.0030;          // ↑ from 0.0015
    float r = texture(iChannel0, uv + vec2( aberration, 0.0)).r;
    float g = texture(iChannel0, uv).g;
    float b = texture(iChannel0, uv - vec2( aberration, 0.0)).b;
    vec3 color = vec3(r, g, b);

    // ── Scanlines — sharper, denser ──────────────────────────────────────
    float scanline = sin(uv.y * iResolution.y * 1.8) * 0.08;   // ↑ amplitude
    color -= scanline;

    // Vertical RGB phosphor mask (subtle column bands)
    float vbar = sin(uv.x * iResolution.x * 3.14) * 0.02;
    color -= vbar;

    // Horizontal flicker — slightly faster, more visible
    color *= 1.0 - 0.025 * sin(iTime * 6.0);

    // Slow horizontal "rolling" interference band
    float band = sin(uv.y * 6.28 + iTime * 0.5) * 0.5 + 0.5;
    color += band * 0.012 * vec3(1.0, 0.0, 1.0);   // magenta tint

    // ── Vignette (heavier corners) ───────────────────────────────────────
    float vignette = smoothstep(0.95, 0.20, dist * 2.4);
    color *= mix(0.65, 1.0, vignette);

    // ── Phosphor glow lift — pull dark tones toward magenta-cyan ─────────
    color = mix(color, color + vec3(0.012, 0.0, 0.020), 0.6);

    // Subtle bloom on bright pixels (cheap glow)
    float lum = dot(color, vec3(0.299, 0.587, 0.114));
    if (lum > 0.7) {
        color += (lum - 0.7) * vec3(0.4, 0.2, 0.6) * 0.3;
    }

    fragColor = vec4(color, 1.0);
}
