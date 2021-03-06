// sNZVF[_[ΜόΝ
struct PS_INPUT
{
	float4 ViewPosition   : TEXCOORD0;
};

// sNZVF[_[ΜoΝ
struct PS_OUTPUT
{
	float4 Color0         : COLOR0 ;
};


// C++ €Εέθ·ιθΜθ`
float3 cfDOF_Area  : register( c0 ) ;	// νΚE[xΜΝΝξρ   x:νΚE[xJnΚu   y:νΚE[xIΉΚu   z:νΚE[xΜΝΝΜt


// mainΦ
PS_OUTPUT main( PS_INPUT PSInput )
{
	PS_OUTPUT PSOutput ;
	float z_param ;

	// νΚE[xΜΝΝΰπ 0.0f ` 1.0f ΙΟ·
	if( PSInput.ViewPosition.z < cfDOF_Area.x )
	{
		PSOutput.Color0.r = 0.0f ;
	}
	else
	if( PSInput.ViewPosition.z > cfDOF_Area.y )
	{
		PSOutput.Color0.r = 1.0f ;
	}
	else
	{
		PSOutput.Color0.r = ( PSInput.ViewPosition.z - cfDOF_Area.x ) * cfDOF_Area.z ;
	}

	PSOutput.Color0.g = 0.0f ;
	PSOutput.Color0.b = 0.0f ;
	PSOutput.Color0.a = 0.0f ;
   
	return PSOutput ;    
}
