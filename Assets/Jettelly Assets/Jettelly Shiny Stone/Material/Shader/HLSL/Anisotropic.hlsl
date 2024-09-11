void Anisotropic_float
(
    float nU, 
    float nV, 
    float3 tangentDir, 
    float3 normalDir, 
    float3 lightDir, 
    float3 viewDir, 
    float anisoFactor, 
    out float3 Out
)
{
    float pi = 3.141592;
    float3 halfwayVector = normalize(lightDir + viewDir);
    float3 NdotH = dot(normalDir, halfwayVector);
    float3 HdotT = dot(halfwayVector, tangentDir);
    float3 HdotB = dot(halfwayVector, cross(tangentDir, normalDir));
    float3 VdotH = dot(viewDir, halfwayVector); // here
    float3 NdotL = dot(normalDir, lightDir);
    float3 NdotV = dot(normalDir, viewDir);

    float power = nU * pow(HdotT, 2) + nV * pow(HdotB, 2);
    power /= 1.0 - pow(NdotH, 2);

    float spec = sqrt((nU + 1) * (nV + 1)) * pow(NdotH, power);
    spec /= 8.0 * pi * VdotH * max(NdotL, NdotV);
    
    Out = clamp(spec * anisoFactor, 0, 1);
}