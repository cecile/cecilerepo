//
//  MenuScene.m
//  Pipes
//
//  Created by Juan Antonio Medina Iglesias on 02/05/2015.
//  Copyright (c) 2015 NewOlds. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"

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
@implementation MenuScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    /*SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
     
     myLabel.text = @"Hello, World!";
     myLabel.fontSize = 65;
     myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
     CGRectGetMidY(self.frame));
     [self addChild:myLabel];*/
    
    
    // Create the sprite for play button and the selected texture
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"play"];
    SKTexture* overTexture = [SKTexture textureWithImageNamed:@"play2"];

    sprite.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    // Add the sprite to the scene
    [self addChild:sprite];
    
    // Store the button and the selected texture
    [self setPlayButton:sprite];
    [self setPlaySelected:overTexture];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    // Get touch location
    CGPoint location = [[touches anyObject] locationInNode:self];
    
    // Get node tocuhed
    NSArray *nodes = [self nodesAtPoint:location];
    
    // If we have touch any node
    if([nodes count]){
        
        
        // Find wich node we touch
        for (SKNode* node in nodes) {
            
            // If we touch play button
            if( [node isEqual: self.playButton]){

                // Change the texture to selected
                [self.playButton setTexture:self.playSelected];
                
                // Play the button click sound
                [self runAction:[SKAction playSoundFileNamed:@"Button.caf" waitForCompletion:NO]];
                
                // Create and configure the scene.
                GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
                scene.scaleMode = SKSceneScaleModeAspectFill;
                
                // Create a cross fade transition
                SKTransition *crossFade = [SKTransition crossFadeWithDuration:1.0];
                
                // Present the scene.
                [self.view presentScene:scene transition: crossFade];
                
            }
        }
        
    }
    
}

@end
