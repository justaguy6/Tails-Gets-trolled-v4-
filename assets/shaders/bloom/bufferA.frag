#pragma header

uniform sampler2D base;
uniform float luminanceLimit;
uniform float LIGHT_TRESHOLD; // 0.289

uniform float LUMINANCE_MULT; // 1.0


void main( )
{
	vec2 uv = openfl_TextureCoordv;
 
	gl_FragColor = flixel_texture2D ( base, uv);
    
	
    vec4 fraglight = gl_FragColor;
    
    
    //calculate luminance
    float luminance = (fraglight.r*0.2126+fraglight.g*0.7152+fraglight.b*0.0722)/3.0;
    

    //get brighter pixels
    if ( luminance > LIGHT_TRESHOLD) {
           
        gl_FragColor.rgb = vec3( fraglight.r*LUMINANCE_MULT,fraglight.g*LUMINANCE_MULT,fraglight.b*LUMINANCE_MULT);
           
    }else{
        gl_FragColor.rgb = vec3(0.0);
    }
}