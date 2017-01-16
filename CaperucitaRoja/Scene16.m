//
//  Scene16.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 15/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene16.h"
#import "Scene17.h"
#import "AppDelegate.h"
@import AVFoundation;

@implementation Scene16{
    SKSpriteNode *wolf;
    SKSpriteNode *lumberjack;
    SKSpriteNode *lrrh;
    SKSpriteNode *gM;
    AVAudioPlayer *backgroundMusicPlayer;
    AVAudioPlayer *narratorPlayer;
    int language;
    AppDelegate *delegado;
}

-(id)initWithSize:(CGSize)size{
    if (self=[super initWithSize:size]) {
        delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        language = delegado.language;
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithImageNamed:@"backgroundScene14"];
        background.position=CGPointZero;
        background.anchorPoint=CGPointZero;
        background.zPosition=-1;
        [self addChild:background];
        
        SKSpriteNode *doorO=[SKSpriteNode spriteNodeWithImageNamed:@"doorOpen"];
        doorO.anchorPoint=CGPointZero;
        doorO.zPosition=0;
        doorO.position=CGPointMake(60, 205);
        [self addChild:doorO];
        
        wolf=[SKSpriteNode spriteNodeWithImageNamed:@"wolfSleep"];
        wolf.anchorPoint=CGPointZero;
        wolf.position=CGPointMake(347, 78);
        wolf.zPosition=1;
        [self addChild:wolf];
        
        lumberjack=[SKSpriteNode spriteNodeWithImageNamed:@"lumberjack"];
        lumberjack.anchorPoint=CGPointZero;
        lumberjack.position=CGPointMake(330, 150);
        lumberjack.zPosition=1;
        lumberjack.size=CGSizeMake(lumberjack.size.width*0.8, lumberjack.size.height*0.8);
        lumberjack.xScale=-1;
        [self addChild:lumberjack];
        
        lrrh=[SKSpriteNode spriteNodeWithImageNamed:@"lrrhMouth0"];
        lrrh.anchorPoint=CGPointZero;
        lrrh.position=CGPointMake(360, 150);
        lrrh.alpha=0.0;
        lrrh.zPosition=0;
        [lrrh setScale:0.8];
        [self addChild:lrrh];
        
        gM=[SKSpriteNode spriteNodeWithImageNamed:@"gM"];
        gM.anchorPoint=CGPointZero;
        gM.position=CGPointMake(780, 150);
        gM.alpha=0.0;
        gM.zPosition=2;
        [gM setScale:0.8];
        [self addChild:gM];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startBackgroundMusic) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:11 target:self selector:@selector(showLrrh) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:19 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];
    }
    return self;
}

-(void)showLrrh{
    SKAction *show=[SKAction fadeInWithDuration:1];
    [lrrh runAction:show];
    SKAction *wait=[SKAction waitForDuration:1];
    SKAction *showGM=[SKAction fadeInWithDuration:1];
    SKAction *showC=[SKAction sequence:@[wait,showGM]];
    [gM runAction:showC];
    
}

-(void)startNarrator{
    NSString *audioFileName;
    if (delegado.language==0) {
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"16_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"16_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"16_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"16_1_de.mp3";
    }
    [self playNarrator:audioFileName];
    [narratorPlayer play];
}

-(void)playNarrator:(NSString *) filename{
    NSError *error;
    NSURL *narratorURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    narratorPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:narratorURL error:&error];
  //  narratorPlayer.volume=8.5;
    [narratorPlayer prepareToPlay];
}

-(void)startBackgroundMusic{
    [self playBackgroundMusic:@"mainMusicBox.mp3"];
    [backgroundMusicPlayer play];
}

-(void)playBackgroundMusic:(NSString *) filename{
    NSError *error;
    NSURL *backgroundMusicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    backgroundMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops=-1;
    backgroundMusicPlayer.volume=0.05;
    [backgroundMusicPlayer prepareToPlay];
}

-(void)nextScene{
    Scene17 *scene=[[Scene17 alloc] initWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *sceneTransition =[SKTransition fadeWithColor:[UIColor darkGrayColor] duration:1.5];
    [self.view presentScene:scene transition:sceneTransition];
}

@end
