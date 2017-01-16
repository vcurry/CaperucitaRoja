//
//  Scene02.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 1/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene02.h"
#import "Scene00_1.h"
#import "Scene01_1.h"
#import "Scene01.h"
#import "AppDelegate.h"
#import "Puzzle.h"
#import "Piece.h"
@import AVFoundation;

@import AVFoundation;

#define IDIOM   UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad


@implementation Scene02{
    SKSpriteNode *complete;
    
    AppDelegate *delegado;
    NSMutableArray *piezas;
    Piece *touchedNode;
    Piece *correctPiece;
    Puzzle *puzzle;
    int contador;
    Piece *prueba;
    
    AVAudioPlayer *instructionsMusicPlayer;
    AVAudioPlayer *correctMusicPlayer;
    SKSpriteNode *instButton;
    
    AVAudioPlayer *tirinMusicPlayer;
}

-(void)didMoveToView:(SKView *)view{
        
    complete = (SKSpriteNode *)[self childNodeWithName:@"complete"];
    complete.hidden = YES;
    
    delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    int puzzleIndex=0;
    if (IDIOM == IPAD) {
        puzzleIndex =1;
    }else{
        puzzleIndex =0;
    }
    NSLog(@"idiom: %d", puzzleIndex);

    puzzle = [delegado.puzzles objectAtIndex:puzzleIndex];
    
    piezas = [NSMutableArray array];
    SKNode *node;
    contador = 0;
    for (int i=0; i<puzzle.piezas.count; i++) {
        NSString *numPieza = [NSString stringWithFormat:@"piece%d",i+1];
        node = [self childNodeWithName:numPieza];
        //Guardamos en el array de datos de piezas el nombre del nodo y su posición inicial en .sks
        Piece *pieza = [puzzle.piezas objectAtIndex:i];
        pieza.posInicial = node.position;
        pieza.name = node.name;
        //Creamos un Spritenode con el nodo del .sks
        SKSpriteNode *puzzlePiece = (SKSpriteNode *)node;
        if ([self cercano:pieza.posInicial a:pieza.posFinal]) {
            puzzlePiece.userInteractionEnabled = YES;
            [piezas addObject:puzzlePiece];
        }else{
           puzzlePiece.userInteractionEnabled = NO;
            contador +=1;
            [piezas addObject:puzzlePiece];
        }
        NSLog(@"pieza %@ added", pieza.name);
    }
    
    if (delegado.modoJuego==0) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playInstructions) userInfo:nil repeats:NO];
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [self selectNodeForTouch:location];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    touchedNode.position=[[touches anyObject] locationInNode:self];
}

/**
 * when the piece is near enough to the correct place, we place it and set the counter. Else, piece
 * goes back to the starting point. If it's the last correct piece, we go to the next scene.
 */
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint endPosition=[[touches anyObject] locationInNode:self];
    touchedNode.zPosition =3;
    if ([self cercano:endPosition a:correctPiece.posFinal]) {
        touchedNode.position=correctPiece.posFinal;
        contador-=1;
        touchedNode.userInteractionEnabled = YES;
    }else{
        touchedNode.position=correctPiece.posInicial;
    }
    if (contador==0) {
        touchedNode.position=correctPiece.posFinal;
      //  contador+=1;
        touchedNode.zPosition=1;
        touchedNode=nil;
        [touchedNode removeFromParent];
        complete.hidden = NO;
        [self playTirinMusic:@"tirin.mp3"];
        [tirinMusicPlayer play];
        [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];

    }
    
    touchedNode.zPosition=1;
    touchedNode=nil;
}

-(void)nextScene{
    if (delegado.modoJuego==0) {
        Scene01_1 *scene=[Scene01_1 sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *sceneTransition =[SKTransition fadeWithColor:[UIColor darkGrayColor] duration:1];
        [self.view presentScene:scene transition:sceneTransition];
    }else if(delegado.modoJuego==1){
        Scene00_1 *scene=[[Scene00_1 alloc] initWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene];
    }
}


-(void)selectNodeForTouch:(CGPoint)location{
    SKSpriteNode *selectedNode = (SKSpriteNode *)[self nodeAtPoint:location];
    for (int i=0; i<piezas.count; i++) {
        Piece *piece=[piezas objectAtIndex:i];
        if ([selectedNode.name isEqualToString:piece.name]) {
            touchedNode = piece;
            touchedNode.zPosition = 16;
            touchedNode.physicsBody.velocity=CGVectorMake(0, 0);
            touchedNode.physicsBody.angularVelocity = 0;
            correctPiece = [puzzle.piezas objectAtIndex:i];
        }
    }
}


-(BOOL) cercano:(CGPoint)R1 a:(CGPoint)R2{
    const int OFFSET = 35;
    if(R1.x>=R2.x-OFFSET && R1.x<=R2.x+OFFSET && R1.y>=R2.y-OFFSET && R1.y<=R2.y+OFFSET){
        return YES;
    }
    return NO;
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
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"02_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"02_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"02_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"02_1_de.mp3";
    }
    
    [self instructionsPlayer:audioFileName];
    [instructionsMusicPlayer play];
}

-(void)playTirinMusic:(NSString *)filename{
    NSError *error;
    NSURL *tirinMusicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    tirinMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:tirinMusicURL error:&error];
    tirinMusicPlayer.volume=0.5;
    [tirinMusicPlayer prepareToPlay];
}


@end
