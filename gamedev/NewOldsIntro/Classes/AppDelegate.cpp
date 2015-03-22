#include "AppDelegate.h"
#include "scenes/IntroScene.h"

USING_NS_CC;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
}

//if you want a different context,just modify the value of glContextAttrs
//it will takes effect on all platforms
void AppDelegate::initGLContextAttrs()
{
    //set OpenGL context attributions,now can only set six attributions:
    //red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};

    GLView::setGLContextAttrs(glContextAttrs);
}

bool AppDelegate::applicationDidFinishLaunching()
{
    
    bool ret = false;
    
    do
    {
        // initialize director
        auto director = Director::getInstance();
        auto glview = director->getOpenGLView();
        if(!glview) {
            glview = GLViewImpl::create("New Olds Intro");
            director->setOpenGLView(glview);
        }
               
        // Set the design resolution
        glview->setDesignResolutionSize( AppDelegate::designWith, AppDelegate::designHeight, ResolutionPolicy::EXACT_FIT );
        
        // show fps flag, by default false
        bool showFPS = false;
        
        // in debug show dps by default
#ifdef DEBUG
        showFPS = true;
#endif
        
        // force to texture to no have premultiplied alpha in all platform
        Image::setPVRImagesHavePremultipliedAlpha( false );
        
        // user defaults
        auto defaults = UserDefault::getInstance();
        
        // get store value for show fps
        showFPS = defaults->getBoolForKey( "showFps", showFPS );
        
        // store the value
        defaults->setBoolForKey( "showFps", showFPS );
        defaults->flush();
        
        
        // turn on display FPS
        director->setDisplayStats( showFPS );
        
        // set FPS. the default value is 1.0/60 if you don't call this
        director->setAnimationInterval( 1.0 / 60 );
        
        // create a scene. it's an autorelease object
        auto scene = Intro::scene();
        UTILS_BREAK_IF( ! scene );
        
        // run
        director->runWithScene( scene );
        
        ret = true;
    }
    while ( 0 );
    
    return ret;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();

    // if you use SimpleAudioEngine, it must be pause
    // SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();

    // if you use SimpleAudioEngine, it must resume here
    // SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}
