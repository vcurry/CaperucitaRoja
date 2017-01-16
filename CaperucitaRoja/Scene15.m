//
//  Scene15.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 15/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene15.h"
#import "Scene16.h"
#import "AppDelegate.h"
@import AVFoundation;

@implementation Scene15{
    AVAudioPlayer *backgroundMusicPlayer;
    AVAudioPlayer *narratorPlayer;
    
    int language;
    AppDelegate *delegado;
}

-(id)initWithSize:(CGSize)size
{
    if(self=[super initWithSize:size]){
        delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        language = delegado.language;
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithImageNamed:@"backgroundScene19"];
        background.anchorPoint=CGPointZero;
        background.position=CGPointZero;
        background.zPosition=-1;
        
        [self addChild:background];
        
        [self playBackgroundMusic:@"campo.mp3"];
        [backgroundMusicPlayer play];
        
        SKSpriteNode *lumberjack=[SKSpriteNode spriteNodeWithImageNamed:@"lumberjack"];
        lumberjack.anchorPoint=CGPointZero;
        lumberjack.position=CGPointMake(490, 185);
        lumberjack.size=CGSizeMake(lumberjack.size.width*0.4, lumberjack.size.height*0.4);
        lumberjack.xScale=-1;
        [self addChild:lumberjack];
        
        [NSTimer scheduledTimerWithTimeInterval:1.25 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:17 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];
    }
    
    return self;
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
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"15_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"15_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"15_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"15_1_de.mp3";
    }
    [self playNarrator:audioFileName];
    [narratorPlayer play];

}

-(void)playNarrator:(NSString *) filename{
    NSError *error;
    NSURL *narratorURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    narratorPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:narratorURL error:&error];
//    narratorPlayer.volume=8.5;
    [narratorPlayer prepareToPlay];
}


-(void)nextScene{
    Scene16 *scene=[[Scene16 alloc] initWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *sceneTransition =[SKTransition fadeWithColor:[UIColor darkGrayColor] duration:1];
    [self.view presentScene:scene transition:sceneTransition];
    
}

@end