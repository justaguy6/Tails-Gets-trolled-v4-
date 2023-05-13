#pragma header

#define RADIUS 64.0

float SCurve (float x) {
	
    
		x = x * 2.0 - 1.0;
		return -x * abs(x) * 0.5 + x + 0.5;
		

}

vec4 BlurH (sampler2D source, vec2 size, vec2 uv) {
    vec3 A = vec3(0.0); 
    vec3 C = vec3(0.0); 

    float width = 1.0 / size.x;

    float divisor = 0.0; 
    float weight = 0.0;
    
    float radiusMultiplier = 1.0 / RADIUS;

    for (float x = -RADIUS; x <= RADIUS; x++)
    {
        A = flixel_texture2D(source, uv + vec2(x * width, 0.0)).rgb;
        
        weight = SCurve(1.0 - (abs(x) * radiusMultiplier)); 
    
        C += pow(A * weight, vec3(2.2)); 
        
        divisor += weight; 
    }

    vec3 final = pow(C / divisor, vec3(1.0/2.2));

    return vec4(final, 1.0);
}



void main()
{    
    vec2 uv = openfl_TextureCoordv; 
    
    // Apply horizontal blur to buffer C
	gl_FragColor = BlurH(bitmap, openfl_TextureSize.xy, uv);
}