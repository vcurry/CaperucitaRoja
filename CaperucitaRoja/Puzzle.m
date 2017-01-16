//
//  Puzzle.m
//  LittleRedRidingHood
//
//  Created by Verónica Cordobés on 18/3/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "Puzzle.h"

@implementation Puzzle
@synthesize num=num, piezas=piezas;

-(id) init{
    self=[super init];
    if(self){
        self.num=num;
        self->piezas=[NSMutableArray array];
    }
    return self;
}

-(void)anadirPieza:(Piece *)pieza{
    [(NSMutableArray *) self->piezas addObject:pieza];
}


@end
