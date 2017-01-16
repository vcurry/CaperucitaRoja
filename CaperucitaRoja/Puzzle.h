//
//  Puzzle.h
//  LittleRedRidingHood
//
//  Created by Verónica Cordobés on 18/3/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"

@interface Puzzle : NSObject

@property(strong,nonatomic) NSString *num;
@property(strong,nonatomic) NSMutableArray *piezas;

-(void) anadirPieza:(Piece *) pieza;
-(id) init;

@end
