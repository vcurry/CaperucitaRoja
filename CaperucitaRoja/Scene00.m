//
//  Scene00.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 23/9/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene00.h"
#import "Scene01.h"
#import "Scene04.h"
#import "Scene12.h"
#import "Scene06.h"
#import "Scene00_1.h"
#import "AppDelegate.h"
@import AVFoundation;

@implementation Scene00{
    AppDelegate *delegado;
    SKSpriteNode *lrrh;
    AVAudioPlayer *backgroundMusicPlayer;
    AVAudioPlayer *narratorPlayer;
    int language;
    
    NSMutableArray *buttons;
}

-(id)initWithSize:(CGSize)size
{
    if(self=[super initWithSize:size]){
        delegado=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        language=delegado.language;
        
        [self playBackgroundMusic:@"campo.mp3"];
        [backgroundMusicPlayer play];
        
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithImageNamed:@"backgroundScene00"];
        background.anchorPoint=CGPointZero;
        background.position=CGPointZero;
        background.zPosition=-1;
        
        [self addChild:background];
        
        buttons = [NSMutableArray array];
        
        //we start, set up and add all the buttons and titles to the array buttons
        NSString *titleName = [NSString stringWithFormat:NSLocalizedString(@"title_en", nil)];
        CGPoint posTitle = CGPointMake((self.size.width/1.5), (self.size.height-self.size.height/5));
        [self setUpButton:titleName :titleName :posTitle :0.8f :NO];
        [self setUpButton:@"title_en" :@"title_en" :posTitle :0.8f :YES];
        [self setUpButton:@"title_es" :@"title_es" :posTitle :0.8f :YES];
        [self setUpButton:@"title_de" :@"title_de" :posTitle :0.8f :YES];
        
        NSString *buttonStartName = [NSString stringWithFormat:NSLocalizedString(@"buttonStart", nil)];
        CGPoint posStart = CGPointMake(670, 500);
        [self setUpButton:buttonStartName :buttonStartName :posStart :1.0f :NO];
        [self setUpButton:@"buttonStart" :@"buttonStart" :posStart :1.0f :YES];
        [self setUpButton:@"buttonEmpezar" :@"buttonEmpezar" :posStart :1.0f :YES];
        [self setUpButton:@"buttonBeginnen" :@"buttonBeginnen" :posStart :1.0f :YES];
        
        NSString *buttonGamesName = [NSString stringWithFormat:NSLocalizedString(@"buttonGames", nil)];
        CGPoint posGames = CGPointMake(670, 380);
        [self setUpButton:buttonGamesName :buttonGamesName :posGames :1.0f :NO];
        [self setUpButton:@"buttonGames" :@"buttonGames" :posGames :1.0f :YES];
        [self setUpButton:@"buttonJuegos" :@"buttonJuegos" :posGames :1.0f :YES];
        [self setUpButton:@"buttonSpiele" :@"buttonSpiele" :posGames :1.0f :YES];
        
        CGPoint englishPos = CGPointMake(self.size.width/6.5,self.size.height/1.37);
        CGPoint spanishPos = CGPointMake((self.size.width/6.5)+80,self.size.height/1.37);
        CGPoint deutschPos = CGPointMake((self.size.width/6.5)+160,self.size.height/1.37);
        [self setUpButton:@"buttonEnglish" :@"buttonEnglish" :englishPos :0.8f :NO];
        [self setUpButton:@"buttonSpanish" :@"buttonSpanish" :spanishPos :0.8f :NO];
        [self setUpButton:@"buttonDeutsch" :@"buttonDeutsch" :deutschPos :0.8f :NO];

        lrrh=[SKSpriteNode spriteNodeWithImageNamed:@"lrrhEyes0"];
        lrrh.anchorPoint=CGPointZero;
        lrrh.position=CGPointMake(170, 210);
        [self addChild:lrrh];
        [self setUpCharacterAnimation];
        
   /**     SKSpriteNode *lrrh2=[SKSpriteNode spriteNodeWithImageNamed:@"lrrhEyes1"];
        lrrh2.anchorPoint=CGPointZero;
        lrrh2.position=CGPointMake(170, 210);
        [self addChild:lrrh2];*/
    }
    return self;
}

-(void)playBackgroundMusic:(NSString *)filename{
    NSError *error;
    NSURL *backgroundMusicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    backgroundMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops=-1;
    backgroundMusicPlayer.volume=1.0;
    [backgroundMusicPlayer prepareToPlay];
}

-(void)startNarrator{
    NSString *audioFileName;
    if (delegado.language==0) {
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"00_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"00_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"00_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"00_1_de.mp3";
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

//sets up all the buttons and titles
-(void)setUpButton: (NSString *)nombre :(NSString *)imagen :(CGPoint)posicion :(CGFloat)escala :(BOOL)hidden{
    SKSpriteNode *node =[SKSpriteNode spriteNodeWithImageNamed:nombre];
    node.name = nombre;
    node.position = posicion;
    node.hidden = hidden;
    [node setScale:escala];
    [self addChild:node];
    [buttons addObject:node];
}


-(void)setUpCharacterAnimation{
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:2];
    
    SKTexture *texture0=[SKTexture textureWithImageNamed:@"lrrhEyes0"];
    SKTexture *texture1=[SKTexture textureWithImageNamed:@"lrrhEyes1"];
    [textures addObject:texture0];
    [textures addObject:texture1];
    [textures addObject:texture0];
    
    CGFloat duration=2;
    
    SKAction *blink =[SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *wait=[SKAction waitForDuration:duration];
    
    SKAction *mainCharacterAnimation=[SKAction sequence:@[wait,blink,wait,blink,wait,wait,blink,blink]];
    [lrrh runAction:[SKAction repeatActionForever:mainCharacterAnimation]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    SKSpriteNode *touchedNode;
    for (UITouch *touch in touches) {
        CGPoint location=[touch locationInNode:self];
        for (int i=0; i<buttons.count; i++){
            SKSpriteNode *node = [buttons objectAtIndex:i];
            if ([node containsPoint:location]) {
                touchedNode = node;
            }
        }
    }
    [self triggerButton:touchedNode];
}

//sets up the action of each button
-(void)triggerButton: (SKSpriteNode *)touchedNode{
    if ([touchedNode.name isEqualToString:@"buttonStart"] || [touchedNode.name isEqualToString:@"buttonEmpezar"] || [touchedNode.name isEqualToString:@"buttonBeginnen"]) {
        delegado.modoJuego=0;
        Scene01 *scene=[[Scene01 alloc] initWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene];
    } else if ([touchedNode.name isEqualToString:@"buttonGames"] || [touchedNode.name isEqualToString:@"buttonJuegos"] || [touchedNode.name isEqualToString:@"buttonSpiele"]){
        delegado.modoJuego=1;
        Scene00_1 *scene=[[Scene00_1 alloc] initWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene];
    } else if ([touchedNode.name isEqualToString:@"buttonEnglish"]){
        delegado.language = 1;
        [self setForeignLanguage:@"ingles"];
        [self startNarrator];
    }else if ([touchedNode.name isEqualToString:@"buttonSpanish"]){
        delegado.language = 2;
        [self setForeignLanguage:@"español"];
        [self startNarrator];
    }else if ([touchedNode.name isEqualToString:@"buttonDeutsch"]){
        delegado.language = 3;
        [self setForeignLanguage:@"aleman"];
        [self startNarrator];
    }
}

//sets up the language of the app and changes the buttons to the chosen one
-(void)setForeignLanguage: (NSString *)idioma{
    SKSpriteNode *button;
    for (int i=0; i<buttons.count; i++) {
        button = [buttons objectAtIndex:i];
        if([idioma isEqualToString:@"ingles"] && ([button.name isEqualToString:@"title_en"] || ([button.name isEqualToString:@"buttonStart"] || [button.name isEqualToString:@"buttonGames"]))){
            button.hidden=NO;
        }else if([idioma isEqualToString:@"español"] && ([button.name isEqualToString:@"title_es"] || ([button.name isEqualToString:@"buttonEmpezar"] || [button.name isEqualToString:@"buttonJuegos"]))){
            button.hidden=NO;
        }else if([idioma isEqualToString:@"aleman"] && ([button.name isEqualToString:@"title_de"] || ([button.name isEqualToString:@"buttonBeginnen"] || [button.name isEqualToString:@"buttonSpiele"]))){
            button.hidden=NO;
        }else if(![button.name isEqualToString:@"buttonEnglish"] && ![button.name isEqualToString:@"buttonDeutsch"] && ![button.name isEqualToString:@"buttonSpanish"]){
            button.hidden = YES;
        }

    }

}

@end
