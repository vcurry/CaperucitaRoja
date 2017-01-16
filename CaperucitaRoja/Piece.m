//
//  Piece.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 7/10/15.
//  Copyright © 2015 Verónica Cordobés. All rights reserved.
//

#import "Piece.h"

@implementation Piece
@synthesize num=num, posInicial=posInicial, posFinal=posFinal;

-(id) init{
    self=[super init];
    if(self){
        self.num=num;
        self.posInicial=posInicial;
        self.posFinal=posFinal;
    }
    return self;
}
@end
