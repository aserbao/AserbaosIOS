//
//  ASGLKitViewController.m
//  AserbaosIOS
//
//  Created by aserbao on 2021/1/14.
//

#import "ASGLKitViewController.h"

#define TTF_STRINGIZE(x) #x
#define TTF_STRINGIZE2(x) TTF_STRINGIZE(x)
#define TTF_SHADER_STRING(text) @ TTF_STRINGIZE2(text)
static NSString *const CAMREA_RESIZE_VERTEX = TTF_SHADER_STRING
(
 attribute vec4 position;
 varying  vec4 vColor;
 attribute vec4 aColor;
 void main()
 {
    gl_Position = position;
    vColor = aColor;
 }
);
//const char * shaderStringUTF8 = [CAMREA_RESIZE_VERTEX UTF8String];
static NSString *const CAMREA_RESIZE_FRAGMENT = TTF_SHADER_STRING
(
 precision mediump float;
 varying vec4 vColor;
 void main()
 {
     gl_FragColor = vColor;
 }
);

static const GLfloat glkitVertices[] = {
     1.0f, -1.0f, 0.0f,1.0f,0.0f,0.0f,1.0f,
     1.0f,  1.0f, 0.0f,0.0f,1.0f,0.0f,1.0f,
    -1.0f,  1.0f, 0.0f,0.0f,0.0f,1.0f,1.0f,
    -1.0f, -1.0f, 0.0f,0.0f,0.0f,0.0f,1.0f,
};

static const GLint glubyte = {
    1,2,3,
    2,3,0,
};

@interface ASGLKitViewController (){
    EAGLContext *context;
}
@property(nonatomic) GLuint _program;
@property(nonatomic) GLuint _position;
@property(nonatomic) GLuint _color;
@end

@implementation ASGLKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupG];
}


-(void) setupG{
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    //2.获取GLKView & 设置context
    GLKView *view =(GLKView *) self.view;
    view.context = context;
    
    
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0.3, 0.4, 0.5, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glUseProgram(self._program);
    glEnableVertexAttribArray(self._position);
    
    //detect
    
    //draw
}


- (BOOL)initWithVertex:(NSString *)vertex fragment:(NSString *)fragment {
    GLuint vertexShader = [self compileShader:vertex withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:fragment withType:GL_FRAGMENT_SHADER];
    self._program = glCreateProgram();
    glAttachShader(self._program, vertexShader);
    glAttachShader(self._program, fragmentShader);
    glLinkProgram(self._program);
    if (vertexShader) {
        glDeleteShader(vertexShader);
    }
    if (fragmentShader) {
        glDeleteShader(fragmentShader);
    }
    
    glUseProgram(self._program);
    glBindAttribLocation(self._program,self._position, "position");
    glBindAttribLocation(self._program,self._color, "aColor");

    return YES;
};

- (GLuint)compileShader:(NSString *)shaderString withType:(GLenum)shaderType {
    GLuint shaderHandle = glCreateShader(shaderType);
    const char * shaderStringUTF8 = [shaderString UTF8String];
    
    int shaderStringLength = (int) [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    glCompileShader(shaderHandle);
    GLint success;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &success);
    
    if (success == GL_FALSE){
        NSLog(@"BErenderHelper compiler shader error: %s", shaderStringUTF8);
        return 0;
    }
    return shaderHandle;
}

@end
