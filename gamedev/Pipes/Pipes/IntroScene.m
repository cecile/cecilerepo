//
//  IntroScene.m
//  Pipes
//
//  Created by Juan Antonio Medina Iglesias on 01/05/2015.
//  Copyright (c) 2015 NewOlds. All rights reserved.
//

#import "IntroScene.h"
#import "MenuScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation IntroScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    /*SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    [self addChild:myLabel];*/
    
    
    // Create the sprite for NewOlds logo
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"newolds"];
    sprite.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
 
    // Calculate scale
    float scale = self.size.width / 1920.0;
    
    sprite.xScale = scale;
    sprite.yScale = scale;
    
    // Add the sprite to the scene
    [self addChild:sprite];
    
    // Add the evil laugh
    [self runAction:[SKAction playSoundFileNamed:@"Evil_Laugh_Male_6.caf" waitForCompletion:NO]];
    
    // Init vars for transition logic
    [self setStartTime:0.0];
    [self setInTransition:false];
    
}

-(void) goToMenu{

    // If we are in transition skip
    if (self.inTransition){
        return;
    }
    
    // Set that we are in transition
    [self setInTransition:true];
    
    // Create and configure the scene.
    MenuScene *scene = [MenuScene unarchiveFromFile:@"MenuScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Create a cross fade transition
    SKTransition *crossFade = [SKTransition crossFadeWithDuration:1.0];
    
    // Present the scene.
    [self.view presentScene:scene transition: crossFade];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    // Transition to menu
    [self goToMenu];
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    // If we dont have and start time get it
    if(self.startTime==0){
        [self setStartTime:currentTime];
    }
    
    // Calculate elapsed tgime
    float eplapsed = currentTime - self.startTime;
    
    // After 5 seconds if we are not in transition go to the menu
    if( (eplapsed>5.0) && (!self.inTransition) ){
       [self goToMenu];
    }
    
}

@end
