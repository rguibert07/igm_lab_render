shader_type spatial;

uniform vec4 albedo_color : source_color = vec4(0.8, 0.5, 0.2, 1.0);
uniform float shininess   : hint_range(1.0, 256.0) = 32.0;
uniform float ambient_str : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    ALBEDO    = albedo_color.rgb;
    METALLIC  = 0.0;
    ROUGHNESS = 1.0;
    SPECULAR  = 0.0;
    EMISSION  = albedo_color.rgb * ambient_str;
}

void light() {
    float NdotL = max(dot(NORMAL, LIGHT), 0.0);
    DIFFUSE_LIGHT += NdotL * ATTENUATION * LIGHT_COLOR * ALBEDO;

    vec3 reflect_dir = reflect(-LIGHT, NORMAL);
    float spec = pow(max(dot(VIEW, reflect_dir), 0.0), shininess);
    SPECULAR_LIGHT += spec * ATTENUATION * LIGHT_COLOR;
}