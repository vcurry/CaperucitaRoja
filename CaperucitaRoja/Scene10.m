//
//  Scene10.m Wolf arrives at granny's
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 8/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene10.h"
#import "Scene11.h"
#import "AppDelegate.h"
@import AVFoundation;

@implementation Scene10{
    AVAudioPlayer *backgroundMusicPlayer;
    AVAudioPlayer *narratorPlayer;
    AVAudioPlayer *tocTocPlayer;
    int language;
    AppDelegate *delegado;
}

-(id)initWithSize:(CGSize)size
{
    if(self=[super initWithSize:size]){
        delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        language = delegado.language;
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithImageNamed:@"backgroundScene13"];
        background.anchorPoint=CGPointZero;
        background.position=CGPointZero;
        background.zPosition=-1;
        
        [self addChild:background];
        
        [self playBackgroundMusic:@"campo.mp3"];
        [backgroundMusicPlayer play];
        
        SKSpriteNode *wolf=[SKSpriteNode spriteNodeWithImageNamed:@"wolf0"];
        wolf.anchorPoint=CGPointZero;
        wolf.position=CGPointMake(690, 220);
        wolf.size=CGSizeMake(wolf.size.width*0.3, wolf.size.height*0.3);
        wolf.xScale=-1;
        [self addChild:wolf];
        
        [NSTimer scheduledTimerWithTimeInterval:1.25 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:9 target:self selector:@selector(startTocToc) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];
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
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"10_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"10_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"10_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"10_1_de.mp3";
    }
    [self playNarrator:audioFileName];
    [narratorPlayer play];
}

-(void)playNarrator:(NSString *) filename{
    NSError *error;
    NSURL *narratorURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    narratorPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:narratorURL error:&error];
   // narratorPlayer.volume=8.5;
    [narratorPlayer prepareToPlay];
}

-(void)startTocToc{
    [self playTocToc:@"Toc_Toc.mp3"];
    [tocTocPlayer play];
}

-(void)playTocToc:(NSString *) filename{
    NSError *error;
    NSURL *tocTocURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    tocTocPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:tocTocURL error:&error];
    tocTocPlayer.volume=1.2;
    [tocTocPlayer prepareToPlay];
}

-(void)nextScene{
    Scene11 *scene=[[Scene11 alloc] initWithSize:self.size];
    SKTransition *sceneTransition =[SKTransition fadeWithColor:[UIColor darkGrayColor] duration:1];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene transition:sceneTransition];
    
}
@end