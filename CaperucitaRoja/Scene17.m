//
//  Scene17.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 15/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene17.h"
#import "Scene18.h"
#import "AppDelegate.h"
@import AVFoundation;

@implementation Scene17{
    SKSpriteNode *wolf;
    AVAudioPlayer *backgroundMusicPlayer;
    AVAudioPlayer *narratorPlayer;
    SKSpriteNode *wolfF;
    int language;
    
    AppDelegate *delegado;
}

-(id)initWithSize:(CGSize)size{
    if (self=[super initWithSize:size]) {
        delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        language = delegado.language;
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithImageNamed:@"backgroundScene21"];
        background.position=CGPointZero;
        background.anchorPoint=CGPointZero;
        background.zPosition=-1;
        [self addChild:background];
        
        wolf=[SKSpriteNode spriteNodeWithImageNamed:@"wolf21"];
        wolf.anchorPoint=CGPointZero;
        wolf.position=CGPointMake(330, 165);
        wolf.zPosition=1;
        wolf.size=CGSizeMake(wolf.size.width*0.8, wolf.size.height*0.8);
        wolf.xScale=-1;
        [self addChild:wolf];
        
        wolfF=[SKSpriteNode spriteNodeWithImageNamed:@"wolfPondInside"];
        wolfF.anchorPoint=CGPointZero;
        wolfF.position=CGPointMake(352, 358);
        wolfF.zPosition=2;
        wolfF.size=CGSizeMake(wolfF.size.width*0.8, wolfF.size.height*0.8);
        wolfF.alpha=0.0;
        [self addChild:wolfF];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startBackgroundMusic) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:6.5 target:self selector:@selector(wolfFalls) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];
    }
    return self;
}

-(void)startNarrator{
    NSString *audioFileName;
    if (delegado.language==0) {
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"17_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"17_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"17_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"17_1_de.mp3";
    }
    [self playNarrator:audioFileName];
    [narratorPlayer play];
}

-(void)playNarrator:(NSString *) filename{
    NSError *error;
    NSURL *narratorURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    narratorPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:narratorURL error:&error];
 //   narratorPlayer.volume=8.5;
    [narratorPlayer prepareToPlay];
}

-(void)startBackgroundMusic{
    [self playBackgroundMusic:@"campo.mp3"];
    [backgroundMusicPlayer play];
}

-(void)wolfFalls{
    SKAction *fadeO=[SKAction fadeOutWithDuration:1];
    [wolf runAction:fadeO];
    
    SKAction *wait=[SKAction waitForDuration:1];
    SKAction *fadeI=[SKAction fadeInWithDuration:1];
    SKAction *seq=[SKAction sequence:@[wait,fadeI]];
    [wolfF runAction:seq];
}

-(void)playBackgroundMusic:(NSString *) filename{
    NSError *error;
    NSURL *backgroundMusicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    backgroundMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops=-1;
    backgroundMusicPlayer.volume=1.0;
    [backgroundMusicPlayer prepareToPlay];
}

-(void)nextScene{
    Scene18 *scene=[[Scene18 alloc] initWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *sceneTransition =[SKTransition fadeWithColor:[UIColor darkGrayColor] duration:1.5];
    [self.view presentScene:scene transition:sceneTransition];
}

@end
