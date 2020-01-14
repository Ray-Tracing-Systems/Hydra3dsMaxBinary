float4 main(const SurfaceInfo* sHit, float3 colorHit, sampler2D texHit, float3 colorMiss, sampler2D texMiss, float falloffPower, int numNode)
{
  const float2 texCoord = readAttr(sHit, "TexCoord0");
  const float node0     = readAttr(sHit, "AO0");
  const float node1     = readAttr(sHit, "AO1");
 
  float ao              = (numNode == 0) ? node0 : node1;
 
  const float4 col1     = to_float4(colorHit, 1.0f)*texture2D(texHit, texCoord, 0);
  const float4 col2     = to_float4(colorMiss,1.0f)*texture2D(texMiss, texCoord, 0);
  
  ao = pow(ao, falloffPower);
  
  return col1 + ao*(col2 - col1);
}
