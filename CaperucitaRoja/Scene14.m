//
//  Scene14.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 15/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene14.h"
#import "Scene15.h"
#import "AppDelegate.h"
@import AVFoundation;

@implementation Scene14{
    SKSpriteNode *wolf;
    SKSpriteNode *lrrh;
    AVAudioPlayer *backgroundMusicPlayer;
    AVAudioPlayer *narratorPlayer;
    AVAudioPlayer *tocTocPlayer;
    
    SKSpriteNode *lrrhO;
    int contador;
    int language;
    AppDelegate * delegado;
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
        wolf.zPosition=2;
        [self addChild:wolf];
        
        SKSpriteNode *doorO=[SKSpriteNode spriteNodeWithImageNamed:@"doorOpen"];
        doorO.anchorPoint=CGPointZero;
        doorO.zPosition=1;
        doorO.position=CGPointMake(60, 205);
        [self addChild:doorO];
        
        
        lrrh=[SKSpriteNode spriteNodeWithImageNamed:@"lrrhMouth0"];
        lrrh.anchorPoint=CGPointZero;
        lrrh.position=CGPointMake(250, 150);
        lrrh.zPosition=0;
        [lrrh setScale:0.8];
        [self addChild:lrrh];
        
        lrrhO=[SKSpriteNode spriteNodeWithImageNamed:@"lrrhMouthO"];
        lrrhO.anchorPoint=CGPointZero;
        lrrhO.position=CGPointMake(250, 150);
        lrrhO.zPosition=1;
        [lrrhO setScale:0.8];
        lrrhO.hidden=YES;
        [self addChild:lrrhO];
        
        contador=1;
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startBackgroundMusic) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(setUpLrrhTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(setUpWolfTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(setUpLrrhTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(setUpWolfTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:17 target:self selector:@selector(setUpLrrhTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:21 target:self selector:@selector(setUpWolfTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:24 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:25.5 target:self selector:@selector(showLrrhO) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];
        
        
    }
    return self;
}

-(void)setUpLrrhTalks{
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:2];
    
    for (int i=0; i<=10; i++) {
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
        NSString *cont = [NSString stringWithFormat:@"14_%d_en.mp3",contador];
        audioFileName = [NSString stringWithFormat:NSLocalizedString(cont, nil)];
    } else if (delegado.language==1){
        audioFileName = [NSString stringWithFormat:@"14_%d_en.mp3",contador];
    }else if (delegado.language==2){
        audioFileName = [NSString stringWithFormat:@"14_%d_es.mp3",contador];
    }else if (delegado.language==3){
        audioFileName = [NSString stringWithFormat:@"14_%d_de.mp3",contador];
    }

    SKAction *talkSound=[SKAction playSoundFileNamed:audioFileName waitForCompletion:NO];
    SKAction *hablar=[SKAction animateWithTextures:textures timePerFrame:0.10];
    SKAction *wait=[SKAction waitForDuration:1];
    SKAction *lrrhAnimation=[SKAction sequence:@[wait,talkSound,hablar,hablar,hablar]];
    [lrrh runAction:lrrhAnimation];
    contador+=1;
}

-(void)setUpLrrhAnimation{
    SKAction *shows=[SKAction fadeInWithDuration:1];
    SKAction *wait=[SKAction waitForDuration:2];
    SKAction *lrrhAnimation=[SKAction sequence:@[shows,wait]];
    [lrrh runAction:lrrhAnimation];
}

-(void)showLrrhO{
    lrrhO.hidden=NO;
    wolf.hidden=YES;
    
    SKSpriteNode *wolfA=[SKSpriteNode spriteNodeWithImageNamed:@"wolfAttacks"];
    wolfA.zPosition=2;
    wolfA.anchorPoint=CGPointZero;
    wolfA.position=CGPointMake(300, 145);
    //   wolf.xScale=-1;
    [self addChild:wolfA];
    
    SKSpriteNode *bed=[SKSpriteNode spriteNodeWithImageNamed:@"emptyBed"];
    bed.anchorPoint=CGPointZero;
    bed.position=CGPointMake(347, 78);
    bed.zPosition=3;
    [self addChild:bed];
    
    SKSpriteNode *gown=[SKSpriteNode spriteNodeWithImageNamed:@"camison"];
    gown.anchorPoint=CGPointZero;
    gown.position=CGPointMake(820, 130);
    gown.zPosition=1;
    [self addChild:gown];
    
    
}

-(void)setUpWolfTalks{
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:2];
    int k;
    if (contador==3 || contador==5) {
        k=4;
    }else if (contador==7){
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
        NSString *cont = [NSString stringWithFormat:@"14_%d_en.mp3",contador];
        audioFileName = [NSString stringWithFormat:NSLocalizedString(cont, nil)];
    } else if (delegado.language==1){
        audioFileName = [NSString stringWithFormat:@"14_%d_en.mp3",contador];
    }else if (delegado.language==2){
        audioFileName = [NSString stringWithFormat:@"14_%d_es.mp3",contador];
    }else if (delegado.language==3){
        audioFileName = [NSString stringWithFormat:@"14_%d_de.mp3",contador];
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
        NSString *cont = [NSString stringWithFormat:@"14_%d_en.mp3",contador];
        audioFileName = [NSString stringWithFormat:NSLocalizedString(cont, nil)];
    } else if (delegado.language==1){
        audioFileName = [NSString stringWithFormat:@"14_%d_en.mp3",contador];
    }else if (delegado.language==2){
        audioFileName = [NSString stringWithFormat:@"14_%d_es.mp3",contador];
    }else if (delegado.language==3){
        audioFileName = [NSString stringWithFormat:@"14_%d_de.mp3",contador];
    }

    
    contador+=1;
    [self playNarrator:audioFileName];
    [narratorPlayer play];
}

-(void)playNarrator:(NSString *) filename{
    NSError *error;
    NSURL *narratorURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    narratorPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:narratorURL error:&error];
    //    narratorPlayer.numberOfLoops=-1;
  //  narratorPlayer.volume=8.5;
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
    backgroundMusicPlayer.volume=0.05;
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
    Scene15 *scene=[[Scene15 alloc] initWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *sceneTransition =[SKTransition fadeWithColor:[UIColor darkGrayColor] duration:1.5];
    [self.view presentScene:scene transition:sceneTransition];
}




@end
