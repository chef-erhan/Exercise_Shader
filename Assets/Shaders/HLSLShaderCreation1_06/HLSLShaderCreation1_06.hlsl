/// 06 Basic Programming: Functions - HLSL Shader Creation 1 - HLSL Shader Fundamentals
/// https://youtu.be/zxFtAMWLKtQ?t=182
/// @param StartColor 
/// @param ContrastAmount 
/// @param BrightnessAmount 
/// @param LastValue 
/// @return LastValue
///
///// Kontrast ayarlamak için basit bir formül
/// color = (color - 0.5) * _Contrast + 0.5;
///
///// Brightness ayarlamak için basit bir formül
/// color += _Brightness;
/// 
float3 BrightnessContrast_float(float3 StartColor, float ContrastAmount, float BrightnessAmount, out float3 LastValue)
{
    LastValue = StartColor - 0.5;
    LastValue *= ContrastAmount;
    LastValue += 0.5;
    LastValue += BrightnessAmount;
    return LastValue;
}