//
//  Capucha.m
//  LittleRedRidingHood
//
//  Created by Verónica Cordobés on 13/2/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "Capucha.h"

@implementation Capucha

@synthesize num=num, posiciones=posiciones, imagen=imagen, lineas=lineas;

-(id) init{
    self=[super init];
    if(self){
        self.num=num;
        self->posiciones=[NSMutableArray array];
        self->lineas=[NSMutableArray array];
        self.imagen=imagen;
    }
    return self;
}

-(void)anadirPosicion:(Posicion *)posicion{
    [(NSMutableArray *) self->posiciones addObject:posicion];
}

-(void)anadirLinea:(SKSpriteNode *)linea{
    [(NSMutableArray *) self->lineas addObject:linea];
}


@end
