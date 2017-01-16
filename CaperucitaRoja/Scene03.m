//
//  Scene03.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 25/9/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene00.h"
#import "Scene00_1.h"
#import "Scene03.h"
#import "Scene04.h"
#import "AppDelegate.h"
@import AVFoundation;

@implementation Scene03 {
    NSMutableArray *_wayPoints;
    CGPoint _velocity;
    BOOL _movingPencil;
    SKSpriteNode *pencil;
    AVAudioPlayer *instructionsMusicPlayer;
    NSArray *posiciones;
    AppDelegate *delegado;
    int contPosiciones;
    
    Posicion *pos;
    
    SKSpriteNode *dots;
    SKSpriteNode *complete;
    
    NSMutableArray *buttons;
    NSArray *lines;
    NSMutableArray *hoods;
    
    SKSpriteNode *nodeLine;
    
    int zcounter;
    
    BOOL red;
    
    AVAudioPlayer *tirinMusicPlayer;
}

-(id)initWithSize:(CGSize)size
{
    if(self=[super initWithSize:size]){
    /* Setup your scene here */
        _wayPoints = [NSMutableArray array];
        
        delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        posiciones = delegado.capucha.posiciones;
        
        contPosiciones = 0;
        
        zcounter = -2;
        hoods = [NSMutableArray array];
     
        [self setUpBackgrounds:@"backgroundScene03" hidden:NO];
        [self setUpBackgrounds:@"dots" hidden:NO];
        [self setUpBackgrounds:@"complete" hidden:YES];
        [self setUpBackgrounds:@"capaBlue" hidden:YES];
        [self setUpBackgrounds:@"capaYellow" hidden:YES];
        [self setUpBackgrounds:@"capaRed" hidden:YES];
        [self setUpBackgrounds:@"capaPurple" hidden:YES];
        
        pencil = [SKSpriteNode spriteNodeWithImageNamed:@"pencil"];
        pencil.name = @"pencil";
        Posicion *pos0 =[posiciones objectAtIndex:contPosiciones];
        pencil.position = pos0.ubicacion;
        pencil.anchorPoint=CGPointZero;
        pencil.zPosition=4;
        [self addChild:pencil];
    
        _movingPencil=false;
        
        buttons = [NSMutableArray array];
        [self setUpButtons:@"buttonBlue" posicion:CGPointMake(890, 600)];
        [self setUpButtons:@"buttonYellow" posicion:CGPointMake(890, 500)];
        [self setUpButtons:@"buttonRed" posicion:CGPointMake(890, 400)];
        [self setUpButtons:@"buttonPurple" posicion:CGPointMake(890, 300)];
        [self setUpButtons:@"buttonFinished" posicion:CGPointMake(890, 150)];
        
        lines = delegado.capucha.lineas;
        for(int i=0; i<lines.count; i++){
            [self addChild:[lines objectAtIndex:i]];
        }
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playInstructions) userInfo:nil repeats:NO];
    }
    return self;
}

//we set up the backgrounds
-(void)setUpBackgrounds:(NSString *)name hidden:(BOOL)hidden{
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:name];
    bgNode.name = name;
    bgNode.position = CGPointZero;
    bgNode.anchorPoint = CGPointZero;
    bgNode.hidden = hidden;
    [self addChild:bgNode];
    
    if ([bgNode.name containsString:@"capa"]) {
        [hoods addObject:bgNode];
    }else{
        bgNode.zPosition = zcounter;
        zcounter += 1;
    }
}

//we set up the buttons
-(void)setUpButtons:(NSString *)name posicion:(CGPoint)posit{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:name];
    node.name = name;
    node.position = posit;
    node.zPosition=1;
    node.userInteractionEnabled=YES;
    node.hidden=YES;
    [buttons addObject:node];
    [self addChild:node];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInNode:self.scene];
    SKNode *touchedNode = [self nodeAtPoint:touchPoint];
    //if touchedNode is the pencil, we move it
    if([touchedNode.name isEqualToString:@"pencil"]){
        pencil.position=touchPoint;
        _movingPencil = true;
    //if it's a button we hide the lines and show the chosen hood color
    } else if ([touchedNode.name containsString:@"button"]){
        for (int j=0; j<lines.count; j++){
            SKNode *linea = [lines objectAtIndex:j];
            linea.hidden = YES;
        }
        [self enumerateChildNodesWithName:@"complete" usingBlock:^(SKNode *node, BOOL *stop) {
            node.hidden = YES;
        }];
        //if the touchedNode is "finished" we check and if the hood is red and go to the next scene
        if ([touchedNode.name containsString:@"Finished"]){
            [self enumerateChildNodesWithName:@"capaRed" usingBlock:^(SKNode *node, BOOL *stop) {
                if (node.isHidden){
                    NSLog(@"Incorrect");
                    [self playTirinMusic:@"error.mp3" volume:0.8];
                    [self->tirinMusicPlayer play];
                }else{
                    NSLog(@"Correct");
                    [self playTirinMusic:@"tirin.mp3" volume:0.5];
                    [self->tirinMusicPlayer play];

                    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];

                }
            }];
        //if touchedNode is a color button, we change the color of the hood
        }else{
            for (int i=0; i<hoods.count; i++) {
                SKNode *capa=[hoods objectAtIndex:i];
                if ([touchedNode isEqualToNode:[buttons objectAtIndex:i]]){
                    capa.hidden = NO;
                }else{
                    capa.hidden = YES;
                }
            }
        }
    }
}

//the path is only drawn if the user touches continuously the screen
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInNode:self.scene];
    if(_movingPencil && contPosiciones<10) {
        pencil.position = touchPoint;
        [self addPointToMove:touchPoint];
        [self drawLines];
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _movingPencil=false;
    CGPoint touchPoint = [[touches anyObject] locationInNode:self.scene];
    NSLog(@"x: %f, y: %f",  touchPoint.x,touchPoint.y);
    /**until the user goes through all the positions, we check every position, if it's correct, we show
     the corresponding line and add 1 to the counter. When it's ready, we remove the pencil from parent,
     enable and show the buttons along with the complete image of the hood.
    */
    if (contPosiciones <10) {
        Posicion *posAnterior = [posiciones objectAtIndex:contPosiciones];
        Posicion *correcto = [posiciones objectAtIndex:(contPosiciones+1)];
        if ([self cercano:touchPoint a:correcto.ubicacion]) {
            NSLog(@"correcto");
            pencil.position = correcto.ubicacion;
            nodeLine = [lines objectAtIndex:contPosiciones];
            nodeLine.hidden = NO;
            contPosiciones+=1;
            if (contPosiciones == 10) {
                [pencil setUserInteractionEnabled:NO];
                [pencil removeFromParent];
                [self playTirinMusic:@"tirin.mp3" volume:0.5];
                [self->tirinMusicPlayer play];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playInstructions1) userInfo:nil repeats:NO];
                [self enumerateChildNodesWithName:@"dots" usingBlock:^(SKNode *node, BOOL *stop) {
                    node.hidden = YES;
                }];
                [self enumerateChildNodesWithName:@"complete" usingBlock:^(SKNode *node, BOOL *stop) {
                    node.hidden = NO;
                }];
                for (int i=0; i<buttons.count; i++) {
                    SKSpriteNode *node = [buttons objectAtIndex:i];
                    node.userInteractionEnabled = NO;
                    node.hidden = NO;
                }
            }
        }else {
            pencil.position = posAnterior.ubicacion;
        }
        NSLog(@"contPosiciones: %d", contPosiciones);
        NSMutableArray *temp = [NSMutableArray array];
        for(CALayer *layer in self.view.layer.sublayers) {
            if([layer.name isEqualToString:@"line"]) {
                [temp addObject:layer];
            }
        }
        [temp makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [self newWayPoints];
    }
}

/**
 * checks if the position choosed by the user is near enough to the correct position
 */

-(BOOL) cercano:(CGPoint)R1 a:(CGPoint)R2{
    const int OFFSET = 40;
    if(R1.x>=R2.x-OFFSET && R1.x<=R2.x+OFFSET && R1.y>=R2.y-OFFSET && R1.y<=R2.y+OFFSET){
        return YES;
    }
    return NO;
}


- (void)drawLines {
    //3 Each pig has a CAShapeLayer
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.name = @"line";
    lineLayer.strokeColor = [UIColor grayColor].CGColor;
    lineLayer.fillColor = nil;
    
    //4 we add a path for each pig and add it to the pig. We then call CGPathRelease to free
    //the path's memory
    CGPathRef path = [self createPathToMove];
    lineLayer.path = path;
    CGPathRelease(path);
    [self.view.layer addSublayer:lineLayer];
}

/**
 * adds the points to _wayPoints. To store a CGPoint in an NSArray we have to use NSVALUE valueWithCGPoint
 */
- (void)addPointToMove:(CGPoint)point {
    [_wayPoints addObject:[NSValue valueWithCGPoint:point]];
}

- (CGPathRef)createPathToMove {
    //1 we create a path where we can add the points
    CGMutablePathRef ref = CGPathCreateMutable();
    
    //2iterates the stored waypoints to build the path
    for(int i = 0; i < [_wayPoints count]; ++i) {
        CGPoint p = [_wayPoints[i] CGPointValue];
        p = [self.scene convertPointToView:p];
        //3if the path is just starting, we move to the first point
        if(i == 0) {
            CGPathMoveToPoint(ref, NULL, p.x, p.y);
        }
        //else, we draw the line
        else {
            CGPathAddLineToPoint(ref, NULL, p.x, p.y);
        }
    }
    
    return ref;
}

- (void)newWayPoints{
    [_wayPoints removeAllObjects];
}

-(void)nextScene{
    if (delegado.modoJuego==0) {
        Scene04 *scene=[Scene04 sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *sceneTransition =[SKTransition fadeWithColor:[UIColor darkGrayColor] duration:1];
        [self.view presentScene:scene transition:sceneTransition];
    }else if(delegado.modoJuego==1){
        Scene00_1 *scene=[[Scene00_1 alloc] initWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene];
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
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"03_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"03_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"03_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"03_1_de.mp3";
    }
    
    [self instructionsPlayer:audioFileName];
    [instructionsMusicPlayer play];
}

-(void)playInstructions1{
    NSString *audioFileName;
    if (delegado.language==0) {
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"03_2_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"03_2_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"03_2_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"03_2_de.mp3";
    }
    
    [self instructionsPlayer:audioFileName];
    [instructionsMusicPlayer play];
}


-(void)playTirinMusic:(NSString *)filename volume:(float)vol{
    NSError *error;
    NSURL *tirinMusicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    tirinMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:tirinMusicURL error:&error];
    tirinMusicPlayer.volume=vol;
    [tirinMusicPlayer prepareToPlay];
}

@end
