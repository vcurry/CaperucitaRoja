//
//  Capucha.h
//  LittleRedRidingHood
//
//  Created by Verónica Cordobés on 13/2/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Posicion.h"

@interface Capucha : NSObject

@property (copy,nonatomic) NSString * num;
@property NSString * imagen;
@property (strong,readonly, nonatomic) NSArray * posiciones;
@property (strong,readonly, nonatomic) NSArray * lineas;


-(void) anadirPosicion:(Posicion *) posicion;
-(void)anadirLinea:(SKSpriteNode *) linea;
-(id) init;

@end
