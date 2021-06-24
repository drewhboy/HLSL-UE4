//Inputs in UE4 = texture object, texCoord
float4 luminance = float4(0.21, 0.71, 0.07, 1);
float2 dim;
Tex.GetDimensions(dim.x, dim.y);
float3 diffuse = Texture2DSample(Tex, TexSampler, UV);

float2 s[8] = {
                float2(-1., -1.), float2(0., -1.),
                float2(1., -1.), float2(-1., 0.),
                float2(1., 0.), float2(-1., 1.),
                float2(0., 1.), float2(1., 1.)
};

float sm[8];

struct Functions
{
    float SobelFilter()
    {
        for (int i=0; i<8; i++) {
            sm[i] = dot(Texture2DSample(Tex, TexSampler, UV + float2(s[i][0] / dim.x, s[i][1] / dim.y)), luminance);
        }
        float sobel_h = sm[0] + (2 * sm[1]) + sm[2] - sm[5] - (2 * sm[6]) - sm[7];
        float sobel_v = sm[0] + (2 * sm[3]) + sm[5] - sm[2] - (2 * sm[4]) - sm[6];
        return sqrt(pow(sobel_h, 2.0) + pow(sobel_v, 2.0));
    }
};

//Compares vs. threshold.
Functions f;
float4 result;
if ( f.SobelFilter() > 0.5) 
{
    result = float4(0,0,0,1);
}
else 
{
    result = float4(1,1,1,1);
}
return result;