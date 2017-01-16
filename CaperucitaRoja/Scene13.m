//
//  Scene13.m Memory Game
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 8/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene13.h"
#import "Scene14.h"
#import "Scene00_1.h"
#import "AppDelegate.h"
#import "Memory.h"

@import AVFoundation;

@implementation Scene13{
    
    SKSpriteNode *card;
    SKSpriteNode *carta00;
    SKSpriteNode *carta01;
    SKSpriteNode *selectedNode;
    
    Memory *memory;
    
    BOOL foundEyes;
    BOOL foundEars;
    BOOL foundSnout;
    BOOL foundTail;
    BOOL foundFeet;
    BOOL foundTeeth;
    
    NSMutableArray *pareja;
    NSMutableArray *cards;
    
    AVAudioPlayer *correctTirin;
    AVAudioPlayer *correctTick;
    
    AVAudioPlayer *instructionsMusicPlayer;
    SKSpriteNode *instButton;
    SKSpriteNode *reloadButton;
    
    int contador;
    int language;
    
    AppDelegate *delegado;
}


-(id)initWithSize:(CGSize)size
{
    if(self=[super initWithSize:size]){
        
        delegado=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        language = delegado.language;
        NSLog(@"cards number %d", delegado.num);
        memory=[delegado.memories objectAtIndex:delegado.num-1];
        
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithImageNamed:@"backgroundScene03"];
        background.position=CGPointZero;
        background.anchorPoint=CGPointZero;
        background.zPosition=-1;
        [self addChild:background];
        
        NSLog(@"modo juego %d", delegado.modoJuego);
        if (delegado.modoJuego==0) {
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playInstructions) userInfo:nil repeats:NO];
        }
        
        pareja=[NSMutableArray array];
        
        contador=0;
        
        cards=[NSMutableArray arrayWithCapacity:11];
        for (int i=0; i<12; i++) {
            SKSpriteNode *cardBack=[SKSpriteNode spriteNodeWithImageNamed:@"cardBack"];
            cardBack.anchorPoint=CGPointZero;
            cardBack.name=@"back";
            Pieza *pieza=[memory.piezas objectAtIndex:i];
            NSString *cardName=[NSString stringWithFormat:@"card%@",pieza.nombreImagen];
            card=[SKSpriteNode spriteNodeWithImageNamed:cardName];
            card.name=cardName;
            card.zPosition=3;
            card.anchorPoint=CGPointZero;
            card.size=CGSizeMake(cardBack.size.width, cardBack.size.height);
            float xgap=(self.size.width-(cardBack.size.width*4))/5;
            float xdistance;
            float ygap=(self.size.height-(cardBack.size.height*3))/4;
            float ydistance;
            if (i<4) {
                xdistance=(xgap*(i+1))+(cardBack.size.width*i);
                ydistance=((ygap*2.3)+(cardBack.size.height*2));
            }else if(i>7){
                xdistance=(xgap*((i%8)+1))+(cardBack.size.width*(i%8));
                ydistance=(ygap*1.7);
            }else{
                xdistance=(xgap*((i%4)+1))+(cardBack.size.width*(i%4));
                ydistance=((ygap*2)+(cardBack.size.height));
            }
            cardBack.position=CGPointMake(xdistance, ydistance);
            card.position=CGPointMake(xdistance, ydistance);
            card.hidden=YES;
            [cards addObject:card];
            [self addChild:cardBack];
            [self addChild:card];
        }
    }
    return self;
}

-(void)instructionsPlayer:(NSString *) filename{
    NSError *error;
    NSURL *instructionsURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    instructionsMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:instructionsURL error:&error];
    [instructionsMusicPlayer prepareToPlay];
}

-(void)playInstructions{
    NSString *audioFileName;
    if (delegado.language==0) {
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"13_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"13_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"13_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"13_1_de.mp3";
    }
    
    [self instructionsPlayer:audioFileName];
    [instructionsMusicPlayer play];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch=[touches anyObject];
    CGPoint location = [touch locationInNode:self];
    if ([instButton containsPoint:location]) {
        [self playInstructions];
    }else if([reloadButton containsPoint:location]){
        Scene13 *scene = [[Scene13 alloc] initWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene];
    }for (int i=0; i<cards.count; i++) {
        SKSpriteNode *cardT=[cards objectAtIndex:i];
        if ([cardT containsPoint:location]) {
            selectedNode=cardT;
            if (![selectedNode.name isEqualToString:@"back"]) {
                [self checkCardPair:selectedNode];
            }
        }
    }
}

-(void)checkCardPair:(SKSpriteNode *)_card{
    _card.hidden=NO;
    if (pareja.count==1 && carta00!=_card) {
        [pareja addObject:_card];
        carta01=_card;
        carta01.hidden=NO;
        if ([carta00.name isEqualToString:carta01.name]) {
            [self fixCards:_card];
            [self playCorrectTickPlayer:@"correct2.mp3"];
            [correctTick play];
            [pareja removeAllObjects];
            contador+=1;
            if (contador<6) {
                [self playCorrectTickPlayer:@"correct2.mp3"];
                [correctTick play];
            }else{
                [self playCorrectTickPlayer:@"tirin.mp3"];
                [correctTick play];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];
            }
        }else{
            [self setUserInteractionEnabled:NO];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideCards) userInfo:nil repeats:NO];
            [pareja removeAllObjects];
        }
    }else if (pareja.count==0){
        [pareja addObject:_card];
        carta00=_card;
    }
    
}

-(void)nextScene{
    if (delegado.num>=2) {
        delegado.num=0;
    }else{
        delegado.num+=1;
    }
    if (delegado.modoJuego==0) {
        Scene14 *scene=[[Scene14 alloc] initWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *transition=[SKTransition fadeWithColor:[UIColor darkGrayColor] duration:2];
        [self.view presentScene:scene transition:transition];
    }else if (delegado.modoJuego==1){
        Scene00_1 *scene=[[Scene00_1 alloc] initWithSize:self.size];
        scene.scaleMode =SKSceneScaleModeAspectFill;
        [self.view presentScene:scene];
    }
}

-(void)fixCards:(SKSpriteNode *)_card{
    for (int i=0; i<cards.count; i++) {
        SKSpriteNode *cardI=[cards objectAtIndex:i];
        if ([_card.name isEqualToString:cardI.name]) {
            _card.name=@"back";
            cardI.name=@"back";
        }
    }
}

-(void)hideCards{
    carta00.hidden=YES;
    carta01.hidden=YES;
    [self setUserInteractionEnabled:YES];
}

-(void)playCorrectTickPlayer:(NSString *)filename{
    NSError *error;
    NSURL *musicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    correctTick=[[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];
    correctTick.volume=0.5;
    [correctTick prepareToPlay];
}

@end
