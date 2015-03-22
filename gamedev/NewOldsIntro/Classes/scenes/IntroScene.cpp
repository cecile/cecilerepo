#include "IntroScene.h"

Scene* Intro::scene()
{
    Scene* scene = NULL;

    do
    {
        // 'scene' is an autorelease object
        scene = Scene::create();
        UTILS_BREAK_IF( ! scene );

        // 'layer' is an autorelease object
        Intro* layer = Intro::create();
        UTILS_BREAK_IF( ! layer );

        // add layer as a child to scene
        scene->addChild( layer );
    }
    while ( 0 );

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool Intro::init()
{
    bool ret = false;

    do
    {
        //////////////////////////////////////////////////////////////////////////
        // Call parent
        //////////////////////////////////////////////////////////////////////////

        UTILS_BREAK_IF( ! parent::init() );


        //AudioHelper::get()->preLoadEffect( "intro/sounds/intro.wav" );

        //////////////////////////////////////////////////////////////////////////
        // Background & Title
        //////////////////////////////////////////////////////////////////////////

        // Get window size and place the label upper.
        Size size = Director::getInstance()->getWinSize();


        // add the background
        auto background = LayerGradient::create( Color4B( 20, 20, 20, 255 ), Color4B( 10, 10, 10, 255 ) );
        UTILS_BREAK_IF( ! background );

        // Add the sprite to Menu layer as a child layer.
        this->addChild( background, 0 );


        // load the sprites
        SpriteFrameCache::getInstance()->addSpriteFramesWithFile( "intro/sprites/intro.plist" );

        // create logo sprite
        Sprite* tittle = Sprite::createWithSpriteFrameName( "newolds.png" );
        UTILS_BREAK_IF( ! tittle );

        tittle->setPosition( Vec2( size.width / 2, size.height / 2 ) );

        // Add the sprite to Menu layer as a child layer.
        this->addChild( tittle, 0 );

        /*
        // background color layer will cover our logo until its fade out
        LayerColor* colorLayer = LayerColor::create( Color4B( 0, 0, 0, 255 ) );
        UTILS_BREAK_IF( ! colorLayer );

        this->addChild( colorLayer, 0 );

        // create the effects for fading out the background color layer
        DelayTime* delayEnter = DelayTime::create( 0.2f );
        UTILS_BREAK_IF( ! delayEnter );

        FadeOutTRTiles* tiles = FadeOutTRTiles::create( 1.0f, Size( 20, 20 ) );
        UTILS_BREAK_IF( ! tiles );

        Hide* hide = Hide::create();
        UTILS_BREAK_IF( ! hide );

        DelayTime* delayExit = DelayTime::create( 3.0f );
        UTILS_BREAK_IF( ! delayExit );

        // function call in the event chain to go to the menu
        //CallFunc* funcFade = CallFunc::create( this, callfunc_selector( Intro::fadeOut ) );
        //UTILS_BREAK_IF( ! funcFade );

        // function call in the event chain to go to the menu
        //CallFunc* funcSound = CCCallFunc::create( this, callfunc_selector( Intro::playSound ) );
        //UTILS_BREAK_IF( ! funcSound );

        // create the sequence of effects and go to the menu
        //Sequence* sequence = Sequence::create( delayEnter, tiles, hide, funcSound, delayExit, funcFade, NULL );
        Sequence* sequence = Sequence::create( delayEnter, tiles, hide, delayExit, NULL );

        UTILS_BREAK_IF( ! sequence );

        // run effects
        colorLayer->runAction( sequence );*/


        ret = true;
    }
    while ( 0 );

    return ret;
}

void Intro::playSound()
{
    //AudioHelper::get()->playEffect( "intro/sounds/intro.wav" );
}

void Intro::fadeOut()
{
    do
    {

        FadeOutBLTiles* fade = FadeOutBLTiles::create( 0.2f, Size( 20, 20 ) );
        UTILS_BREAK_IF( ! fade );

        Hide* hide = Hide::create();
        UTILS_BREAK_IF( ! hide );

        DelayTime* delayExit = DelayTime::create( 1.0f );
        UTILS_BREAK_IF( ! delayExit );

        // function call in the event chain to go to the menu
        CCCallFunc* func = CallFunc::create( this, callfunc_selector( Intro::goToMenu ) );
        UTILS_BREAK_IF( ! func );

        // create the sequence of effects and go to the menu
        Sequence* sequence = Sequence::create( fade, hide, delayExit, func, NULL );
        UTILS_BREAK_IF( ! sequence );

        // run effects
        this->runAction( sequence );
    }
    while ( 0 );
}

void Intro::goToMenu()
{
    do
    {
        // create a scene. it's an autorelease object
        //CCScene* scene = Loading::menu();
        //UTILS_BREAK_IF( ! scene );

        //CCDirector::sharedDirector()->replaceScene( scene );
    }
    while ( 0 );

}


Intro::~Intro()
{

    //AudioHelper::get()->unloadEffect( "intro/sounds/intro.wav" );

    SpriteFrameCache::getInstance()->removeSpriteFramesFromFile( "intro/sprites/intro.plist" );

    Director::getInstance()->purgeCachedData();

}