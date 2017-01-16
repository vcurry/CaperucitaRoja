//
//  Scene00_1.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 23/9/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene00_1.h"
#import "Scene00.h"
#import "Scene02.h"
#import "Scene03.h"
#import "Scene05.h"
#import "Scene08.h"
#import "Scene13.h"
#import "AppDelegate.h"

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


@implementation Scene00_1{
    SKSpriteNode *buttonConnectDots;
    SKSpriteNode *buttonLab;
    SKSpriteNode *buttonMemory;
    SKSpriteNode *buttonPuzzle;
    SKSpriteNode *buttonSeries;
    SKSpriteNode *buttonBack;
    
    AppDelegate *delegado;
}

-(id)initWithSize:(CGSize)size{
    if (self=[super initWithSize:size]) {
        SKSpriteNode * background=[SKSpriteNode spriteNodeWithImageNamed:@"gameMenu"];
        background.position=CGPointZero;
        background.anchorPoint=CGPointZero;
        background.zPosition = -1;
        [self addChild:background];
        
        delegado = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if (delegado.num < 3) {
            delegado.num += 1;
        }else{
            delegado.num = 1;
        }
        
        buttonBack=[SKSpriteNode spriteNodeWithImageNamed:@"homeButton"];
        buttonBack.zPosition=0;
        if (IDIOM ==IPAD) {
            buttonBack.position=CGPointMake((self.size.width-buttonBack.size.width)-10,self.size.height-buttonBack.size.height-10);
        } else {
            buttonBack.position=CGPointMake((self.size.width-buttonBack.size.width)+20,self.size.height-buttonBack.size.height-70);
        }
        NSLog(@"%f, %f",self.size.width, self.size.height);
        NSLog(@"%f, %f",buttonBack.position.x, buttonBack.position.y);
  //      buttonBack.anchorPoint=CGPointZero;
        [self addChild:buttonBack];
        
        
        buttonPuzzle=[SKSpriteNode spriteNodeWithImageNamed:@"buttonPuzzle"];
        buttonPuzzle.position=CGPointMake((self.size.width - (buttonPuzzle.size.width*3)+(buttonPuzzle.size.width/5)), self.size.height/1.5);
        [self addChild:buttonPuzzle];
        
        buttonConnectDots=[SKSpriteNode spriteNodeWithImageNamed:@"buttonDot"];
        buttonConnectDots.position=CGPointMake((self.size.width - (buttonConnectDots.size.width*2)+(buttonConnectDots.size.width/4)), self.size.height/1.5);
        [self addChild:buttonConnectDots];
        
        buttonLab=[SKSpriteNode spriteNodeWithImageNamed:@"buttonLab"];
        buttonLab.position=CGPointMake((self.size.width - (buttonLab.size.width)+(buttonLab.size.width/3)), self.size.height/1.5);
        [self addChild:buttonLab];
        
        buttonSeries=[SKSpriteNode spriteNodeWithImageNamed:@"buttonSeries"];
        buttonSeries.position=CGPointMake((self.size.width - (buttonSeries.size.width*2.5)+(buttonLab.size.width/4.5)), self.size.height/3);
        [self addChild:buttonSeries];
        
        buttonMemory=[SKSpriteNode spriteNodeWithImageNamed:@"buttonMemory"];
        buttonMemory.position=CGPointMake((self.size.width - (buttonSeries.size.width*1.5)+(buttonLab.size.width/3.5)), self.size.height/3);
        [self addChild:buttonMemory];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches){
        CGPoint location=[touch locationInNode:self];
        if ([buttonPuzzle containsPoint:location]) {
            if (IDIOM ==IPAD) {
                NSLog(@"iPad");
                NSString *fileName = [NSString stringWithFormat:@"Puzzle%d-ipad",delegado.num];
                Scene02 *scene = [Scene02 unarchiveFromFile:fileName];
                scene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:scene];
            }else{
                NSLog(@"iPhone");
                NSString *fileName = [NSString stringWithFormat:@"Puzzle%d-iphone",delegado.num];
                Scene02 *scene = [Scene02 unarchiveFromFile:fileName];
                scene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:scene];
            }
        }else if([buttonConnectDots containsPoint:location]){
            Scene03 *scene=[[Scene03 alloc] initWithSize:self.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:scene];
        }else if([buttonLab containsPoint:location]){
            NSString *fileName = [NSString stringWithFormat:@"Laberinto%d",delegado.num];
            Scene05 *scene = [Scene05 unarchiveFromFile:fileName];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:scene];
        }else if([buttonSeries containsPoint:location]){
            NSString *level = [NSString stringWithFormat:@"Serie_%d_%d",delegado.num, delegado.subnum];
            NSLog(@"level %@",level);
            Scene08 *scene = [Scene08 unarchiveFromFile:level];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:scene];
        }else if([buttonMemory containsPoint:location]){
            Scene13 *scene=[[Scene13 alloc] initWithSize:self.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:scene];
        }else if([buttonBack containsPoint:location]){
            Scene00 *scene=[[Scene00 alloc] initWithSize:self.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:scene];
        }
        
        
        
    }
}

@end

