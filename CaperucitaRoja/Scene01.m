//
//  Scene01.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 23/9/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "AppDelegate.h"
#import "Scene01.h"
#import "Scene02.h"
#import "Scene03.h"

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

#define IDIOM   UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@implementation Scene01{
    AVAudioPlayer *backgroundMusicPlayer;
    AVAudioPlayer *narratorPlayer;
    SKSpriteNode *lrrh;
    SKSpriteNode *mother;
    SKSpriteNode *mouse;
    AppDelegate *delegado;
    int language;
    
    NSTimer *narrator;
}
-(id) initWithSize:(CGSize)size{
    if (self=[super initWithSize:size]) {
        delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background01"];
        background.position = CGPointZero;
        background.anchorPoint = CGPointZero;
        background.zPosition=-1;
        [self addChild:background];
        
        lrrh=[SKSpriteNode spriteNodeWithImageNamed:@"lrrh0"];
        lrrh.anchorPoint=CGPointZero;
        lrrh.position=CGPointMake(120, 100);
        [self addChild:lrrh];
        
        mother=[SKSpriteNode spriteNodeWithImageNamed:@"mother0"];
        mother.anchorPoint=CGPointZero;
        mother.position=CGPointMake(420, 100);
        [self addChild:mother];
        
        [self setUpBlinkAnimation:lrrh con:@"lrrh0" y:@"lrrh1" durante:4];
        [self setUpBlinkAnimation:mother con:@"mother0" y:@"motherEyes" durante:6];
        
        mouse=[SKSpriteNode spriteNodeWithImageNamed:@"mouse0"];
        mouse.position=CGPointMake(970, 230);
        [self addChild:mouse];
        [self setUpMouseAnimation];
        
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(startBackgroundMusic) userInfo:nil repeats:NO];
        
        narrator = [NSTimer scheduledTimerWithTimeInterval:1.25 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:23.5 target:self selector:@selector(setUpMotherAnimation) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:33.0 target:self selector:@selector(transition) userInfo:nil repeats:NO];


    }
    return self;
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches){
        [backgroundMusicPlayer stop];
        [narratorPlayer stop];
        [self removeAllActions];
        [self transition];
    }
}

-(void)setUpBlinkAnimation:(SKSpriteNode *)nodo con:(NSString*)imagen0 y:(NSString *)imagen1 durante:(CGFloat)duration{
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:2];
    
    SKTexture *texture0=[SKTexture textureWithImageNamed:imagen0];
    SKTexture *texture1=[SKTexture textureWithImageNamed:imagen1];
    [textures addObject:texture0];
    [textures addObject:texture1];
    [textures addObject:texture0];
    
    SKAction *blink =[SKAction animateWithTextures:textures timePerFrame:0.15];
    SKAction *wait=[SKAction waitForDuration:duration];
    
    SKAction *mainCharacterAnimation=[SKAction sequence:@[blink,wait,blink,wait]];
    [nodo runAction:[SKAction repeatActionForever:mainCharacterAnimation]];
}

-(void)setUpMouseAnimation{
    NSMutableArray *textures=[NSMutableArray array];
    NSMutableArray *textures2=[NSMutableArray array];
    for (int i=0; i<4; i++) {
        NSString *textureName=[NSString stringWithFormat:@"mouse%d",i];
        SKTexture *texture=[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    for (int i=3; i>=0; i--) {
        NSString *textureName=[NSString stringWithFormat:@"mouse%d",i];
        SKTexture *texture=[SKTexture textureWithImageNamed:textureName];
        [textures2 addObject:texture];
    }
    
    NSLog(@"textures Mouse: %lu", (unsigned long)textures.count);
    SKAction *wait=[SKAction waitForDuration:2.5];
    SKAction *movement=[SKAction animateWithTextures:textures timePerFrame:0.10];
    SKAction *moveBack=[SKAction animateWithTextures:textures2 timePerFrame:0.10];
    SKAction *mouseAnimation=[SKAction sequence:@[wait,movement,wait,moveBack,wait,movement,wait,wait,moveBack,wait,wait,movement]];
    [mouse runAction:mouseAnimation];
}


-(void)setUpMotherAnimation{
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:2];
    
    for (int i=0; i<=18; i++) {
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
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"01_2_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"01_2_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"01_2_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"01_2_de.mp3";
    }
    
    SKAction *talkSound=[SKAction playSoundFileNamed:audioFileName waitForCompletion:NO];
    
    SKAction *hablar=[SKAction animateWithTextures:textures timePerFrame:0.15];
    SKAction *wait=[SKAction waitForDuration:0.2];
    SKAction *motherAnimation=[SKAction sequence:@[wait,talkSound,hablar,hablar,hablar]];
    [mother runAction:motherAnimation];
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
    backgroundMusicPlayer.volume=.05;
    [backgroundMusicPlayer prepareToPlay];
}

-(void)startNarrator{
    NSString *audioFileName;
    if (delegado.language==0) {
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"01_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"01_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"01_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"01_1_de.mp3";
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

-(void)transition{
    Scene02 *scene;
    if (IDIOM ==IPAD) {
        NSLog(@"iPad");
        scene = [Scene02 unarchiveFromFile:@"Puzzle1-ipad"];
    }else{
        NSLog(@"iPhone");
        scene = [Scene02 unarchiveFromFile:@"Puzzle3-iphone"];
    }
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene];
}

@end
