//
//  Scene01_1.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 13/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene01_1.h"
#import "Scene03.h"
#import "AppDelegate.h"


@import AVFoundation;

@implementation Scene01_1{
    AVAudioPlayer *backgroundMusicPlayer;
    SKSpriteNode *lrrh;
    SKSpriteNode *mother;
    SKSpriteNode *mouse;
    int language;
    AppDelegate *delegado;
}

-(id)initWithSize:(CGSize)size
{
    if(self=[super initWithSize:size]){
        delegado=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        language = delegado.language;
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background01_1"];
        background.position=CGPointZero;
        background.anchorPoint=CGPointZero;
        background.zPosition=-1;
        [self addChild:background];
        [NSTimer scheduledTimerWithTimeInterval:1.25 target:self selector:@selector(startBackgroundMusic) userInfo:nil repeats:NO];
        
        lrrh=[SKSpriteNode spriteNodeWithImageNamed:@"lrrh0"];
        lrrh.anchorPoint=CGPointZero;
        lrrh.position=CGPointMake(120, 100);
        
        mother=[SKSpriteNode spriteNodeWithImageNamed:@"mother0"];
        mother.anchorPoint=CGPointZero;
        mother.position=CGPointMake(420, 100);
        
        [self addChild:lrrh];
        [self addChild:mother];
        
        [self setUpBlinkAnimation:lrrh con:@"lrrh0" y:@"lrrh1" durante:4];
        [self setUpBlinkAnimation:mother con:@"mother0" y:@"motherEyes" durante:6];
        
        mouse=[SKSpriteNode spriteNodeWithImageNamed:@"mouse0"];
        mouse.position=CGPointMake(970, 230);
        [self addChild:mouse];
        [self setUpMouseAnimation];
        
        
        [NSTimer scheduledTimerWithTimeInterval:1.25 target:self selector:@selector(setUpMotherAnimation) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(transition) userInfo:nil repeats:NO];
        
    }
    
    return self;
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
    NSMutableArray *textures2=[NSMutableArray array];
    for (int i=3; i>=0; i--) {
        NSString *textureName=[NSString stringWithFormat:@"mouse%d",i];
        SKTexture *texture=[SKTexture textureWithImageNamed:textureName];
        [textures2 addObject:texture];
    }
    
    SKAction *wait=[SKAction waitForDuration:4.5];
    SKAction *moveBack=[SKAction animateWithTextures:textures2 timePerFrame:0.10];
    SKAction *mouseAnimation=[SKAction sequence:@[wait,moveBack]];
    [mouse runAction:mouseAnimation];
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
    backgroundMusicPlayer.volume=.03;
    [backgroundMusicPlayer prepareToPlay];
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
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"01_1_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"01_1_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"01_1_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"01_1_1_de.mp3";
    }
    
    SKAction *talkSound=[SKAction playSoundFileNamed:audioFileName waitForCompletion:NO];
    SKAction *hablar=[SKAction animateWithTextures:textures timePerFrame:0.15];
    SKAction *wait=[SKAction waitForDuration:0.3];
    SKAction *motherAnimation=[SKAction sequence:@[wait,talkSound,hablar,hablar]];
    [mother runAction:motherAnimation];
}


-(void)transition{
    Scene03 *scene=[[Scene03 alloc] initWithSize:self.size];
    SKTransition *sceneTransition =[SKTransition fadeWithColor:[UIColor darkGrayColor] duration:1];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene transition:sceneTransition];
}

@end
