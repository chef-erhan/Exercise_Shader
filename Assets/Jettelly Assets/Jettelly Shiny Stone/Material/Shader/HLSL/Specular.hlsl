//#region LIGHT
half3 unity_lighting(half3 lightColor, half3 lightDir, half3 normal, half3 viewDir, half3 specular, half smoothness)
{
	float3 halfVec = SafeNormalize(float3(lightDir)+float3(viewDir));
	half NdotH = saturate(dot(normal, halfVec));
	half modifier = pow(NdotH, smoothness);
	half3 specularReflection = specular * modifier;

	return lightColor * specularReflection;
}
//#endregion
//#region SPECULAR
void Specular_float(half3 specular, half smoothness, half3 direction, half3 color, half3 worldNormal, half3 worldView, out half3 render)
{
#ifdef SHADERGRAPH_PREVIEW
	specular = half3(1, 1, 1);
	render = 0;
#else
	smoothness = exp2(10 * smoothness + 1);
	worldNormal = normalize(worldNormal);
	worldView = SafeNormalize(worldView);
	
	render = unity_lighting(color, direction, worldNormal, worldView, specular, smoothness);
#endif
}
//#endregion