//
//  Scene06.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 1/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene06.h"
#import "Scene08.h"
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


@implementation Scene06{
    SKSpriteNode *wolf;
    SKSpriteNode *lrrh;
    AVAudioPlayer *narratorPlayer;
    AVAudioPlayer *backgroundMusicPlayer;
    int contador;
    int language;
    AppDelegate *delegado;
}

-(id)initWithSize:(CGSize)size
{
    if(self=[super initWithSize:size]){
        delegado=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        language = delegado.language;
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithImageNamed:@"backgroundScene07"];
        background.anchorPoint=CGPointZero;
        background.position=CGPointZero;
        background.zPosition=-1;
        [self addChild:background];
        
        SKSpriteNode *background1=[SKSpriteNode spriteNodeWithImageNamed:@"backgroundScene07tree"];
        background1.anchorPoint=CGPointZero;
        background1.position=CGPointZero;
        background1.zPosition=2;
        [self addChild:background1];
        
        [self playBackgroundMusic:@"campo.mp3"];
        [backgroundMusicPlayer play];
        
        wolf=[SKSpriteNode spriteNodeWithImageNamed:@"wolf0"];
        wolf.anchorPoint=CGPointZero;
        wolf.position=CGPointMake(625, 100);
        [self addChild:wolf];
        
        lrrh=[SKSpriteNode spriteNodeWithImageNamed:@"lrrhMouth0"];
        lrrh.anchorPoint=CGPointZero;
        lrrh.position=CGPointMake(200, 100);
        [self addChild:lrrh];
        
        contador=2;
        
        [NSTimer scheduledTimerWithTimeInterval:1.25 target:self selector:@selector(startNarrator) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:11.0 target:self selector:@selector(setUpWolfTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:13.0 target:self selector:@selector(setUpLrrhTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(setUpWolfTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:17.0 target:self selector:@selector(setUpLrrhTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(setUpWolfTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:22.0 target:self selector:@selector(setUpLrrhTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:28.0 target:self selector:@selector(setUpWolfTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:33.0 target:self selector:@selector(setUpLrrhTalks) userInfo:nil repeats:NO];
        
        [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];
    }
    
    return self;
}

-(void)setUpLrrhTalks{
    NSString *audioFileName;
    NSLog(@"contador %d", contador);
    if (delegado.language==0) {
        NSString *cont = [NSString stringWithFormat:@"06_%d_en.mp3",contador];
        audioFileName = [NSString stringWithFormat:NSLocalizedString(cont, nil)];
    } else if (delegado.language==1){
        audioFileName = [NSString stringWithFormat:@"06_%d_en.mp3",contador];
    }else if (delegado.language==2){
        audioFileName = [NSString stringWithFormat:@"06_%d_es.mp3",contador];
    }else if (delegado.language==3){
        audioFileName = [NSString stringWithFormat:@"06_%d_de.mp3",contador];
        
    }
    
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:2];
    int k;
    if (contador==3) {
        k=4;
    }else if (contador==5){
        k=6;
    }else if (contador==7){
        k=18;
    }else if (contador==9){
        k=8;
    }
    if (delegado.language==3) {
        k-=2;
    }
    
    for (int i=0; i<=k; i++) {
        NSString *textureName;
        if (i%2==0) {
            textureName=[NSString stringWithFormat:@"lrrhMouth0"];
        }else{
            textureName=[NSString stringWithFormat:@"lrrhMouth1"];
        }
        SKTexture *texture=[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    NSLog(@"%@", audioFileName);
    SKAction *talkSound=[SKAction playSoundFileNamed:audioFileName waitForCompletion:NO];
    SKAction *hablar=[SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *wait=[SKAction waitForDuration:2];
    SKAction *lrrhAnimation=[SKAction sequence:@[wait,talkSound,hablar,hablar,hablar]];
    [lrrh runAction:lrrhAnimation];
    contador+=1;
}

-(void)setUpWolfTalks{
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:2];
    int k;
    if (contador==2) {
        k=6;
    }else if (contador==4){
        k=4;
    }else if (contador==6){
        k=4;
    }else if (contador==8){
        k=18;
    }
    
    for (int i=0; i<=k; i++) {
        NSString *textureName;
        if (i%2==0) {
            textureName=[NSString stringWithFormat:@"wolf0"];
        }else{
            textureName=[NSString stringWithFormat:@"wolf1"];
        }
        SKTexture *texture=[SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    
    NSString *audioFileName;
    if (delegado.language==0) {
        NSString *cont = [NSString stringWithFormat:@"06_%d_en.mp3",contador];
        audioFileName = [NSString stringWithFormat:NSLocalizedString(cont, nil)];
    } else if (delegado.language==1){
        audioFileName = [NSString stringWithFormat:@"06_%d_en.mp3",contador];
    }else if (delegado.language==2){
        audioFileName = [NSString stringWithFormat:@"06_%d_es.mp3",contador];
    }else if (delegado.language==3){
        audioFileName = [NSString stringWithFormat:@"06_%d_de.mp3",contador];
    }

    SKAction *talkSound=[SKAction playSoundFileNamed:audioFileName waitForCompletion:NO];
    SKAction *hablar=[SKAction animateWithTextures:textures timePerFrame:0.10];
    SKAction *wait=[SKAction waitForDuration:2];
    SKAction *wolfAnimation=[SKAction sequence:@[wait,talkSound,hablar,hablar]];
    [wolf runAction:wolfAnimation];
    
    contador+=1;
}

-(void)startNarrator{
    NSString *audioFileName;
    if (delegado.language==0) {
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"06_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"06_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"06_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"06_1_de.mp3";
    }
    [self playNarrator:audioFileName];
    [narratorPlayer play];
}

-(void)playNarrator:(NSString *) filename{
    NSError *error;
    NSURL *narratorURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    narratorPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:narratorURL error:&error];
    [narratorPlayer prepareToPlay];
}

-(void)playBackgroundMusic:(NSString *)filename{
    NSError *error;
    NSURL *backgroundMusicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    backgroundMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops=-1;
    backgroundMusicPlayer.volume=.5;
    [backgroundMusicPlayer prepareToPlay];
}

-(void)nextScene{
    NSString *level = [NSString stringWithFormat:@"Serie_%d_1",delegado.num];
    Scene08 *scene = [Scene08 unarchiveFromFile:level];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene];
}

@end
