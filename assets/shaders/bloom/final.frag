#pragma header
uniform sampler2D base;
void main()
{
    vec2 uv = openfl_TextureCoordv;
    gl_FragColor = flixel_texture2D(bitmap, uv) + flixel_texture2D(base, uv);
}