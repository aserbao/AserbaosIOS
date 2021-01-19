precision mediump float;
varying highp vec2 textureCoordinate;
uniform sampler2D inputImageTexture;
void main()
{
//    gl_FragColor = texture2D(inputImageTexture, textureCoordinate).bgra;
    gl_FragColor = texture2D(inputImageTexture, textureCoordinate);

//    gl_FragColor = vec4(1.0,0.0,0.0,1.0);
}
