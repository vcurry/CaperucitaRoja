//
//  Scene09.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 7/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene09.h"
#import "AppDelegate.h"
#import "Scene00_1.h"
#import "Scene10.h"
@import AVFoundation;

@implementation Scene09{
    SKSpriteNode *ok_button;
    AVAudioPlayer *correctMusicPlayer;
    AppDelegate *delegado;
}

-(id)initWithSize:(CGSize)size
{
    if (self=[super initWithSize:size]) {
        delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundScene03"];
        background.anchorPoint=CGPointZero;
        background.position=CGPointZero;
        background.zPosition=-1;
        [self addChild:background];
        
        SKSpriteNode *bouquet=[SKSpriteNode spriteNodeWithImageNamed:@"bouquet"];
        bouquet.anchorPoint=CGPointZero;
        bouquet.position=CGPointZero;
        [self addChild:bouquet];
        
        ok_button=[SKSpriteNode spriteNodeWithImageNamed:@"buttonFinished"];
        ok_button.position = CGPointMake(890, 150);
        ok_button.zPosition=1;
        
        [self addChild:ok_button];
        
        [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(playTirin) userInfo:nil repeats:NO];
        
    }
    
    return self;
}

-(void)playCorrectMusicPlayer:(NSString *)filename{
    NSError *error;
    NSURL *tirinMusicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    correctMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:tirinMusicURL error:&error];
    correctMusicPlayer.volume=1;
    [correctMusicPlayer prepareToPlay];
}

-(void)playTirin{
    [self playCorrectMusicPlayer:@"tirin.mp3"];
    [correctMusicPlayer play];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in touches){
        CGPoint location=[touch locationInNode:self];
        if ([ok_button containsPoint:location]) {
            if (delegado.modoJuego==0) {
                Scene10 *scene=[[Scene10 alloc] initWithSize:self.size];
                SKTransition *sceneTransition=[SKTransition fadeWithColor:[UIColor darkGrayColor] duration:0];
                scene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:scene transition:sceneTransition];
            }else if (delegado.modoJuego==1){
                Scene00_1 *scene=[[Scene00_1 alloc] initWithSize:self.size];
                scene.scaleMode=SKSceneScaleModeAspectFill;
                [self.view presentScene:scene];
            }
            
        }
    }
}

@end

