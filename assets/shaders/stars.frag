// SHADER DONE BY ME NEBULA THE ZORUAR!!!
// scars n stars... kirbf beloved...

#pragma header
// MOVEMENT PROPERTIES

float speed = 3.0; 
float zoom = 0.025;
float scale = 1.0;
float spacing = 3.0;

// END MOVEMENT PROPERTIES

// (Maybe those should be uniform? ^)

// UNIFORMS

uniform float iTime;
uniform sampler2D star;

// END UNIFORMS

vec2 rotate(vec2 uv, float th) {
    return mat2(cos(th), sin(th), -sin(th), cos(th)) * uv;
}

float rnd(float x) {
    return fract(sin(dot(vec2(x + 48, 38 / (x + 2.5)), vec2(13, 78))) * (43758));
}



void main()
{
    vec2 uv = openfl_TextureCoordv;
    
    uv.x *= openfl_TextureSize.x/openfl_TextureSize.y; // adjust it from rectangle aspect ratio to square
    

    uv /= zoom; // scale it (though i guess its more like zoom)
    
    float x = (uv.x)+(iTime/(1.0 / (speed)));
    float y = (uv.y)-(iTime/(1 / (speed * 2.0)));

    uv = vec2(mod(x, spacing),mod(y, spacing)); // do the infinite looping thing
    uv -= 0.5; // offset it for the origin
    uv /= scale + (cos(fract(y))*0.2);
    uv = rotate(uv, iTime * speed); // rotate it
    uv += 0.5; // offset it back to the origin, so its rotating in the center

    // Output to screen
    gl_FragColor = flixel_texture2D(star, uv);
}