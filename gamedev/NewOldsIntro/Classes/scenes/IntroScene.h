#ifndef __INTRO_SCENE_H__
#define __INTRO_SCENE_H__

#include "../utils/utils.h"

class Intro : public Layer
{
    public:

        // parent
        typedef Layer parent;

        // Here's a difference. Method 'init' in cocos2d-x returns bool, instead of returning 'id' in cocos2d-iphone
        virtual bool init();

        // there's no 'id' in cpp, so we recommand to return the exactly class pointer
        static Scene* scene();

        // implement the "static node()" method manually
        CREATE_FUNC( Intro );

        // unload resources
        virtual ~Intro();

    private:

        // play sound
        void playSound();

        // fade out
        void fadeOut();

        // go to the menu
        void goToMenu();
};

#endif  // __INTRO_SCENE_H__