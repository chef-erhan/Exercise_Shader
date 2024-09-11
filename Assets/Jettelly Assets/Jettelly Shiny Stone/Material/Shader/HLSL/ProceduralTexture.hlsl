//#region TEXTURE
float4 unity_triangle (float2 uv, float size, float sides)
{
    float distance = 0;
    float4 render = 0;
    float2 st = 0;
    int vertex = sides;

    st = uv;
    st = st * 2 - 1;
    float angle = atan2(st.x, st.y) + 3.14159265359;
    float radius = 6.28318530718 / float(vertex);
    distance = cos(floor(0.5 + angle / radius) * radius - angle) * length(st);

    render = (1.0 - smoothstep(size, size + 0.01, distance));
    return render;
}
//#endregion
//#region RANDOM VALUE
float unity_noise_randomValue (float2 uv)
{
    return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
}
//#endregion
//#region DINAMIC TEXTURE
void Texture_float(float3 worldPos, float2 uv_render, float sides, out float4 Out)
{
    uv_render *= 32;      
    uv_render += _WorldSpaceCameraPos.xy; // movement  

    float2 uvFrac = float2(frac(uv_render.x), frac(uv_render.y));
    float2 id = floor(uv_render);
    float4 col = 0;
    float y = 0;
    float x = 0; 

    for(y = -1; y <= 1; y++)
    {
        for(x = -1; x <= 1; x++)
        {
            float2 offset = float2(x, y);
            float noise = unity_noise_randomValue(id + offset);    
            float size = frac(noise * 123.32);                       
            float render = unity_triangle(uvFrac - offset - float2(noise, frac(noise * 23.12)), size * 1.5, sides);                          

            render *= (sin(noise * ((_WorldSpaceCameraPos.x - (worldPos.x * 5) + noise) * 20)));
            render *= (cos(noise * ((_WorldSpaceCameraPos.y - (worldPos.y * 5) + noise) * 20)));          
            render *= (sin(noise * ((_WorldSpaceCameraPos.z - (worldPos.z * 5) + noise) * 20)));

            col += render;
        }
    }  

    Out = col;
}
//#endregion
