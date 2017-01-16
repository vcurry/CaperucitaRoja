//
//  Scene12.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 8/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene12.h"
#import "Scene13.h"
#import "AppDelegate.h"

@import AVFoundation;

@implementation Scene12{
    SKSpriteNode *wolf;
    SKSpriteNode *lrrh;
    AVAudioPlayer *backgroundMusicPlayer;
    AVAudioPlayer *narratorPlayer;
    AVAudioPlayer *tocTocPlayer;
    
    SKSpriteNode *doorO;
    
    int contador;
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
        
        wolf=[SKSpriteNode spriteNodeWithImageNamed:@"wolfBed0"];
        wolf.anchorPoint=CGPointZero;
        wolf.position=CGPointMake(347, 78);
        wolf.zPosition=1;
        [self addChild:wolf];
        
        SKSpriteNode *doorC=[SKSpriteNode spriteNodeWithImageNamed:@"doorClosed"];
        doorC.anchorPoint=CGPointZero;
        doorC.zPosition=0;
        doorC.position=CGPointMake(60, 205);
        [self addChild:doorC];
        
        doorO=[SKSpriteNode spriteNodeWithImageNamed:@"doorOpen"];
        doorO.anchorPoint=CGPointZero;
        doorO.zPosition=1;
        doorO.position=CGPointMake(60, 205);
        doorO.hidden=YES;
        [self addChild:doorO];
        
        
        lrrh=[SKSpriteNode spriteNodeWithImageNamed:@"lrrhMouth0"];
        lrrh.anchorPoint=CGPointZero;
        lrrh.position=CGPointMake(280, 150);
        lrrh.alpha=0.0;
        lrrh.zPosition=0;
        [lrrh setScale:0.8];
        [self addChild:lrrh];
        
        contador=1;
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startBackgroundMusic) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(startTocToc) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:6.5 target:self selector:@selector(setUpWolfTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:9 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(setUpLrrhTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:19 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:22 target:self selector:@selector(setUpWolfTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:26 target:self selector:@selector(setUpLrrhAnimation) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:26 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:32 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];
        
        
    }
    return self;
}

-(void)setUpLrrhTalks{
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:2];
    for (int i=0; i<=4; i++) {
        NSString *textureName;
        if (i%2==0) {
            textureName=[NSString stringWithFormat:@"lrrhMouth0"];
        }else{
            textureName=[NSString stringWithFormat:@"lrrhMouth1"];
        }
        SKTexture *texture=[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    
    
    NSString *audioFileName;
    if (delegado.language==0) {
        NSString *cont = [NSString stringWithFormat:@"12_%d_en.mp3",contador];
        audioFileName = [NSString stringWithFormat:NSLocalizedString(cont, nil)];
    } else if (delegado.language==1){
        audioFileName = [NSString stringWithFormat:@"12_%d_en.mp3",contador];
    }else if (delegado.language==2){
        audioFileName = [NSString stringWithFormat:@"12_%d_es.mp3",contador];
    }else if (delegado.language==3){
        audioFileName = [NSString stringWithFormat:@"12_%d_de.mp3",contador];
    }
    
    SKAction *talkSound=[SKAction playSoundFileNamed:audioFileName waitForCompletion:NO];
    SKAction *hablar=[SKAction animateWithTextures:textures timePerFrame:0.10];
    SKAction *wait=[SKAction waitForDuration:1];
    SKAction *lrrhAnimation=[SKAction sequence:@[wait,talkSound,hablar,hablar,hablar]];
    [lrrh runAction:lrrhAnimation];
    contador+=1;
}

-(void)setUpLrrhAnimation{
    doorO.hidden=NO;
    SKAction *shows=[SKAction fadeInWithDuration:1];
    SKAction *wait=[SKAction waitForDuration:2];
    SKAction *lrrhAnimation=[SKAction sequence:@[shows,wait]];
    [lrrh runAction:lrrhAnimation];
}

-(void)setUpWolfTalks{
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:2];
    int k;
    if (contador==2) {
        k=2;
    }else if (contador==6){
        k=6;
    }
    
    for (int i=0; i<=k; i++) {
        NSString *textureName;
        if (i%2==0) {
            textureName=[NSString stringWithFormat:@"wolfBed0"];
        }else{
            textureName=[NSString stringWithFormat:@"wolfBed1"];
        }
        SKTexture *texture=[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    
    NSString *audioFileName;
    if (delegado.language==0) {
        NSString *cont = [NSString stringWithFormat:@"12_%d_en.mp3",contador];
        audioFileName = [NSString stringWithFormat:NSLocalizedString(cont, nil)];
    } else if (delegado.language==1){
        audioFileName = [NSString stringWithFormat:@"12_%d_en.mp3",contador];
    }else if (delegado.language==2){
        audioFileName = [NSString stringWithFormat:@"12_%d_es.mp3",contador];
    }else if (delegado.language==3){
        audioFileName = [NSString stringWithFormat:@"12_%d_de.mp3",contador];
    }
    
    SKAction *talkSound=[SKAction playSoundFileNamed:audioFileName waitForCompletion:NO];
    SKAction *hablar=[SKAction animateWithTextures:textures timePerFrame:0.10];
    SKAction *wait=[SKAction waitForDuration:.5];
    SKAction *wolfAnimation=[SKAction sequence:@[wait,talkSound,hablar,hablar,hablar]];
    [wolf runAction:wolfAnimation];
    contador+=1;
}

-(void)startNarrator{
    NSString *audioFileName;
    if (delegado.language==0) {
        NSString *cont = [NSString stringWithFormat:@"12_%d_en.mp3",contador];
        audioFileName = [NSString stringWithFormat:NSLocalizedString(cont, nil)];
    } else if (delegado.language==1){
        audioFileName = [NSString stringWithFormat:@"12_%d_en.mp3",contador];
    }else if (delegado.language==2){
        audioFileName = [NSString stringWithFormat:@"12_%d_es.mp3",contador];
    }else if (delegado.language==3){
        audioFileName = [NSString stringWithFormat:@"12_%d_de.mp3",contador];
    }
    
    contador+=1;
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



-(void)setUpWolfAnimation{
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:10];
    for (int i=0; i<=10; i++) {
        NSString *textureName=[NSString stringWithFormat:@"wolfAttack_%d",i];
        SKTexture *texture=[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    
    SKAction *shows=[SKAction fadeInWithDuration:1];
    SKAction *wait=[SKAction waitForDuration:2];
    SKAction *animation=[SKAction animateWithTextures:textures timePerFrame:0.1f];
    SKAction *completeA=[SKAction sequence:@[shows,wait,animation]];
    [wolf runAction:completeA];
}

-(void)startBackgroundMusic{
    [self playBackgroundMusic:@"suspenseMusicBox.mp3"];
    [backgroundMusicPlayer play];
}

-(void)playBackgroundMusic:(NSString *) filename{
    NSError *error;
    NSURL *backgroundMusicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    backgroundMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops=-1;
    backgroundMusicPlayer.volume=0.1;
    [backgroundMusicPlayer prepareToPlay];
}

-(void)startTocToc{
    [self playTocToc:@"Toc_Toc.mp3"];
    [tocTocPlayer play];
}

-(void)playTocToc:(NSString *) filename{
    NSError *error;
    NSURL *tocTocURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    tocTocPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:tocTocURL error:&error];
    tocTocPlayer.volume=.4;
    [tocTocPlayer prepareToPlay];
}

-(void)nextScene{
    Scene13 *scene=[[Scene13 alloc] initWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *sceneTransition =[SKTransition fadeWithColor:[UIColor darkGrayColor] duration:1.5];
    [self.view presentScene:scene transition:sceneTransition];
}


@end
