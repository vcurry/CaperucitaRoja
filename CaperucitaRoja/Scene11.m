//
//  Scene11.m Wolf eats Granny and lies in bed ->> LRRH ends maze
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 8/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene11.h"
#import "Scene07.h"

#import "AppDelegate.h"
@import AVFoundation;

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


@implementation Scene11{
    SKSpriteNode *wolf;
    SKSpriteNode *wolfA;
    SKSpriteNode *gM;
    SKSpriteNode *gMO;
    SKSpriteNode *doorO;
    SKSpriteNode *bed;
    SKSpriteNode *emptyBed;
    SKSpriteNode *doorC;
    AVAudioPlayer *backgroundMusicPlayer;
    AVAudioPlayer *narratorPlayer;
    int contador;
    int language;
    AppDelegate *delegado;
}

-(id)initWithSize:(CGSize)size{
    if(self=[super initWithSize:size]){
        delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        language = delegado.language;
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithImageNamed:@"backgroundScene14"];
        background.zPosition=-1;
        background.anchorPoint=CGPointZero;
        background.position=CGPointZero;
        
        [self addChild:background];
        
        doorC=[SKSpriteNode spriteNodeWithImageNamed:@"doorClosed"];
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
        
        gM=[SKSpriteNode spriteNodeWithImageNamed:@"gMBed0"];
        gM.zPosition=3;
        gM.anchorPoint=CGPointZero;
        gM.position=CGPointMake(347, 78);
        [self addChild:gM];
        
        gMO=[SKSpriteNode spriteNodeWithImageNamed:@"gMBedMouthO"];
        gMO.zPosition=4;
        gMO.anchorPoint=CGPointZero;
        gMO.position=CGPointMake(347, 78);
        gMO.hidden=YES;
        [self addChild:gMO];
        
        bed=[SKSpriteNode spriteNodeWithImageNamed:@"wolfBed0"];
        bed.anchorPoint=CGPointZero;
        bed.position=CGPointMake(347, 78);
        bed.zPosition = 4;
        bed.alpha = 0.0;
        [self addChild:bed];
        
        emptyBed=[SKSpriteNode spriteNodeWithImageNamed:@"emptyBed"];
        emptyBed.anchorPoint=CGPointZero;
        emptyBed.position=CGPointMake(347, 78);
        emptyBed.zPosition = 2;
  //      emptyBed.alpha = 0.0;
        [self addChild:emptyBed];
        
        wolf=[SKSpriteNode spriteNodeWithImageNamed:@"wolf0"];
        wolf.zPosition=2;
        wolf.anchorPoint=CGPointZero;
        wolf.position=CGPointMake(420, 90);
        wolf.xScale=-1;
        wolf.alpha=0.0;
        [self addChild:wolf];
        
        wolfA=[SKSpriteNode spriteNodeWithImageNamed:@"wolfAttacks"];
        wolfA.zPosition=2;
        wolfA.anchorPoint=CGPointZero;
        wolfA.position=CGPointMake(540, 145);
        wolfA.hidden=YES;
        wolfA.xScale=-1;
        [self addChild:wolfA];
        
        contador=1;
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startBackgroundMusic) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(setUpGMTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(setUpWolfTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:11 target:self selector:@selector(setUpGMTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:16 target:self selector:@selector(setUpWolfAnimation) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:19 target:self selector:@selector(showGMO) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:16 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:23 target:self selector:@selector(startEndNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:32 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];
    }
    
    return self;
}

-(void)setUpGMTalks{
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:2];
    int k;
    if (contador==1) {
        k=2;
    }else if (contador==4){
        k=6;
    }
    
    for (int i=0; i<=k; i++) {
        NSString *textureName;
        if (i%2==0) {
            textureName=[NSString stringWithFormat:@"gMBed0"];
        }else{
            textureName=[NSString stringWithFormat:@"gMBed1"];
        }
        SKTexture *texture=[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    NSString *audioFileName;
    if (delegado.language==0) {
        NSString *cont = [NSString stringWithFormat:@"11_%d_en.mp3",contador];
        audioFileName = [NSString stringWithFormat:NSLocalizedString(cont, nil)];
    } else if (delegado.language==1){
        audioFileName = [NSString stringWithFormat:@"11_%d_en.mp3",contador];
    }else if (delegado.language==2){
        audioFileName = [NSString stringWithFormat:@"11_%d_es.mp3",contador];
    }else if (delegado.language==3){
        audioFileName = [NSString stringWithFormat:@"11_%d_de.mp3",contador];
    }
    NSLog(@"%@", audioFileName);
    SKAction *talkSound=[SKAction playSoundFileNamed:audioFileName waitForCompletion:NO];
    SKAction *hablar=[SKAction animateWithTextures:textures timePerFrame:0.10];
    SKAction *wait=[SKAction waitForDuration:1];
    SKAction *gMAnimation=[SKAction sequence:@[wait,talkSound,hablar,hablar,hablar]];
    [gM runAction:gMAnimation];
    contador+=1;
}

-(void)setUpWolfTalks{
    NSString *audioFileName;
    if (delegado.language==0) {
        NSString *cont = [NSString stringWithFormat:@"11_%d_en.mp3",contador];
        audioFileName = [NSString stringWithFormat:NSLocalizedString(cont, nil)];
    } else if (delegado.language==1){
        audioFileName = [NSString stringWithFormat:@"11_%d_en.mp3",contador];
    }else if (delegado.language==2){
        audioFileName = [NSString stringWithFormat:@"11_%d_es.mp3",contador];
    }else if (delegado.language==3){
        audioFileName = [NSString stringWithFormat:@"11_%d_de.mp3",contador];
    }

    SKAction *talkSound=[SKAction playSoundFileNamed:audioFileName waitForCompletion:NO];
    
    SKAction *wait=[SKAction waitForDuration:.5];
    SKAction *wolfAnimation=[SKAction sequence:@[wait,talkSound]];
    [self runAction:wolfAnimation];
    contador+=1;
}

-(void)startNarrator{
    NSString *audioFileName;
    if (delegado.language==0) {
        NSString *cont = [NSString stringWithFormat:@"11_%d_en.mp3",contador];
        audioFileName = [NSString stringWithFormat:NSLocalizedString(cont, nil)];
    } else if (delegado.language==1){
        audioFileName = [NSString stringWithFormat:@"11_%d_en.mp3",contador];
    }else if (delegado.language==2){
        audioFileName = [NSString stringWithFormat:@"11_%d_es.mp3",contador];
    }else if (delegado.language==3){
        audioFileName = [NSString stringWithFormat:@"11_%d_de.mp3",contador];
    }
    NSLog(@"%@", audioFileName);

    contador+=1;
    [self playNarrator:audioFileName];
    [narratorPlayer play];
}

-(void)startEndNarrator{
    [self showWolfInBed];
    NSString *audioFileName;
    if (delegado.language==0) {
        NSString *cont = [NSString stringWithFormat:@"11_%d_en.mp3",contador];
        audioFileName = [NSString stringWithFormat:NSLocalizedString(cont, nil)];
    } else if (delegado.language==1){
        audioFileName = [NSString stringWithFormat:@"11_%d_en.mp3",contador];
    }else if (delegado.language==2){
        audioFileName = [NSString stringWithFormat:@"11_%d_es.mp3",contador];
    }else if (delegado.language==3){
        audioFileName = [NSString stringWithFormat:@"11_%d_de.mp3",contador];
    }
    NSLog(@"%@", audioFileName);
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
    doorO.hidden=NO;
    SKAction *shows=[SKAction fadeInWithDuration:1];
    SKAction *wait=[SKAction waitForDuration:2];
    
    SKAction *completeA=[SKAction sequence:@[wait,shows]];
    [wolf runAction:completeA];
    [NSTimer scheduledTimerWithTimeInterval:4.5 target:self selector:@selector(wolfAttack) userInfo:nil repeats:NO];
}

-(void)wolfAttack{
    wolf.hidden=YES;
    wolfA.hidden=NO;
}

-(void)showGMO{
    gMO.hidden=NO;
}

-(void)showWolfInBed{
    gM.hidden = YES;
    doorO.hidden = YES;
    doorC.hidden = NO;
    SKAction *GMFadesOut = [SKAction fadeOutWithDuration:1];
    [gMO runAction:GMFadesOut];
    
    SKAction *wait = [SKAction waitForDuration:0.7];
    SKAction *wolfFadesIn = [SKAction fadeOutWithDuration:1];
    SKAction *wolfFadesIn1 = [SKAction fadeInWithDuration:1];
    [wolfA runAction: [SKAction sequence:@[wait,wait,wolfFadesIn]]];
    [bed runAction: [SKAction sequence:@[wait,wait,wait,wait,wolfFadesIn1]]];
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

-(void)nextScene{
    NSString *fileName = [NSString stringWithFormat:@"Laberinto%d",delegado.num];
    Scene07 *scene = [Scene07 unarchiveFromFile:fileName];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene];
}

@end
