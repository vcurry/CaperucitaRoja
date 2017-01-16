//
//  Scene08.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 1/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene08.h"
#import "Scene09.h"
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


@implementation Scene08{
    
    NSMutableArray *flores;
    NSMutableArray *dotLines;
    NSMutableArray *buttons;
    int contador;
    
    SKSpriteNode *blueButton;
    SKSpriteNode *whiteButton;
    SKSpriteNode *purpleButton;
    SKSpriteNode *redButton;
    
    SKSpriteNode * flor;
    
    AppDelegate *delegado;
    
    AVAudioPlayer *correctMusicPlayer;
    AVAudioPlayer *instructionsMusicPlayer;
}

-(void)didMoveToView:(SKView *)view{
    delegado = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    flores = [[NSMutableArray alloc] init];
    dotLines = [NSMutableArray array];
    buttons = [NSMutableArray array];
    
    contador = 0;
    
    [self enumerateChildNodesWithName:@"flowerBlue" usingBlock:^(SKNode * node, BOOL * _Nonnull stop) {
        [self insertFlowerInFlores:node button:blueButton];
    }];
    
    [self enumerateChildNodesWithName:@"flowerWhite" usingBlock:^(SKNode * node, BOOL * _Nonnull stop) {
        [self insertFlowerInFlores:node button:whiteButton];
    }];
    
    [self enumerateChildNodesWithName:@"flowerPurple" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        [self insertFlowerInFlores:node button:purpleButton];
    }];
    
    [self enumerateChildNodesWithName:@"flowerRed" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        [self insertFlowerInFlores:node button:redButton];
    }];

    [self enumerateChildNodesWithName:@"dotLine" usingBlock:^(SKNode * node, BOOL * _Nonnull stop) {
        [dotLines addObject:node];
    }];
    
    if (delegado.modoJuego==0 && delegado.subnum==1) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playInstructions) userInfo:nil repeats:NO];
    }

}

-(void)insertFlowerInFlores:(SKNode *)nodo button:(SKSpriteNode *)button{
    if (nodo.position.y == 520) {
        nodo.hidden = YES;
        nodo.userInteractionEnabled = YES;
        BOOL found = false;
        for (int i=0; i<flores.count; i++) {
            SKSpriteNode *flor1 = [flores objectAtIndex:i];
            if ((nodo.position.x < flor1.position.x) && !found) {
                [flores insertObject:nodo atIndex:i];
                found=true;
            }
        }
        if (!found){
            [flores addObject:nodo];
        }

    }else{
        button = (SKSpriteNode *)nodo;
    }

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint = [[touches anyObject] locationInNode:self.scene];
    SKNode *touchedNode = [self nodeAtPoint:touchPoint];
    SKSpriteNode *correctFlower=[flores objectAtIndex:contador];
    if ([touchedNode.name isEqualToString:correctFlower.name]) {
        correctFlower.hidden = NO;
        SKSpriteNode *dotLine = [dotLines objectAtIndex:contador];
        dotLine.hidden = YES;
        contador += 1;
    }
}

-(void)playCorrectMusicPlayer:(NSString *)filename{
    NSError *error;
    NSURL *tirinMusicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    correctMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:tirinMusicURL error:&error];
    correctMusicPlayer.volume=1;
    [correctMusicPlayer prepareToPlay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (contador == flores.count) {
        self.userInteractionEnabled = NO;
        [correctMusicPlayer play];
        (sleep(0.5));
        if (delegado.subnum<3) {
            delegado.subnum += 1;
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(nextLevel) userInfo:nil repeats:NO];
        }else{
            delegado.subnum = 1;
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];
        }

    }
}

-(void)instructionsPlayer:(NSString *) filename{
    NSError *error;
    NSURL *instructionsURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    instructionsMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:instructionsURL error:&error];
    //  instructionsMusicPlayer.volume=8.5;
    [instructionsMusicPlayer prepareToPlay];
}

-(void)playInstructions{
    NSString *audioFileName;
    if (delegado.language==0) {
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"08_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"08_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"08_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"08_1_de.mp3";
    }
    
    [self instructionsPlayer:audioFileName];
    [instructionsMusicPlayer play];
}

-(void)nextLevel{
    NSString *level = [NSString stringWithFormat:@"Serie_%d_%d",delegado.num, delegado.subnum];
    NSLog(@"Scene08 level %@", level);
    Scene08 *scene = [Scene08 unarchiveFromFile:level];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene];
}

-(void)nextScene{
    Scene09 *scene = [Scene09 sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene];
}

@end
