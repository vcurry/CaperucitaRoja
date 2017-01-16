//
//  Scene04.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 30/9/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene04.h"
#import "Scene05.h"
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

@implementation Scene04{
    SKSpriteNode *lrrh;
    SKSpriteNode *madre;
    SKSpriteNode *smoke1;
    SKSpriteNode *smoke2;
    SKSpriteNode *smoke3;
    SKSpriteNode *smoke4;
    SKSpriteNode *smoke5;
    AVAudioPlayer *backgroundMusicPlayer;
    int language;
    
    AppDelegate *delegado;
}

-(id)initWithSize:(CGSize)size
{
    if(self=[super initWithSize:size]){
        delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        language = delegado.language;
        [self playBackgroundMusic:@"campo.mp3"];
        [backgroundMusicPlayer play];
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundScene04"];
        background.position=CGPointZero;
        background.anchorPoint=CGPointZero;
        background.zPosition=-1;
        [self addChild:background];
        
        lrrh=[SKSpriteNode spriteNodeWithImageNamed:@"lrrhMouth0"];
        lrrh.anchorPoint=CGPointZero;
        lrrh.zPosition=1;
        lrrh.size=CGSizeMake(lrrh.size.width/2, lrrh.size.height/2);
        lrrh.position=CGPointMake(840, 120);
        
        madre = [SKSpriteNode spriteNodeWithImageNamed:@"mother0"];
        [madre setScale:0.5];
        [madre setXScale:-0.5];
        madre.position = CGPointMake(370, 275);
        [self addChild:madre];
        
        [self addChild:lrrh];
        [self setUpSmoke1];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(setUpMotherAnimation) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:5.5 target:self selector:@selector(setUpLrrhTalks) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:9.5 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];
    }
    
    return self;
}

-(void)setUpMotherAnimation{
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:2];
    
    for (int i=0; i<=16; i++) {
        NSString *textureName;
        if (i%2==0) {
            textureName=[NSString stringWithFormat:@"mother0"];
        }else{
            textureName=[NSString stringWithFormat:@"mother1"];
        }
        SKTexture *texture=[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    
    NSString *audioFileName;
    if (delegado.language==0) {
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"04_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"04_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"04_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"04_1_de.mp3";
    }
    
    SKAction *talkSound=[SKAction playSoundFileNamed:audioFileName waitForCompletion:NO];
    SKAction *hablar=[SKAction animateWithTextures:textures timePerFrame:0.15];
    SKAction *wait=[SKAction waitForDuration:0.2];
    SKAction *motherAnimation=[SKAction sequence:@[wait,talkSound,hablar,hablar]];
    [madre runAction:motherAnimation];
}

-(void)setUpLrrhTalks{
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:2];
    
    for (int i=0; i<2; i++) {
        NSString *textureName=[NSString stringWithFormat:@"lrrhMouth%d",i];
        SKTexture *texture=[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    SKTexture *textureF=[SKTexture textureWithImageNamed:@"lrrhMouth0"];
    [textures addObject:textureF];
    NSLog(@"count %lu", (unsigned long)textures.count);
    
    NSString *audioFileName;
    if (delegado.language==0) {
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"04_2_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"04_2_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"04_2_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"04_2_de.mp3";
    }
    
    SKAction *talkSound=[SKAction playSoundFileNamed:audioFileName waitForCompletion:NO];
    SKAction *hablar=[SKAction animateWithTextures:textures timePerFrame:0.10];
    SKAction *wait=[SKAction waitForDuration:2];
    SKAction *lrrhAnimation=[SKAction sequence:@[wait,talkSound,hablar,hablar,hablar]];
    [lrrh runAction:lrrhAnimation];
    
    
}


-(void)playBackgroundMusic:(NSString *)filename{
    NSError *error;
    NSURL *backgroundMusicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    NSLog(@"Es %@", backgroundMusicURL);
    backgroundMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops=-1;
    backgroundMusicPlayer.volume=1.0;
    [backgroundMusicPlayer prepareToPlay];
}

-(void)setUpCharacterAnimation{
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:2];
    
    for (int i=0; i<=2; i++) {
        NSString *textureName=[NSString stringWithFormat:@"littleRedRidingHood%d", i];
        SKTexture *texture=[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    
    CGFloat duration=2;
    
    SKAction *blink =[SKAction animateWithTextures:textures timePerFrame:0.25];
    SKAction *wait=[SKAction waitForDuration:duration];
    
    SKAction *mainCharacterAnimation=[SKAction sequence:@[blink,wait,blink,blink,wait,blink,blink]];
    [lrrh runAction:[SKAction repeatActionForever:mainCharacterAnimation]];
    
}

-(void)setUpSmoke1{
    smoke1=[SKSpriteNode spriteNodeWithImageNamed:@"smoke01"];
    smoke1.position=CGPointMake(200, 575);
    smoke1.alpha=0.0;
    [self addChild:smoke1];
    
    smoke2=[SKSpriteNode spriteNodeWithImageNamed:@"smoke01"];
    smoke2.alpha=0.0;
    smoke2.position=CGPointMake(200, 580);
    [self addChild:smoke2];
    
    SKAction *wait=[SKAction waitForDuration:1];
    SKAction *wait5=[SKAction waitForDuration:5];
    SKAction *fadeIn=[SKAction fadeInWithDuration:0.1];
    
    SKAction *move=[SKAction moveByX:0 y:240 duration:8];
    SKAction *scale=[SKAction scaleTo:0 duration:8];
    SKAction *animation=[SKAction sequence:@[fadeIn,move]];
    SKAction *animation1=[SKAction sequence:@[wait,scale]];
    [smoke1 runAction:animation1];
    [smoke1 runAction:animation];
    
    SKAction *smoke2animation=[SKAction sequence:@[wait5,fadeIn,move]];
    SKAction *smoke2animation1=[SKAction sequence:@[wait5,wait,scale]];
    [smoke2 runAction:smoke2animation1];
    [smoke2 runAction:smoke2animation];
}

-(void)nextScene{
    NSString *fileName = [NSString stringWithFormat:@"Laberinto%d",delegado.num];
    Scene05 *scene = [Scene05 unarchiveFromFile:fileName];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene];
}

@end