//
//  Memory.m
//  LittleRedRidingHood
//
//  Created by Verónica Cordobés on 22/4/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "Memory.h"

@implementation Memory
@synthesize num=num, piezas=piezas;

-(id)init{
    self=[super init];
    if(self){
        self.num=num;
        self->piezas=[NSMutableArray array];
    }
    return self;
}

-(void) anadirPieza:(Pieza *)_pieza{
    [(NSMutableArray *) self->piezas addObject:_pieza];
}

@end
