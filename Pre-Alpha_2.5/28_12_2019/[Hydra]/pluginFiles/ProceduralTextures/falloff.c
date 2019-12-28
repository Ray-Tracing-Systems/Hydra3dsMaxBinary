float4 mix(float3 x, float3 y, float a)
{
  return to_float4(y + a*(x - y), 0);
}

float4 main(const SurfaceInfo* sHit, float3 color1, float3 color2)
{
  const float3 pos  = readAttr(sHit,"LocalPos");
  const float3 norm = readAttr(sHit,"Normal");
  
  const float3 rayDir = hr_viewVectorHack;
  float cosAlpha      = fabs(dot(norm,rayDir));
  
  return mix(color1, color2, cosAlpha);
}