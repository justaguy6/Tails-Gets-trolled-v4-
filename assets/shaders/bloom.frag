#pragma header

uniform float uAmount;
void main()
{
	// Normalized pixel coordinates (from 0 to 1)
	vec2 uv = openfl_TextureCoordv;
	
	float mixAmount = 0.8 * uAmount;
	float subAmount = 0.4 * uAmount;
	
	float highP = 0.;
	
	vec4 col = vec4(0.);
	
	float Directions = 24.0 ; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
	float Quality = 12.0; // BLUR QUALITY (Default 4.0 - More is better but slower)
	float Size = 36.0; // BLUR SIZE (Radius)
	
	float Pi = 6.28318530718; // Pi*2
	vec2 Radius = Size/openfl_TextureSize.xy;
	
	for( float d=0.0; d<Pi; d+=Pi/Directions)
	{
		for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
		{
			vec4 color = flixel_texture2D( bitmap, uv+vec2(cos(d),sin(d))*Radius*i);
			col += color;
			highP += 1.0;
		}
	}
	col *= vec4(1.0, 0.95, 0.95, 1.0);
	col = col / vec4(highP);

	col = col*vec4(mixAmount) + ((flixel_texture2D( bitmap, uv) - vec4(subAmount)));

	gl_FragColor = col;
}