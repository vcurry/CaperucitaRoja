//
//  Scene07.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 14/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Scene07.h"
#import "Scene12.h"
#import "Scene00_1.h"
#import "AppDelegate.h"
@import AVFoundation;

typedef NS_ENUM(UInt32, CollisionType){
    CollisionTypeKid    = 0x1 << 0,
    CollisionTypeTree   = 0x1 << 1,
    CollisionTypeHouse  = 0x1 << 2,
    CollisionTypeWolf   = 0x1 << 3
};

@implementation Scene07{
    SKSpriteNode *kid;
    SKSpriteNode *trees;
    SKSpriteNode *house;
    SKSpriteNode *wolf;
    
    CGPoint touchPoint;
    
    AVAudioPlayer *instructionsMusicPlayer;
    SKSpriteNode *instButton;
    SKSpriteNode *reloadButton;
    AVAudioPlayer *backgroundMusicPlayer;
    AVAudioPlayer *tirinMusicPlayer;
    
    AppDelegate *delegado;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    delegado = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    [self playBackgroundMusic:@"campo.mp3"];
    [backgroundMusicPlayer play];
    
    [self enumerateChildNodesWithName:@"trees" usingBlock:^(SKNode *node, BOOL *stop) {
        node.physicsBody.affectedByGravity=NO;
        node.physicsBody.categoryBitMask = CollisionTypeTree;
        node.physicsBody.contactTestBitMask = 0;
        node.physicsBody.collisionBitMask = CollisionTypeKid;
    }];
    
    wolf = (SKSpriteNode *)[self childNodeWithName:@"wolf"];
    wolf.physicsBody.categoryBitMask = CollisionTypeWolf;
    wolf.physicsBody.contactTestBitMask = 0;
    wolf.physicsBody.collisionBitMask = CollisionTypeKid;
    
    kid = (SKSpriteNode *)[self childNodeWithName:@"kid"];
    kid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kid.size.width/6];
    kid.position = wolf.position;
    kid.physicsBody.affectedByGravity = NO;
    kid.physicsBody.allowsRotation = NO;
    kid.physicsBody.categoryBitMask = CollisionTypeKid;
    kid.physicsBody.contactTestBitMask = CollisionTypeTree | CollisionTypeWolf | CollisionTypeHouse;
    kid.physicsBody.collisionBitMask = CollisionTypeTree | CollisionTypeWolf | CollisionTypeHouse;
    
    house = (SKSpriteNode *)[self childNodeWithName:@"house"];
    house.physicsBody.categoryBitMask = CollisionTypeHouse;
    house.physicsBody.contactTestBitMask = 0;
    house.physicsBody.collisionBitMask = CollisionTypeKid;
    
    [wolf removeFromParent];
    
    if (delegado.modoJuego==0) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playInstructions) userInfo:nil repeats:NO];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    SKNode *firstNode = contact.bodyA.node;
    SKNode *secondNode = contact.bodyB.node;
    
    uint32_t collision = firstNode.physicsBody.categoryBitMask | secondNode.physicsBody.categoryBitMask;
    
    if(collision == (CollisionTypeKid | CollisionTypeTree)) {
        NSLog(@"Trees collision detected");
        [kid removeAllActions];
        //  kid.physicsBody.velocity = CGVectorMake(0, 0);
    }/**
    else if(collision == (CollisionTypeKid | CollisionTypeWolf)){
        NSLog(@"Animal collision detected");
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];
    }*/
    else if(collision == (CollisionTypeKid | CollisionTypeHouse)){
        NSLog(@"Correcto");
        [kid removeAllActions];
        [kid.physicsBody setDynamic:NO];
        [self playTirinMusic:@"tirin.mp3"];
        [tirinMusicPlayer play];
        [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(nextScene) userInfo:nil repeats:NO];
    }
    else{
        NSLog(@"Error: Unknown collision category %d", collision);
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    touchPoint = [[touches anyObject] locationInNode:self.scene];
    
    CGPoint moveDifference = CGPointMake(touchPoint.x-kid.position.x, touchPoint.y-kid.position.y);
    CGFloat distanceToMove = sqrtf(moveDifference.x*moveDifference.x + moveDifference.y*moveDifference.y);
    
    CGFloat moveDuration = distanceToMove/100;
    SKAction *moveTo = [SKAction moveTo:touchPoint duration:moveDuration];
    [kid runAction: moveTo];
    NSMutableArray *textures=[NSMutableArray arrayWithCapacity:3];
    
    SKTexture *texture0=[SKTexture textureWithImageNamed:@"lrrhFeet1"];
    SKTexture *texture1=[SKTexture textureWithImageNamed:@"lrrhFeet2"];
    SKTexture *texture2=[SKTexture textureWithImageNamed:@"lrrhFeet3"];
    [textures addObject:texture0];
    [textures addObject:texture1];
    [textures addObject:texture2];
    [textures addObject:texture1];
    
    SKAction *walk=[SKAction animateWithTextures:textures timePerFrame:0.1];
    int walkDuration = moveDuration/0.3;
    [kid runAction:[SKAction repeatAction:walk count:(walkDuration)]];
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
        audioFileName = [NSString stringWithFormat:NSLocalizedString(@"05_1_en.mp3", nil)];
    } else if (delegado.language==1){
        audioFileName = @"05_1_en.mp3";
    }else if (delegado.language==2){
        audioFileName = @"05_1_es.mp3";
    }else if (delegado.language==3){
        audioFileName = @"05_1_de.mp3";
    }
    
    [self instructionsPlayer:audioFileName];
    [instructionsMusicPlayer play];
}

-(void)playBackgroundMusic:(NSString *)filename{
    NSError *error;
    NSURL *backgroundMusicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    backgroundMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    backgroundMusicPlayer.numberOfLoops=-1;
    backgroundMusicPlayer.volume=.5;
    [backgroundMusicPlayer prepareToPlay];
}

-(void)playTirinMusic:(NSString *)filename{
    NSError *error;
    NSURL *tirinMusicURL=[[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    tirinMusicPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:tirinMusicURL error:&error];
    tirinMusicPlayer.volume=0.5;
    [tirinMusicPlayer prepareToPlay];
}


-(void)nextScene{
    if (delegado.modoJuego == 0) {
        Scene12 *scene = [[Scene12 alloc] initWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene];
    }else{
        Scene00_1 *scene = [[Scene00_1 alloc] initWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene];
    }
}

@end
