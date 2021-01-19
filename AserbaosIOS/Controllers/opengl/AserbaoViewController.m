//
//  ASRippleViewController.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/15.
//

#import "AserbaoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_COORDS,
    NUM_ATTRIBUTES
};

static const GLfloat squareVertices[] = {
    -1.0f, -1.0f,
     -1.0f, 1.0f,
     1.0f,  -1.0f,
     1.0f,  1.0f,
};

static const GLfloat textureVertices[] = {
    1.0f, 0.0f,
    0.0f, 0.0f,
    1.0f, 1.0f,
    0.0f, 1.0f,

  
//    0.0f, 0.0f,
//    0.0f, 1.0f,
    
    
};

@interface AserbaoViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic,weak) GLKView *glView;
@property(nonatomic) CGFloat retinaScaleFactor; //to keep it ok with iPhone 5/6

//shader & uniforms
@property(nonatomic) GLuint shaderProgram;

@property(nonatomic) GLint tex1Uniform;
@property(nonatomic) GLint saturationUniform;

//opnegl
@property (strong, nonatomic) EAGLContext *context;

//camera textures and device
@property (nonatomic) CVOpenGLESTextureRef lumaTexture;
@property (nonatomic) CVOpenGLESTextureCacheRef videoTextureCache;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) NSString *sessionPreset;

@end

@implementation AserbaoViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    //create Opengl view we are processing view update on demand so pause the view
    self.glView = (GLKView *)self.view;
    self.glView.context = self.context;
    self.glView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    self.preferredFramesPerSecond = 60;
    
    self.glView.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.retinaScaleFactor = [[UIScreen mainScreen] nativeScale];
    
    self.view.contentScaleFactor = self.retinaScaleFactor;
    
    _sessionPreset = AVCaptureSessionPreset1280x720;
    
    [self setupGL];
    [self setupAVCapture];
    [self.session startRunning];
}

- (void)stopCameraCapture
{
    [self.session stopRunning];
}

- (void)setSaturation:(CGFloat)saturation
{
    //clamp to 0.0-1.0
    _saturation = fmaxf(0.0, fminf(1.0, saturation));
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    [self loadShaders];
    
    self.paused = NO;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glViewport(0, 0,
               rect.size.width*self.retinaScaleFactor,
               rect.size.height*self.retinaScaleFactor);
    
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    if(_lumaTexture != 0){
        
        glUseProgram(_shaderProgram);
        
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(CVOpenGLESTextureGetTarget(_lumaTexture), CVOpenGLESTextureGetName(_lumaTexture));
        glUniform1i(_tex1Uniform,0);
        
        glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
        glEnableVertexAttribArray(ATTRIB_VERTEX);
        glVertexAttribPointer(ATTRIB_COORDS, 2, GL_FLOAT, 0, 0, textureVertices);
        glEnableVertexAttribArray(ATTRIB_COORDS);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
}

#pragma mark -AVVideo and texture cache

- (void)cleanUpTextures
{
    if (_lumaTexture)
    {
        CFRelease(_lumaTexture);
        _lumaTexture = NULL;
    }

    // Periodic texture cache flush every frame
    CVOpenGLESTextureCacheFlush(_videoTextureCache, 0);
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    CVReturn err;
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    unsigned char* address = (unsigned char*)CVPixelBufferGetBaseAddress(pixelBuffer);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    if (!_videoTextureCache)
    {
        NSLog(@"No video texture cache");
        return;
    }
    
    [self cleanUpTextures];
    
    // CVOpenGLESTextureCacheCreateTextureFromImage will create GLES texture
    // optimally from CVImageBufferRef.
    

    glActiveTexture(GL_TEXTURE0);
    err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                       _videoTextureCache,
                                                       pixelBuffer,
                                                       NULL,
                                                       GL_TEXTURE_2D,
                                                       GL_RGBA,
                                                       (int)width,
                                                       (int)height,
                                                       GL_RGBA,
                                                       GL_UNSIGNED_BYTE,
                                                       0,
                                                       &_lumaTexture);
    if (err)
    {
        NSLog(@"Error at CVOpenGLESTextureCacheCreateTextureFromImage %d", err);
    }
    
    glBindTexture(CVOpenGLESTextureGetTarget(_lumaTexture), CVOpenGLESTextureGetName(_lumaTexture));
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glBindTexture(GL_TEXTURE_2D, 0);
    
    
}

- (void)setupAVCapture
{
    
#if !TARGET_IPHONE_SIMULATOR
    //-- Create CVOpenGLESTextureCacheRef for optimal CVImageBufferRef to GLES texture conversion.
    CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, _context, NULL, &_videoTextureCache);
    if (err)
    {
        NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
        return;
    }
    
    //-- Setup Capture Session.
    self.session = [[AVCaptureSession alloc] init];
    [self.session beginConfiguration];
    
    //-- Set preset session size.
    [self.session setSessionPreset:_sessionPreset];
    
    //-- Creata a video device and input from that Device.  Add the input to the capture session.
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDevice * videoDevice = nil;
    
    for (AVCaptureDevice *device in devices) {
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionFront) {
                videoDevice = device;
                break;
            }
        }
    }
    
    if(videoDevice == nil)
        assert(0);
    
    //-- Add the device to the session.
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if(error)
        assert(0);
    
    [self.session addInput:input];
    
    //-- Create the output for the capture session.
    AVCaptureVideoDataOutput * dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [dataOutput setAlwaysDiscardsLateVideoFrames:YES]; // Probably want to set this to NO when recording
    [dataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                                             forKey:(id)kCVPixelBufferPixelFormatTypeKey]]; // Necessary for manual preview
    
    // Set dispatch to be on the main thread so OpenGL can do things with the data
    [dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:dataOutput];
    [self.session commitConfiguration];
    
#endif
}

- (void)tearDownAVCapture
{
    [self cleanUpTextures];
    
    if (_videoTextureCache) {
        
        CFRelease(_videoTextureCache);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)dealloc
{
    [self.session stopRunning];
    [self tearDownAVCapture];
    
    [EAGLContext setCurrentContext:self.context];
    if (_shaderProgram) {
        glDeleteProgram(_shaderProgram);
        _shaderProgram = 0;
    }
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _shaderProgram = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Bytedance" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Bytedance" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_shaderProgram, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_shaderProgram, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_shaderProgram, ATTRIB_VERTEX, "position");
    glBindAttribLocation(_shaderProgram, ATTRIB_COORDS, "texCoord");
    
    // Link program.
    if (![self linkProgram:_shaderProgram]) {
        NSLog(@"Failed to link program: %d", _shaderProgram);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_shaderProgram) {
            glDeleteProgram(_shaderProgram);
            _shaderProgram = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    _tex1Uniform = glGetUniformLocation(_shaderProgram, "inputImageTexture");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_shaderProgram, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_shaderProgram, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader
                 type:(GLenum)type
                 file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil] UTF8String];
    if (!source) {
        
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    
    if (status == 0) {
        
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    
    if (status == 0) {
        
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    
    if (logLength > 0) {
        
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    
    if (status == 0) {
        
        return NO;
    }
    
    return YES;
}

@end
