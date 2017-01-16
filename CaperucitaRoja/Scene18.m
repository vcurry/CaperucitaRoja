//
//  Scene18.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 15/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene18.h"
#import "Scene00.h"
#import "AppDelegate.h"

@import AVFoundation;

@implementation Scene18{
    AVAudioPlayer *backgroundMusicPlayer;
    AVAudioPlayer *narratorPlayer;
    AVAudioPlayer *tirin;
    int language;
    SKSpriteNode *endLabel;
    AppDelegate *delegado;
}

-(id)initWithSize:(CGSize)size
{
    if(self=[super initWithSize:size]){
        delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        language = delegado.language;
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithImageNamed:@"backgroundScene22"];
        background.anchorPoint=CGPointZero;
        background.position=CGPointZero;
        background.zPosition=-1;
        
        [self addChild:background];
        
        [self playBackgroundMusic:@"campo.mp3"];
        [backgroundMusicPlayer play];
        
        SKSpriteNode *lumberjack=[SKSpriteNode spriteNodeWithImageNamed:@"lumberjack"];
        lumberjack.anchorPoint=CGPointZero;
        lumberjack.position=CGPointMake(250, 130);
        lumberjack.size=CGSizeMake(lumberjack.size.width*0.8, lumberjack.size.height*0.8);
        lumberjack.xScale=-1;
        [self addChild:lumberjack];
        
        SKSpriteNode *lrrh=[SKSpriteNode spriteNodeWithImageNamed:@"lrrhMouth0"];
        lrrh.anchorPoint=CGPointZero;
        lrrh.position=CGPointMake(240, 130);
        lrrh.zPosition=0;
        [lrrh setScale:0.8];
        [self addChild:lrrh];
        
        SKSpriteNode * gM=[SKSpriteNode spriteNodeWithImageNamed:@"gM"];
        gM.anchorPoint=CGPointZero;
        gM.position=CGPointMake(380, 130);
        gM.zPosition=2;
        [gM setScale:0.8];
        [self addChild:gM];
        
        SKSpriteNode * mother=[SKSpriteNode spriteNodeWithImageNamed:@"mother0"];
        mother.anchorPoint=CGPointZero;
        mother.position=CGPointMake(540, 130);
        mother.zPosition=2;
        [mother setScale:0.8];
        [self addChild:mother];
        
        NSString *labelName;
        if (delegado.language==0) {
            labelName = [NSString stringWithFormat:NSLocalizedString(@"labelEnd", nil)];
        } else if (delegado.language==1){
            labelName = @"labelEnd";
        }else if (delegado.language==2){
            labelName = @"labelFin";
        }else if (delegado.language==3){
            labelName = @"labelEnde";
        }
        
        NSLog(@"labelName: %@", labelName);
        endLabel = [SKSpriteNode spriteNodeWithImageNamed:labelName];
        endLabel.zPosition = 4;
        endLabel.position = CGPointMake(820, 130);
        endLabel.alpha = 0.0;
        [self addChild:endLabel];
        
        
        [NSTimer scheduledTimerWithTimeInterval:1.25 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:13.5 target:self selector:@selector(tirin) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:17 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];
    }
    
    return self;
}

-(void)tirin{
    [self playTirinPlayer:@"tirin.mp3"];
    [tirin play];
}

-(void)playTirinPlayer:(NSString *)filename{
    NSError *error;
    NSURL *musicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    tirin=[[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];
    tirin.volume=0.5;
    [tirin prepareToPlay];
    [endLabel runAction:[SKAction fadeInWithDuration:0.5]];
}



-(void)playBackgroundMusic:(NSString *) filename{
    NSError *error;
    NSURL *backgroundMusicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    backgroundMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops=-1;
    backgroundMusicPlayer.volume=1.0;
    [backgroundMusicPlayer prepareToPlay];
}


-(void)startNarrator{
    NSString *audioFileName;
    if (delegado.language==0) {
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"18_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"18_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"18_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"18_1_de.mp3";
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


-(void)nextScene{
    if (delegado.num < 3) {
        delegado.num += 1;
    }else{
        delegado.num = 1;
    }
    delegado.language = 0;
    Scene00 *scene=[[Scene00 alloc] initWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *sceneTransition =[SKTransition fadeWithColor:[UIColor darkGrayColor] duration:1];
    [self.view presentScene:scene transition:sceneTransition];
    
}

@end
